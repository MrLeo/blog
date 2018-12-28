---
title: HEXO-NexT的Local Search转圈圈问题
categories:
  - 建站
tags:
  - 建站
  - blog
  - 博客
  - hexo
  - markdown
  - 搜索
abbrlink: abcc0996
date: 2018-07-14 13:05:02
updated: 2018-07-14 13:05:02
---

有时候更新完文章，会莫名导致 NexT 的 LocalSearsh 有问题，
像是点击搜索卡住转圈圈状态也没办法解掉，这篇纪录如何解决。

<!-- more -->

# Step1. 检查搜寻机制

由于使用的是 localSearch，
会透过编译完后 public 里面的`search.xml`作为搜寻主体，
有了搜寻主体后就要先去验证格式的正确性，但我跟 XML 格式并不熟，
内容量太大也没办法肉眼去验证，就找了线上验证的网站，
把`search.xml`的内容全部丢下去验证后跳出了这个错误。

> 线上找会有很多，我是用 google 找到的第一个[https://www.xmlvalidation.com/](https://www.xmlvalidation.com/)

![](https://ws1.sinaimg.cn/large/006tNbRwly1fx7mixvqzlj30nw014web.jpg)

# Step2. Unicode: 0x8

得到了这样子的错误讯息后，就马上拿去问 google 啦~  
也发现从标题中有满多人是在跟 md 档案有关系的互动时产生的问题，
点了其中一篇 GitHub 中关于[EverNote](https://github.com/oulvhai/MWeb-issues/issues/514)的发问，
里面有人回应这个错误是因为产生了一个 backspace 的字符，顺着查下去！

# Step3. 显示看不到的 backspace 字符

我是使用 VSCODE，开启方式是到设定中打开打开之后就可以看到凶手了！`renderControlCharacters` ![img](https://ws1.sinaimg.cn/large/006tNbRwly1fx7mkcn7ylj30p80bomxc.jpg) 

![img](https://ws1.sinaimg.cn/large/006tNbRwly1fx7mkg749gj30oo080jrd.jpg)

# Step4. 搜寻并替换

经过查询，backspace 的 unicode 是`\u0008`，
而 VSCODE 的档案搜寻正则表达式使用的是 Rust 要输入`\x{0008}`，
但是我查了很久总是搜不出我要的档案，我也不知道哪里出错，
就这样查了很久很久才发现，直接把那个超小的`bs`框起来复制丢上搜寻框就好！！！
虽然搜寻框内的 bs 肉眼看不j到，但是实际上他会去进行搜寻，
接着就一个一个替换吧（一个一个替换是因为我只替换我自己产出的档案，避免影响其他东西）。

也可以在[`正则`](http://www.cnblogs.com/deerchao/archive/2006/08/24/zhengzhe30fengzhongjiaocheng.html#grouping)模式搜索下：[^1]

```js
/[\u0000]|[\u0001]|[\u0002]|[\u0003]|[\u0004]|[\u0005]|[\u0006]|[\u0007]|[\u0008]|[\u000b]|[\u000c]|[\u000d]|[\u000e]|[\u000f]|[\u0010]|[\u0011]|[\u0012]|[\u0013]|[\u0014]|[\u0015]|[\u0016]|[\u0017]|[\u0018]|[\u0019]|[\u001a]|[\u001b]|[\u001c]|[\u001d]|[\u001e]|[\u001f]|[\u001c]|[\u007f]/gm
```

# Step5. 重编译一次测试看看吧

当完成修改后，重新测试理论上搜寻框就修好了～～
找原因的途中也是学了不少啊：D

[^1]: [vscode控制字符引起的问题以及解决思路](https://segmentfault.com/a/1190000013357949#articleHeader7)