---
title: Safari和Chrome浏览器真机调试iphone中h5页面
categories:
  - 工具
tags:
  - dev
  - 调试
  - 工具
abbrlink: 6c7d587e
date: 2019-10-26 23:46:05
updated: 2019-10-26 23:46:05
---

# 背景

现在的前端研发大都采用Mac设备，而移动端app大多沿用混合开发的方式，从而产生了很多原生页面和H5之间的交互问题。经过上次Mac调试安卓app中的H5的经历之后，今天尝试了在mac中调试ios系统的原生浏览器中的页面

<!--more-->

# 环境准备

- mac一台
- iPhone手机一部

# 步骤

## iPhone设置

打开设置-->Safari浏览器-->高级-->开启JavaScript和web检查器

![](https://tva1.sinaimg.cn/large/006y8mN6ly1g8c1djasx4j30zq0leq9g.jpg)

iPhone端的操作全部操作完成

## Chrome 浏览器

没有安装HomeBrew的小伙伴，先安装HomeBrew，不了解HomeBrew的同学可以在 [这里](https://www.caniuse.com/) 查看

- 安装完成后,依次执行下面代码

  ```shell
  brew unlink libimobiledevice ios-webkit-debug-proxy usbmuxd
  brew uninstall --force libimobiledevice ios-webkit-debug-proxy usbmuxd
  brew install --HEAD usbmuxd
  brew install --HEAD libimobiledevice
  brew install --HEAD ios-webkit-debug-proxy
  ```

- 安装最新版本的adapter

  ```shell
  npm install remotedebug-ios-webkit-adapter -g
  ```

  到这一步，mac端的操作就已经完成了，

- 然后再看iphone的设置

  mac上打开终端，执行命令，开启adapter，设置监听端口为9000

	```shell
	remotedebug_ios_webkit_adapter --port=9000
	```

	Chrome中打开`chrome://inspect/#devices`，在configure中添加localhost:9000,可以看到设备出现在列表中。iphone的Safari中的页面，就可以在这里看到，点击inspect，就可以和PC端一样，进行调试啦

	![](https://tva1.sinaimg.cn/large/006y8mN6ly1g8c1i4pnu6j30qs09k3zd.jpg)

## Safari浏览器

Safari浏览器中相对就比较简单啦，iphone端的操作完全一样，打开Safari浏览器，选中系统偏好设置-->高级,勾选在菜单中打开“开发”菜单

![](https://tva1.sinaimg.cn/large/006y8mN6ly1g8c1j1in1qj314o0pe78k.jpg)

连接手机，打开Safari浏览器，选择开发，选中设备，可看到移动端Safari浏览器中打开的网址，点击，就能打开Safari浏览器的开发者工具了。如图所示：![](https://tva1.sinaimg.cn/large/006y8mN6ly1g8c1jmg4g8j30rm0dj786.jpg)

