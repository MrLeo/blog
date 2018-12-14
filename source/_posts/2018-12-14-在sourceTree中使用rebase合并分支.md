---
title: 在sourceTree中使用rebase合并分支
date: 2018-12-14 14:05:00
updated: 2018-12-14 14:05:00
categories:
- 工具
tags:
- git
- sourcetree
---

{% note  %} 在sourceTree中使用rebase合并分支 {% endnote  %}

原始状态

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fy69b0529uj30sy0pg41h.jpg)

<!--more-->

假如我们要在 master 分支上进行开发，在远端的 master 分支上右键，检出 一个自己的开发分支 dev-1

![img](https://ws4.sinaimg.cn/large/006tNbRwgy1fy69bjs148j30t20v2ae7.jpg)

![img](https://ws4.sinaimg.cn/large/006tNbRwgy1fy69c5ndkcj30u40r2diy.jpg)

做一些开发，提交到本地，不要推送（push）到远端
切换到 master 分支，拉取远端的 master 更新，（这里另一个同事在 master 分支上提交了 dev 2 的更新）

![img](https://ws2.sinaimg.cn/large/006tNbRwgy1fy69cyad02j30zk0ec0xz.jpg)

切换到自己的开发分支 dev-1
选中 master 分支，右键，选择 将当前变更变基到 master

![img](https://ws4.sinaimg.cn/large/006tNbRwgy1fy69daffwqj30ta0mm0wn.jpg)

如果有冲突则合并冲突，
点击左上角的加号，选择 继续变基

![img](https://ws2.sinaimg.cn/large/006tNbRwgy1fy69dg5ei0j30zk0g4434.jpg)

此时我们的本地更新是基于最新的 master 分支

![img](https://ws1.sinaimg.cn/large/006tNbRwgy1fy69dkjpc8j30uo0h20vf.jpg)

最后’推送’我们的开发分支 dev-1到远端
切换到master分支，点击 拉取，拉取 dev-1 的更新到 master 分支

![img](https://ws1.sinaimg.cn/large/006tNbRwgy1fy69doxd6zj30ym0h00vp.jpg)

再推送 master 分支，就保证了git分支的整洁

![img](https://ws4.sinaimg.cn/large/006tNbRwgy1fy69dtpcenj30zk0fstbx.jpg)

