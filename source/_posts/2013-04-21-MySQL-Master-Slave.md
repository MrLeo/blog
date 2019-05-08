---
title: MySQL Master&Slave
categories:
  - db
tags:
  - dev
  - db
  - mysql
  - 同步
abbrlink: 9bbb994f
date: 2013-04-21 10:48:37
updated: 2013-04-21 10:48:37
---

# 运行环境

- {% label primary@主机 %}：

  Master 操作系统：Windows 2003 x64

  IP 地址：192.168.1.5

  数据库版本：mysql-essential-5.1.61 x64

- {% label @从机 %}：

  Slave 操作系统：Windows XP x32

  IP 地址：192.168.1.25

  数据库版本：mysql-essential-5.1.61 x32

<!--more-->

# MySQL 单向同步复制

## 准备

注意：由于 MySQL 不同版本之间的(二进制日志)binlog 格式可能会不一样，因此最好的搭配组合是 Master 的 MySQL 版本和 Slave 的版本相同或者更低，Master 的版本肯定不能高于 Slave 版本。

分别登陆 Master 和 Slave 的 MySQL 创建数据库：

```shell
create database repl;
```

## 设置主服务器

- 修改数据库的配置文件(Linux 默认名为 my.cnf; windows 默认名为 my.ini)，在[mysqld]下面增加以下几行：

  ```mysql
  log-bin=log #设置需要记录log

  server-id=1 #标识为主服务器数据库编号
  binlog-do-db=root #需要同步的数据库，如果没有本行，即表示同步所有的数据库

  binlog-ignore-db=mysql //被忽略的数据库
  ```

- 在 Master 机上为 Slave 机添加一个同步帐号

  ```shell
  grant replication slave on *.* to 'root'@'192.1681.25' identified by '123456';
  ```

  重新启动 Master 机的 MySQL 服务。

- 在 Master 机上进入 MySQL 查看日志情况：

  ```mysql
  mysql>show master status;
  ```

  显示信息如下：

  ```mysql
  +-----------------+------------+-------------------+-----------------------+
  | File | Position | Binlog_Do_DB | Binlog_Ignore_DB |
  +-----------------+------------+-------------------+-----------------------+
  | log.000003 | 106 | repl | mysql |
  +-----------------+------------+-------------------+-----------------------+
  1 row in set (0.00 sec)
  ```

# 设置从服务器

- 同样在 my.ini 文件中[mysqld] 字段下添加如下内容：

  ```mysql
  server-id=2 #从服务器标识ID，不能和主服务器重复
  master-host=192.168.1.5 #主服务器地址/主服务器名
  master-user=root #同步主服务器账户名
  master-password=123456 #同步主服务器帐户密码
  master-port=3306 #主服务器的 TCP/IP 端口号，默认是3306
  master-connect-retry=10 #设置在和主服务器连接丢失的时候,重度的时间间隔.
  replicate-do-db=repl #同步的数据库，不写本行表示同步所有数据库
  ```

  然后重启 slave 机的 mysql 。

- 接下来在 Slave 上检验一下是否能正确连接到 Master 上，并且具备相应的权限。

  在从服务器连接到主服务器 MySQL，

  ```shell
  root$mysql -hroot -urep -p123456
  ```

  ```mysql
  mysql>SHOW GRANTS;
  ```

  ```mysql
  +------------------------------------------------------------------------------+
  |Grants for root@192.168.1.25 |
  +------------------------------------------------------------------------------+
  | GRANT Select, FILE, REPLICATION SLAVE ON *.* TO 'root'@'192.168.1.25' IDENTIFIED     BY PASSWORD '*9FF2C222F44C7BBA5CC7E3BE8573AA4E1776278C' |
  +------------------------------------------------------------------------------+
  ```

- 现在，可以启动 Slave 了。启动成功后，登录 Slave，查看一下同步状态：

  ```mysql
  mysql>start slave;
  mysql>show slave status\G;
  ```

  如果 Slave_IO_Running、Slave_SQL_Running 状态为 Yes 则表明设置成功。

  ![img](https://image.xuebin.me/006tNc79ly1ftphe0lcmoj306900v08p.jpg)

  查看当前 mysql 查询进程,显示完整的 SQL 命令

  ```mysql
  mysql>show processlist\G
  ```

# 出现问题

- 修改完配置文件如启动 MySQL 服务失败，错误编号 1067

  将配置文件 my.ini 中的`default-storage-engine=InnoDB`，修改为`default-storage-engine=MyISAM`

- 当我在执行 start slave 这条命令时，系统提示

  ```shell
  "ERROR 1200 (HY000): The server is not configured as slave; fix in config file or with CHANGE MASTER TO，"
  ```

  执行

  ```mysql
  slave stop;
  ```

  再执行

  ```mysql
  change master to
  master_host='192.168.1.5',
  master_user='root',
  master_password='123456',
  master_port=3306,
  master_log_file='log.000003',
  master_log_pos=106;
  ```

  然后执行

  ```mysql
  slave start;
  ```

  再执行

  ```mysql
  show slave status\G
  ```

- "Slave_IO_Running: Yes" / "Slave_SQL_Running:No"

  - 解决办法一：

    ```mysql
    Slave_SQL_Running: No
    ```

    1. 程序可能在 slave 上进行了写操作

    1. 也可能是 slave 机器重起后，事务回滚造成的.
       解决办法：

       ```mysql
       mysql> slave stop;
       mysql> set GLOBAL SQL_SLAVE_SKIP_COUNTER=1;
       mysql> slave start;
       ```

    > 方法一说白了就是如果碰到错误的 sql 执行语句的时候，故障的表象是 slave 不会去同步主库，所以要手工让这个语句不去执行，跳 N 个事件步骤后处理下一个事件，而这个跳过去的事件对数据完整性是没什么影响的。一般设置`SET GLOBAL sql_slave_skip_counter = 1`（1 可以为 N.）就可以过去了，如果过不去，就要具体判断要跳多少步才能正确了。

  - 解决办法二：

    首先停掉 Slave 服务：

    ```mysql
    slave stop;
    ```

    到主服务器上查看主机状态：记录 File 和 Position 对应的值，进入 master 服务器

    ```mysql
    mysql> show master status;
    +-------------+----------+--------------+------------------+
    | File | Position | Binlog_Do_DB | Binlog_Ignore_DB |
    +-------------+----------+--------------+------------------+
    | log.000003 | 106 | | |
    +----------------------+----------+--------------+------------------+
    1 row in set (0.00 sec)
    ```

    > 方法二是强制性从某一个点开始同步,会有部分没有同步的数据丢失,后续主服务器上删除记录同步也会有一些错误信息,不会影响使用.

# 测试同步是否成功

- 在主服务器上面新建一个表，必须在选择同步的数据库下

  ```mysql
  mysql> use repl
  Database changed
  mysql> create table test(id int,name char(10));
  Query OK, 0 rows affected (0.00 sec)
  mysql>
  mysql> insert into test values(1,'zaq');
  Query OK, 1 row affected (0.00 sec)
  mysql>
  mysql> select * from test;
  +------+------+
  | id | name |
  +-------+------+
  | 1 | zaq |
  +-------+------+
  2 rows in set (0.00 sec)
  ```

- 在从服务器查看是否同步过来

  ```mysql
  mysql> use repl;
  Database changed
  mysql> select * from test;
  +------+------+
  | id | name |
  +------+------+
  | 1 | zaq |
  | 1 | xsw |
  +------+------+
  2 rows in set (0.00 sec)
  ```

  说明已经配置成功。

- 测试同步速度

  Read_Master_Log_Pos 和 Exec_Master_Log_Pos 位置之间的时间差值吧.

  这个值只能在一定程度上说明复制良好，但是经常不准确，比如主从之间网络环境很差的时候，可能主和从的数据差异很大，但是复制过来的日志都能被 slave 的 sql 线程执行完成，seconds_behind_master 此时为 0。

  可以通过在主上 show master status\G 的 Position,和从执行 show slave status\G 的 Read_Master_Log_Pos 和 Exec_Master_Log_Pos 进行比较得出复制是否能跟上主的状态。

- 还需要做的一些优化与监视:

  ```mysql
  show full processlist; //查看mysql当前同步线程号
  skip-name-resolve //跳过dns名称查询，有助于加快连接及同步的速度
  max_connections=1000 //增大Mysql的连接数目，(默认100)
  max_connect_errors=100 //增大Mysql的错误连接数目,(默认10)
  ```
