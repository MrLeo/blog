---
title: 【转载】利用 Chrome 原生工具进行网页长截图
date: 2018-06-22 16:38:44
updated: 2018-06-22 16:38:44
categories: 
- 工具
tags:
- 工具
- Chrome
---

之前试用 Firefox Quantum 时，我最喜欢的特性之一就是其自带的截图功能。它不仅可以自动检测网页元素边界，还能轻松保存整个网页，十分方便。

后来由于扩展及习惯等原因，我又换回了 Chrome，但还是对该功能念念不忘。尽管商店里也有许多截图增强扩展，但在截取一些比较复杂的网页时，往往会出现元素错位、重复的现象。经过一番探索，我发现 Chrome 开发者工具中其实自带了截图命令，效果也令人满意，在这里分享给大家。

要想使用截图功能，你需要首先确保 Chrome 已升级至 59 或更高版本。在想要截图的网页中，首先按下 `⌘Command + ⌥Option + I`（Windows 为 `F12`）快捷键，召唤出调试界面。

![请输入图片标题](https://cdn.sspai.com/2017/12/07/a266a9c4d39ece8c89d0963356e693e3.png?imageView2/2/w/1120/q/90/interlace/1/ignore-error/1)

 

随后，按下 `⌘Command + ⇧Shift + P`（Windows 为 `Ctrl + Shift + P`），输入命令 `Capture full size screenshot`

（只输前几个字母就能找到），敲下回车，Chrome 就会自动截取整个网页内容并保存至本地。由于是渲染引擎直接输出，其比普通扩展速度更快，分辨率也更高。

 

![请输入图片标题](https://cdn.sspai.com/2017/12/07/358b25902761063ac8f497d3065f5428.png?imageView2/2/w/1120/q/90/interlace/1/ignore-error/1)

 

![请输入图片标题](https://cdn.sspai.com/2017/12/07/5940f13c1456f03802ed2ca1bcf587b6.png?imageView2/2/w/1120/q/90/interlace/1/ignore-error/1)

 

除了普通长截图以外，你还可以利用这一功能截取手机版网页长图。只需要按下 `⌘Command + ⇧Shift + M` （Windows 为 `Ctrl + Shift + M`）模拟移动设备，再按刚才的方法运行命令就可以了。在顶部的工具栏中，你可以选择要模拟的设备和分辨率等设置。

 

![请输入图片标题](https://cdn.sspai.com/2017/12/07/9b8cbf4a106a321ac717285adf9be15c.png?imageView2/2/w/1120/q/90/interlace/1/ignore-error/1)

 

![请输入图片标题](https://cdn.sspai.com/2017/12/07/d9ac82b606655feb2441b6209eea5e63.png?imageView2/2/w/1120/q/90/interlace/1/ignore-error/1)

 

如果你想准确截取网页的某一部分，可以按下 `⌘Command + ⇧Shift + C`（Windows 为 `Ctrl + Shift + C`）嗅探元素。选中想要的部分后，再运行 `Capture node screenshot` 命令，一张完美的选区截图就诞生了。

 

![请输入图片标题](https://cdn.sspai.com/2017/12/07/aab2bb3492d9c3f762c822a6478e74da.png?imageView2/2/w/1120/q/90/interlace/1/ignore-error/1)

 

![请输入图片标题](https://cdn.sspai.com/2017/12/07/17a5f6c7fccf0e96afff2e74b0f00156.png?imageView2/2/w/1120/q/90/interlace/1/ignore-error/1)

 

此外，`Capture screenshot` 命令可以让你截取当前网页的可视部分。我也会继续发掘 Chrome 开发者工具的其它好玩用法，到时推荐给大家。



> 转载自：https://sspai.com/post/42193