---
title: MongoDB Master&Slave
date: 2013-04-21 10:48:53
updated: 2013-04-21 10:48:53
categories:
- db
tags:
- dev
- db
- mongodb
- 同步
---
# 主从同步

{% label primary@主服务器 %}192.168.1.5 /Win2003
{% label primary@从服务器 %}192.168.1.25 /WinXP

1. 建立数据库目录

   主服务器：D:\Database\MongoDB\db_master

   从服务器：D:\Database\MongoDB\db_slave

2. 分别启动主从服务器

   1. 启动主服务器：

     ```shell
     mongod -dbpath D:\Database\MongoDB\db_master -port 1000 -master
     ```

     > 指定数据存放路径：D:\Database\MongoDB\db_master
     >
     > 指定端口为 ：1000

   1. 启动从服务器：

     ```bash
     mongod –dbpath D:\Database\MongoDB\db_slave –source 192.168.1.5:1000 –port 1001 –slave –slavedelay 10
     ```

     > 指定数据存放路径：D:\Database\MongoDB\db_slave
     >
     > 主数据库地址为：192.168.1.5:1000 
     >
     > 每隔10秒同步一次 

3. 登陆slave从数据库服务器，在slave上添加主机信息：

  ```shell
  mongo 192.168.1.25：1001
  ```

4. 加入主机:

   ```csharp
   db.sources.insert( { host:192.168.1.5 } ); 
   ```

5. 在slave从数据库服务器上查看是否和主机连接配置正确

  ```csharp
  db.printSlaveReplicationInfo(); 
  ```

   如果成功将会出现以下信息

  ```shell
  source: 192.168.1.5:1000
  syncedTo: Fri Mar 26 2010 12:55:19 GMT+0800
  = -10secs ago (0hrs)
  \>
  ```

6. 测试主从

7. 在主服务器新建数据库

   ```sell
   mongo -port 1000
   show dbs
   use testdb
   db.blog.save({title:"new article"})
   ```

8. 在从服务器上查看同步数据

   ```shell
   mongo -port 1001
   show dbs
   use testdb
   db.blog.find()
   ```

   

# 备份与恢复

1. 备份数据库：

   语法：`mongodump -h IP:端口 -d 数据库 -o 文件存在路径`

   ```shell
   mongodump -h 127.0.0.1:10000 -d testdb -o D:\Database\Mongo\backup
   ```

   `-h`：MongDB所在服务器地址，例如：127.0.0.1，当然也可以指定端口号：127.0.0.1:1000

   `-d`：需要备份的数据库实例，例如：testdb

   `-o`：备份的数据存放位置，例如：D:\Database\Mongo\backup，当然该目录需要提前建立，在备份完成后，系统自动在dump目录下建立一个test目录，这个目录里面存放该数据库实例的备份数据。

    

   出现以下提示说明备份成功 

   ```shell
   connected to: 127.0.0.1 DATABASE: testdb to /data/dump/testdb
   testdb.blog to /data/dump/testdb/blog.bson
   1 objects
   testdb.system.indexes to /data/dump/testdb/system.indexes.bson
   1 objects
   ```

   ![img](https://images0.cnblogs.com/blog/371766/201304/21215921-900c517e1f804053963aff637d7b9d9b.png)

2. 恢复数据库：

   语法：mongorestore -h IP -d 目标库 -drop -directoryperdb 源文件

   ```bash
   mongorestore -h 127.0.0.1 -d testdb -directoryperdb D:\Database\Mongo\backup\testdb
   ```

   `-h`：MongoDB所在服务器地址

   `-d`：需要恢复的数据库实例，例如：testdb，当然这个名称也可以和备份时候的不一样，比如test2

   `-directoryperdb`：备份数据所在位置，例如：c:\data\dump\test，这里为什么要多加一个test，而不是备份时候的dump，读者自己查看提示吧！

   `-drop`：恢复的时候，先删除当前数据，然后恢复备份的数据。就是说，恢复后，备份后添加修改的数据都会被删除，慎用哦！

   ![img](https://images0.cnblogs.com/blog/371766/201304/21215921-6d6a820a7d214b1f8da9d60d2212b6e7.png)

   3、另外mongodb还提供了mongoexport 和 mongoimport 这两个命令来导出或导入数据，导出的数据是json格式的。也可以实现备份和恢复的功能。例：

   ```bash
   mongoexport -d mixi_top_city_prod -c building_45 -q '{ "uid" : "10832545" }' > mongo_10832545.bson
   mongoimport -d mixi_top_city -c building_45 --file mongo_10832545.bson
   ```

   `-d` 数据库

   `-c` 集合

   `-f` 字段

   `-type` 数据文件类型（不知道使用BSON是否可以加快速度）

   `-file` 导入文件