---
title: jQuery学习
categories:
  - 代码片段
  - javascript
tags:
  - dev
  - javascript
  - 代码片段
  - jquery
abbrlink: 7a95906a
date: 2018-06-06 15:05:41
updated: 2018-06-06 15:05:41
---

<!-- more -->

# 链式调用

```js
var _ = function (selector) {
  return new _.fn.init(selector)
}
_.fn = _.prototype = {
  constructor: _, // 强化构造器
  init: function (selector, context) {
    // console.log(this.constructor)
    context = context || document
    var dom = context.querySelectorAll(selector) // 将获取的元素作为当前对象的属性值保存
    var len = dom.length
    for (; i < len; i++) {
      this[i] = dom[i]
    }
    this.length = len // 校正 length 属性
    return this // 返回当前对象
  },
  size: function () {
    return this.length
  },
  // 增强数组，使 _('ID') 返回的结果看起来更像一个数组
  push: [].push,
  sort: [].sort,
  splice: [].splice
}
_.fn.init.prototype = _.fn // 强化构造器，使原型链 __proto__ 指向 _ 对象



// 对象拓展
_.extend = _.fn.extend = function () {
  var i = 1 // 拓展对象从第二个参数算起
  var len = arguments.length // 获取参数长度
  var target = arguments[0] // 第一个参数为源对象
  var j // 拓展对象中的属性
  // 如果只有一个参数
  if (i == len) {
    target = this // 源对象为当前对象
    i-- // i 从 0 计算
  }
  // 遍历参数中的拓展对象
  for (; i < len; i++) {
    for (j in arguments[i]) {
      target[j] = arguments[i][j]// 拓展对象中的属性
    }
  }
  return target // 返回源对象
}



// 测试用例
console.log(_('ID'))
console.log(_('ID').size());

_.extend(_.fn, { version: '1.0' })
console.log(_('ID').version)
_.fn.extend({ getVersion: function () { return this.version } })
console.log(_('ID').getVersion())
```

