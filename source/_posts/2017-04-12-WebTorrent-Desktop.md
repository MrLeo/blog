---
title: WebTorrent Desktop – 支持 BT 种子、磁力链接，可以「边播边下」
categories:
  - 工具
tags:
  - 工具
  - 视频播放
  - 下载
abbrlink: 90e279c8
date: 2017-04-12 10:31:19
updated: 2017-04-12 10:31:19
---

> 一款可以直接在线播放视频的 BT 下载客户端，支持种子文件与磁力链接，拥有 Win/macOS/Linux 客户端程序
>
> 官方网站：[https://webtorrent.io/](https://webtorrent.io/)
>
> 小众软件的介绍：[https://www.appinn.com/webtorrent-desktop/](https://www.appinn.com/webtorrent-desktop/)

<!-- more -->

![图片来自官方网站](https://webtorrent.io/img/screenshot-player2.png)

对于视频、电影/电视剧，**下载后再播放** 和 **直接播放** 是完全两个不同的境界，这也是之前很多软件*提供过*的服务。然而由于视频内容的问题，类似服务逐步取消、退化。

本来，有版权的在线视频服务是一个非常好的替代，可惜内容源被管制，需求又是刚性的，于是古老的下载方式又渐渐流行起来。

![图片来自小众软件](https://img3.appinn.com/images/201704/2017-04-12-12-54-23.jpg)

WebTorrent 的实现方式很酷，在 [WebTorrent 首页](https://webtorrent.io/) 就放着一个可以在线播放的视频文件

上面显示了一个播放器、文件大小、种子数，以及正在连接的其它几个 IP。

WebTorrent 是用于 Node.js 和浏览器的流 torrent 客户端，完全使用 JavaScript 编写。WebTorrent 是个轻量级，快速的开源 BT 客户端，拥有非常棒的用户体验。

在 node.js 中，模块只是简单的 torrent 客户端，使用 TCP 和 UDP 来和其他 torrent 客户端进行通讯。

在浏览器中，WebTorrent 使用 WebRTC (数据通道)进行点对点的传输，无需任何浏览器插件，扩展或者安装。注意：在浏览器上，WebTorrent 不 支持 UDP/TCP 点对点传输。

由于是基于 node.js、WebRTC 的开源技术，任何人都可以通过 [Github](https://github.com/feross/webtorrent) 获取源码并搭建一个视频网站，爱折腾的同学可以尝试下。

普通用户下载并运行 WebTorrent Desktop 就可以了，将种子文件拖进界面，或者粘贴磁力链接，稍微缓冲 WebTorrent Desktop 就开始播放了。

![WebTorrent Desktop 客户端截图](https://webtorrent.io/img/screenshot-main.png)

> **技巧：**
>
> 如果碰到无法播放的情况，将种子扔进 [instant.io](https://instant.io/)，一会就可以播放了。
>
> ![图片来自小众软件](https://img3.appinn.com/images/201704/2017-04-12-1-09-17.jpg!o)
>
> 这个 Instant.io 是基于 WebTorrent 的文件传输工具，都开源，能自己折腾.
