---
title: PWA - workbox
categories:
  - 前端
  - webpack
tags:
  - 前端
  - dev
  - webpack
  - pwa
  - workbox
abbrlink: d4fe0182
date: 2018-06-08 14:44:17
updated: 2018-06-08 14:44:17
---

# [workbox](https://developers.google.com/web/tools/workbox)

既然如此，我们最好是站在巨人的肩膀上，这个巨人就是谷歌。workbox 是由谷歌浏览器团队发布，用来协助创建 PWA 应用的 `JavaScript` 库。当然直接用 `workbox` 还是太复杂了，谷歌还很贴心的发布了一个 `webpack` 插件，能够自动生成 `Service Worker` 和 静态资源列表 - [workbox-webpack-plugin](https://developers.google.com/web/tools/workbox/modules/workbox-webpack-plugin)。

<!-- more -->

只需简单一步就能生成生产环境可用的 `Service Worker` ：

```
const { GenerateSW } = require('workbox-webpack-plugin')

new GenerateSW()
```

打包一下：

![](https://segmentfault.com/img/bVbbjuu?w=3028&h=1318)

还能说什么呢？谷歌大法好！当然这只是最简单的可用版本，其实这里有一个最严重的问题不知道有没人发现，那就是  `importScripts`  引用的是谷歌域名下的 cdn ，这让我们墙内的网站怎么用，所以我们需要把这个问题解决并自定义一些配置增强  `Service Worker`  的能力：

```javascript
new GenerateSW({
  importWorkboxFrom: 'local',
  skipWaiting: true,
  clientsClaim: true,
  runtimeCaching: [
    {
      // To match cross-origin requests, use a RegExp that matches
      // the start of the origin:
      urlPattern: new RegExp('^https://api'),
      handler: 'staleWhileRevalidate',
      options: {
        // Configure which responses are considered cacheable.
        cacheableResponse: {
          statuses: [200],
        },
      },
    },
    {
      urlPattern: new RegExp('^https://cdn'),
      // Apply a network-first strategy.
      handler: 'networkFirst',
      options: {
        // Fall back to the cache after 2 seconds.
        networkTimeoutSeconds: 2,
        cacheableResponse: {
          statuses: [200],
        },
      },
    },
  ],
})
```

首先 `importWorkboxFrom` 我们指定从本地引入，这样插件就会将 `workbox` 所有源文件下载到本地，墙内开发者的福音。上面提到过新 `Service Worker` 安装成功后需要进入等待阶段，`skipWaiting: true` 将使其跳过等待，安装成功后立即接管网站，注意这个要和 `clientsClaim` 一起设置为 `true`。`runtimeCaching` 顾名思义是配置运行时如何缓存请求的，这里只说一点，缓存跨域请求时 `urlPattern` 的值必须为 `^` 开头的正则表达式，其它的配置看文档都能得到详细的介绍。

再打包一次：

![](https://segmentfault.com/img/bVbbjwz?w=2014&h=1386)

_出自：<https://segmentfault.com/a/1190000015050724>_

> [pwd 学习 demo 下载](https://image.xuebin.me/offline-client.zip)
