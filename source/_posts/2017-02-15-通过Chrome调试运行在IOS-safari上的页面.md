---
title: 通过Chrome调试运行在IOS-safari上的页面
categories:
  - 前端
  - 调试
tags:
  - 前端
  - dev
  - 调试
abbrlink: 587f8f31
date: 2017-02-15 22:25:37
updated: 2017-02-15 22:25:37
---

> 本文重点讨论如何在 Windows 系统中通过 chrome 浏览器调试运行在 iPhone Safari 浏览器中的网页。如果你有一台 iMac/MacBook，可忽略该文档。iMac 环境下，直接通过 USB 将 iphone 与 iMac/MacBook 链接，之后在 iMac/MacBook 中打开 Safari 进入调试模式，即可对运行在手机中的页面进行调试。详情见：[Using Web Inspector to Debug Mobile Safari](https://webdesign.tutsplus.com/articles/quick-tip-using-web-inspector-to-debug-mobile-safari--webdesign-8787) 或 [Safari Web Inspector Guide](https://developer.apple.com/library/content/documentation/AppleApplications/Conceptual/Safari_Developer_Guide/GettingStarted/GettingStarted.html)

<!-- more -->

# 安装 iTunes

Windows 系统首先要安装 iTunes ，打开 Apple 官网下载 iTunes 并完成 iTunes 安装，否则计算机无法正确识别 iPhone 设备。

# 开启调试模式

要远程调试 IOS Safari ，必须启用 Web 检查 功能，打开 iPhone 依次进入 `设置` > `Safari` > `高级` > `Web 检查` > 启用。

# ios-webkit-debug-proxy

ios-webkit-debug-proxy 是一个 DevTools proxy ，项目托管在 Github 上。其使得开发者可以发送命令到真实（或虚拟）IOS 设备中的 Safari 浏览器或 UIWebViews 。

## 安装部署

项目地址：[https://github.com/artygus/ios-webkit-debug-proxy-win32](https://github.com/artygus/ios-webkit-debug-proxy-win32)。

在 Binaries 小节点击下载链接。

下载后完成解压缩，将 [ios-webkit-debug-proxy-win32](https://github.com/artygus/ios-webkit-debug-proxy-win32) 目录复制到 `C:\` 盘。

在系统环境变量添加 `C:\ios-webkit-debug-proxy-win32`。

## 启动 proxy

打开命令行终端，执行：

```bat
ios_webkit_debug_proxy.exe -f chrome-devtools://devtools/bundled/inspector.html
```

输出结果如下：

```bat
ios_webkit_debug_proxy.exe -f chrome-devtools://devtools/bundled/inspector.html
Listing devices on :9221
Connected :9222 to iPhone (c356a29f73043a36aa6de64b088d55aeeda8f034)
```

## 开始调试

打开 chrome 浏览器，在地址栏输入 [https://localhost:9221/](https://localhost:9221/) ，这里会显示所有已连接的设备清单，选择一个设备并点击打开。

打开的页面可看到当前 iphone 中 Safari 浏览器打开的所有页面，点击要调试的页面链接打开即可进入调试界面。此时可能会有一个错误提示如下:

```bat
Note: Your browser may block1,2 the above links with JavaScript console error:
  Not allowed to load local resource: chrome-devtools://...
To open a link: right-click on the link (control-click on Mac), 'Copy Link Address', and paste it into address bar.
```

提示浏览器禁止页面加载本地资源，需在上面的链接上点击右键复制链接，然后手动新建一个标签页将链接粘贴进去，回车访问。

根据提示说明复制链接并打开，即可看到常见的 chrome 调试窗口。

接下来，就可以进行正常的调试工作了。

---

[ios-webkit-debug-proxy](https://github.com/google/ios-webkit-debug-proxy 'target=_blank')
[ios-webkit-debug-proxy-win32](https://github.com/artygus/ios-webkit-debug-proxy-win32 'target=_blank')
