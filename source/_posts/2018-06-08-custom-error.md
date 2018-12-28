---
title: 自定义错误信息
categories:
  - 代码片段
  - javascript
tags:
  - dev
  - javascript
  - 代码片段
  - error
abbrlink: 8e8f8856
date: 2018-06-08 14:35:00
updated: 2018-06-08 14:35:00
---

```Javascript
class ZPError extends Error {
  constructor ({ code, message }) {
    // Calling parent constrcutor of base Error class.
    super(message)
    // Capturing stack trace, excluding constructor call from it.
    Error.captureStackTrace && Error.captureStackTrace(this, this.constructor)
    // Saving class name in the property of our custom error as a shortcut.
    this.name = this.constructor.name // 自定义参数
    this.code = code // 自定义参数
  }
}

export default ZPError
```

<!-- more -->

使用 👇

```Javascript
throw new ZPError({ code: 400, message: '参数错误' })
```
