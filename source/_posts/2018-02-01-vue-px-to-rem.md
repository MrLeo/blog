---
title: 【转载】Vue项目自动转换 px 为 rem，高保真还原设计图
categories:
  - 前端
  - vue
tags:
  - 前端
  - 开发
  - dev
  - vue
  - css
  - rem
  - 转载
abbrlink: 5abe2a3f
date: 2018-02-01 11:47:08
updated: 2018-02-01 11:47:08
---

前端开发中还原设计图的重要性毋庸置疑，目前来说应用最多的应该也还是使用**rem**。然而很多人依然还是处于刀耕火种的时代，要么自己去计算`rem`值，要么依靠编辑器安装插件转换。

而本文的目标就是通过一系列的配置后，在开发中可以直接使用设计图的尺寸开发，项目为我们自动编译，转换成`rem`。

<!-- more -->

## 技术栈

- vue-cli：使用脚手架工具创建项目。
- postcss-pxtorem：转换 px 为 rem 的插件。

## 自动设置根节点`html`的`font-size`

因为`rem`单位是相对于根节点的字体大小的，所以通过设置根节点的字体大小可以动态的改变 rem 的大小。

原理网上有很多文章分享，这里不具体解释。

### 1、创建`rem.js`文件

很多人写这种小工具文件会习惯性的加上闭包，这个其实是没有必要的。ES6 中每个文件都是单独的一个模块。

```js
// 基准大小
const baseSize = 32
// 设置 rem 函数
function setRem() {
  // 当前页面宽度相对于 750 宽的缩放比例，可根据自己需要修改。
  const scale = document.documentElement.clientWidth / 750
  // 设置页面根节点字体大小
  document.documentElement.style.fontSize = baseSize * Math.min(scale, 2) + 'px'
}
// 初始化
setRem()
// 改变窗口大小时重新设置 rem
window.onresize = function() {
  setRem()
}
```

### 2、在`main.js`中引入`rem.js`

```Js
import './utils/rem'
```

引入文件后，查看页面的 html 节点，是否有被自动添加 `font-size`。

**注意：完成到这一步，也就是实现了 rem 布局，实际开发的时候，还是需要我们去计算对应的 rem 值去开发。**

**下一步我们就配置一下 webpack，自动转换 px 为对应的 rem 值。**

## 配置 `postcss-pxtorem` 自动转换 px 为 rem

**1、安装 postcss-pxtorem**

```bash
$ npm install postcss-pxtorem -D
```

**2、修改 /build/utils.js 文件**

找到 `postcssLoader` 的代码块

```Js
const postcssLoader = {
	loader: 'postcss-loader',
	options: {
  		sourceMap: options.sourceMap
	}
}
```

修改为：

```Js
const postcssLoader = {
    loader: 'postcss-loader',
    options: {
      sourceMap: options.sourceMap,
      plugins: [
        require('postcss-pxtorem')({
          'rootValue': 32,
          propList: ['*']
        })
      ]
	}
}
```

按照上述配置项目后，即可在开发中直接使用 `px` 单位开发。

例如设计给出的设计图是 **750 \* 1136**，那么可以直接在页面中写

```Css
body {
	width: 750px;
	height: 1136px;
}
```

将被转换为

```css
body {
  widht: 23.4375rem;
  height: 35.5rem;
}
```

---End---

[转至] https://juejin.im/post/5a716c4c6fb9a01cb42cac4b(https://juejin.im/post/5a716c4c6fb9a01cb42cac4b)
