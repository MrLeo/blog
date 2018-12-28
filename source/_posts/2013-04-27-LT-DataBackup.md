---
title: 自动备份（支持MySQL，MSSQL，文本文件） - LT.DataBackup
categories:
  - db
tags:
  - dev
  - db
  - mysql
  - 备份
abbrlink: 70bcbd9f
date: 2013-04-27 12:17:22
updated: 2013-04-27 12:17:22
---

# 概述

在Window系统下使用的数据库份工具，轻量级，简单易用。使用工厂模式开发，可以扩展支持其它类型数据的备份操作，目前支持：

- 支持数据库：MSSQL、MySQL
- 支持本地文件（完整复制或差异化备份）
- 支持备份后的文件压缩，节省硬盘空间
- 支持备份后的文件二次上传至FTP或其它共享目录

<!--more-->

# 使用介绍

1. 下载安装包，解压后，对`LT.DataBackup.exe.config`配置内容，说明如下: 

   备份组件配置

   ```xml
   <ReadAddIns>
   <!--
   支持三种方式备份文件
   公共属性：
   type： MSSQL \ MySQL \ Copy (三种处理方式)
   timer： 备份时间，格式为HH:mm。支持多个，如 09:00,12:00,18:00,--:-- 表示任何时间，00:00表示在启动时运行一次
   compress： 是否压缩，ture表示使用zip压缩
   to： 备份后的文件保存在哪里(不带后缀名)，支持日期转换，如 MSSQL\name_(yyyy-MM-dd,HHmm)
   send： 备份完毕后，使用哪种方式把文件发送走(为空时表示不使用发送，仅本地保存)
   enable： 是否启用
   MSSQL：从MSSQL数据库备份出bak文件
   username：
   password：
   server： MSSQL服务器地址
   database： 需要备份的数据库库名
   MySQL：从MySQL数据库备份出sql文件（含有结构和数据）
   username：
   password：
   server： MySql服务器地址
   database： 需要备份的数据库库名
   Copy：从一个文件夹复制到另外一个文件夹
   from： 复制源文件
   subfolder： 是否包括子文件夹
   difference：是否只复制有差异的文件(差分模式)
   direct: 是否直接压缩(启用压缩的前提下)，如果启用则不能使用差分模式
   -->
   <add name="mssql_basedata" type="MSSQL" timer="09:00,12:00,18:00,20:51" username="sa" password="123456" server="192.168.1.251" database="bpo_base_data" to="MSSQL\basedata_(yyyy-MM-dd,HHmm)" compress="true" send="ftp1" enable="false" />
   <add name="mysql_lt_ps" type="MySQL" timer="09:00,12:00,18:00,20:55" username="root" password="123456" server="192.168.56.101" database="lt_ps" to="MySQL\lt_ps_(yyyy-MM-dd,HHmm)" compress="true" send="ftp1" enable="false"/>
   <add name="copyVSS-dev" type="Copy" timer="23:00,20:55" from="D:\test" to="VSS\test_(yyyy-MM-dd,HHmm)" subfolder="true" difference="true" direct="true" compress="true" send="ftp1" enable="true" />
   <ReadAddIns/>
   ```

   发送组件配置

   ```xml
   <SendAddIns>
   <!--
   支持两种方式备份到别的地方
   公共属性：
   type： MSSQL \ MySQL \ Copy (三种处理方式)
   enable： 是否启用
   Share：通过共享目录把文件复制过去
   username： 共享登录用户名
   password： 共享登录的密码
   remotepath：共享储存的目录
   FTP：通过FTP把备份后的文件发送出去
   username： FTP连接的用户名
   password： FTP连接的密码
   remotepath：上传到FTP的目录
   -->
   <add name="share1" type="Share" username="administrator" password="123456" server="192.168.1.249" remotepath="\d$\sharebackup" enable="true" />
   <add name="ftp1" type="FTP" username="upload" password="123456" server="192.168.1.249" remotepath="ftpbackup" enable="true" />
   </SendAddIns>
   ```

   其它配置

   ```xml
   <appSettings>
   <!--备份到本地的根目录-->
   <add key="BackupRootPath" value="D:\lt.databackup\data\"/>
   <!--本地备份最大的储存天数(超过天数则自动删除)-->
   <add key="BackupMaxDays" value="30"/>
   </appSettings>
   ```

1. 确认配置无误后，点击`Install.bat`进行安装

	![img](https://ws4.sinaimg.cn/large/006tNc79ly1ftph3704yej305z05aq2q.jpg)

	安装后，程序作为系统服务进驻到系统中。

3. 检查文件是否正常输出

  - 检查文件是否正常输出。

  - 检查EXE同目录的Log文件夹下是否含有日志，并检查是否正常即可。

    备份后的效果：

|                                                              |                                                              |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| ![img](https://ws2.sinaimg.cn/large/006tNc79ly1ftph333v5qj306902wglg.jpg) | ![img](https://ws4.sinaimg.cn/large/006tNc79ly1ftph2v479zj305l04rmwy.jpg) |



# 下载地址

- [exe 运行程序 (Release)](https://image.xuebin.me/LT.DataBackup/LT.DataBackup-EXE.rar)
- [开发代码源程序](https://image.xuebin.me/LT.DataBackup/LT.DataBackup-SourceCode.rar)


> {% label danger@原文 %}：http://www.lanxe.net/soft/LT.DataBackup/default.aspx