---
title: html-template
tags:
  - html
  - dev
  - 前端
categories:
  - 前端
  - html
abbrlink: adaf6fe5
date: 2017-01-07 17:49:36
---

```html
<!DOCTYPE html>
<html lang="zh-CN">

    <head>
        <meta charset="UTF-8"/>
        <!-- 优先使用 IE 最新版本和 Chrome -->
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
        <!-- 页面描述 -->
        <meta name="description" content="不超过150个字符"/>
        <!-- 页面关键词 -->
        <meta name="keywords" content=""/>
        <!-- 网页作者 -->
        <meta name="author" content="name, email@gmail.com"/>
        <!-- 搜索引擎抓取 -->
        <meta name="robots" content="index,follow"/>
        <!-- 为移动设备添加 viewport -->
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=3, minimum-scale=1, user-scalable=no">
        <!-- `width=device-width` 会导致 iPhone 5 添加到主屏后以 WebApp 全屏模式打开页面时出现黑边 https://bigc.at/ios-webapp-viewport-meta.orz -->

        <!-- iOS 设备 begin -->
        <meta name="apple-mobile-web-app-title" content="标题">
        <!-- 添加到主屏后的标题（iOS 6 新增） -->
        <meta name="apple-mobile-web-app-capable" content="yes"/>
        <!-- 是否启用 WebApp 全屏模式，删除苹果默认的工具栏和菜单栏 -->

        <meta name="apple-itunes-app" content="app-id=myAppStoreID, affiliate-data=myAffiliateData, app-argument=myURL">
        <!-- 添加智能 App 广告条 Smart App Banner（iOS 6+ Safari） -->
        <meta name="apple-mobile-web-app-status-bar-style" content="black"/>
        <!-- 设置苹果工具栏颜色 -->
        <meta name="format-detection" content="telphone=no, email=no"/>
        <!-- 忽略页面中的数字识别为电话，忽略email识别 -->
        <!-- 启用360浏览器的极速模式(webkit) -->
        <meta name="renderer" content="webkit">
        <!-- 避免IE使用兼容模式 -->
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <!-- 不让百度转码 -->
        <meta http-equiv="Cache-Control" content="no-siteapp" />
        <!-- 针对手持设备优化，主要是针对一些老的不识别viewport的浏览器，比如黑莓 -->
        <meta name="HandheldFriendly" content="true">
        <!-- 微软的老式浏览器 -->
        <meta name="MobileOptimized" content="320">
        <!-- uc强制竖屏 -->
        <meta name="screen-orientation" content="portrait">
        <!-- QQ强制竖屏 -->
        <meta name="x5-orientation" content="portrait">
        <!-- UC强制全屏 -->
        <meta name="full-screen" content="yes">
        <!-- QQ强制全屏 -->
        <meta name="x5-fullscreen" content="true">
        <!-- UC应用模式 -->
        <meta name="browsermode" content="application">
        <!-- QQ应用模式 -->
        <meta name="x5-page-mode" content="app">
        <!-- windows phone 点击无高光 -->
        <meta name="msapplication-tap-highlight" content="no">
        <!--自定义favicon-->
        <link rel="icon" type="image/jpg" href="/static/img/icon.jpg" size="16*16">
        <link rel="shortcut icon" href="/favicon.ico">
        <title>首页</title>
    </head>

    <body>
        <h1>自定义苹果图标</h1>
        <p>在网站文件根目录放一个 apple-touch-icon.png 文件，苹果设备保存网站为书签或桌面快捷方式时，就会使用这个文件作为图标，文件尺寸建议为：180px × 180px。</p>
    </body>

</html>
```