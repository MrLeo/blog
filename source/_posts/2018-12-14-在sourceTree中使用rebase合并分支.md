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

1. 完成功能分支之后先不 merge，而是回到主干分支去 `git pull --rebase`
2. 如果主干有更新，rebase 更新的内容到功能分支来预检一下，看看在加入了最近别人的改动之后我的功能是否依然 OK（在这个过程中可能会有冲突处理，别怪我没提醒哦）
3. 一切就绪之后再次 `git fetch` 主干看看有没有变动（因为在第二步的进行期间没准又有人 push 了新的变化），有的话重复第二步，没有则——
4. 合并功能分支到主干然后 push，收工。

<!--more-->

原始状态

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fy69b0529uj30sy0pg41h.jpg)

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

