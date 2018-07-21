---
title: 使用px2rem-loader实现vue项目自动转换px为rem
date: 2018-04-07 11:05:42
updated: 2018-04-07 11:05:42
categories: [前端, vue]
tags: [前端, 开发, dev, vue, css, rem, 转载]
---

> 之前转载过一篇[《【转载】Vue 项目自动转换 px 为 rem，高保真还原设计图》](https://xuebin.me/2018/02/01/vue-px-to-rem/)使用的是 postcss 的插件`postcss-pxtorem`，这次介绍另外一个插件[`px2rem-loader`][px2rem-loader]

<!-- more -->

# 安装 px2rem-loader

```bash
npm install px2rem-loader --save-dev
```

# 配置 px2rem-loader

在`vue-cli`生成的文件中,找到以下文件 `build/utils.js`

```js
const postcssLoader = {
  loader: 'postcss-loader',
  options: {
    sourceMap: options.sourceMap,
    // NOTE: 配置 px2rem-loader
    // 在css-loader前应用的loader数目，默认为0.
    // 如果不加这个，@import的外部css文件不能正常转换。
    // 如果还不行可以试着调大数字。更改后必须重启项目，否则不生效！！！
    importLoaders: 10,
  },
}
```

> importLoaders 也可以直接加载 loader 后面 `loader: 'css-loader?importLoaders=1'`

```js
// NOTE: 配置 px2rem-loader
const px2remLoader = {
  loader: 'px2rem-loader',
  options: {
    remUnit: 32,
  },
}
```

> 更多 px2rem 的用法可以参考：[px2rem][px2rem]
>
> 直接写 px，编译后会直接转化成 rem ---- 除开下面两种情况，其他长度用这个
> 在 px 后面添加`/*no*/`，不会转化 px，会原样输出。 --- 一般 border 需用这个
> 在 px 后面添加`/*px*/`,会根据 dpr 的不同，生成三套代码。---- 一般字体需用这个

# 创建`rem.js`文件

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

> rem.js 文件中的`baseSize`和 px2remLoader 中的`remUnit`是对应的。
>
> 如果不想使用 rem.js 这种简单粗暴的粗略计算，更进一步的可以使用[`lib-flexible`][lib-flexible]、[`hotcss`][hotcss]这两个过渡方案。
>
> 如果你的项目不是必须兼容低版本的可以考虑使用`vw`来做适配：[《如何在 Vue 项目中使用 vw 实现移动端适配》][vw]。

[px2rem-loader]: https://github.com/Jinjiang/px2rem-loader 'Webpack loader for px2rem css file'
[px2rem]: https://github.com/songsiqi/px2rem 'According to one stylesheet, generate rem version and @1x, @2x and @3x stylesheet.'
[lib-flexible]: https://github.com/amfe/lib-flexible '可伸缩布局方案'
[hotcss]: https://github.com/imochen/hotcss '移动端布局解决方案'
[vw]: https://www.w3cplus.com/mobile/vw-layout-in-vue.html '如何在Vue项目中使用vw实现移动端适配'
[vue-cli 配置flexible]: https://segmentfault.com/a/1190000011883121
