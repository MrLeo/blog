---
title: 使用sourceTree回滚git代码到历史节点
date: 2018-11-19 11:45:47
updated: 2018-11-19 11:45:47
categories: 工具
tags:
- sourcetree
- git
---

# 前记

回滚git代码好几次了，但是每次总是忘记回滚的步骤，每次都要再想一下，试一下。今天又回滚代码了，索性就记录一下。

# 问题

将当前代码回滚到某次历史提交。 
本文示例：从master 回滚到 “回滚“ 历史节点。

<!--more-->

# 操作

1. 在需要回滚的分支`右键`选择`将master重置到这次提交`，选择`重置（强行合并）`到需要回滚的历史节点。

   如图将master 回滚到 “回滚“ 历史节点。 

   ![](https://ws1.sinaimg.cn/large/006tNbRwly1fxd8hohmqfj314c0j4wiv.jpg)

1. 再次重置(软合并)到当前分支**`最新`**的节点。 
   如图将“回滚“历史节点再重置到”origin/master”的最新节点。

   ![](https://ws1.sinaimg.cn/large/006tNbRwly1fxd8jg5hhej31ay0emwiw.jpg)

1. 此时在“文件状态“中即可获取到从历史节点到当前节点的所有修改记录 

   ![](https://ws4.sinaimg.cn/large/006tNbRwly1fxd8jop1zuj31bk0mcad3.jpg)

1. 此时可以重置（或按照需求修改）”文件状态”中的文件，进行新的提交。 

   ![](https://ws2.sinaimg.cn/large/006tNbRwly1fxd8jxzmo1j31c80lyadj.jpg)

提交成功后，则成功重置了从历史节点到最新节点的提交。

# 参考

- [sourceTree"重置提交"和"提交回滚"的区别](https://www.cnblogs.com/jingxin1992/p/8534401.html)

- [使用sourceTree回滚git代码到历史节点](https://blog.csdn.net/u012373815/article/details/78142806)
