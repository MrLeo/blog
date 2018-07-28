---
title: node-mongodb
date: 2018-01-30 13:57:06
updated: 2018-01-30 13:57:06
categories: 
- 代码片段
- javascript
tags: 
- dev
- javascript
- 代码片段
- mongodb
---

配置信息：

```js
/**
 * 配置信息
 */
const config = {
  DB: {
    db: 'demo', //数据库名称
    host: 'localhost', //主机号
    port: 27017, //端口号
  },
}
```

<!--more-->

数据访问对象：

```js
const mongodb = require('mongodb') //引入MongoDB模块

/**
 * 创建数据库对象
 */
const d = new mongodb.Db(
  config.db,
  new mongodb.Server(
    config.host,
    config.port,
    { auto_reconnect: true }, //自动连接
  ),
  { safe: true },
)

/**
 * 打开数据库，操作集合
 * @param {*} col 集合名
 * @param {*} fn 操作方法
 */
function connect(col, fn) {
  d.open(function(err, db) {
    if (err) throw err
    else
      db.collection(col, function(err, col) {
        if (err) throw err
        else fn && fn(col, db)
      })
  })
}

exports.DB = function(col) {
  return {
    /**
     * 插入数据
     * @param {*} data 插入数据库
     * @param {*} success 操作成功回调
     * @param {*} fail 操作失败回调
     */
    insert: (data, success, fail) => {
      connect(
        col,
        function(col, db) {
          col.insert(data, function(err, docs) {
            if (err) fail && fail(err)
            else success && success(docs)
            db.close()
          })
        },
      )
    },
    /**
     * 删除数据
     * @param {*} data 插入数据库
     * @param {*} success 操作成功回调
     * @param {*} fail 操作失败回调
     */
    remove: (data, success, fail) => {
      connect(
        col,
        function(col, db) {
          col.remove(data, function(err, len) {
            if (err) fail && fail(err)
            else success && success(len)
            db.close()
          })
        },
      )
    },
    /**
     * 更新数据
     * @param {*} con 筛选条件
     * @param {*} doc 更新数据项
     * @param {*} success 成功回调
     * @param {*} fail 失败回调
     */
    update: (con, doc, success, fail) => {
      connect(
        col,
        function(col, db) {
          col.update(con, doc, function(err, len) {
            if (err) fail && fail(err)
            else success && success(len)
            db.close()
          })
        },
      )
    },
    /**
     * 更新数据
     * @param {*} con 筛选条件
     * @param {*} success 成功回调
     * @param {*} fail 失败回调
     */
    find: (con, success, fail) => {
      connect(
        col,
        function(col, db) {
          col.find(con).toArray(function(err, docs) {
            if (err) fail && fail(err)
            else success && success(docs)
            db.close()
          })
        },
      )
    },
  }
}
```

测试用例：

```js
const user = DB('user')
user.insert({ name: '小白', nick: '雨夜清荷' }, function(docs) {
  console.log(docs) // [{ name: '小白', nick: '雨夜清荷', _id: 1 }]
})
user.find({ name: '小白' }, function(doc) {
  console.log(doc) // [{ name: '小白', nick: '雨夜清荷', _id: 1 }]
})
user.update({ name: '小白' }, { name: '小黑', nick: '雨夜' }, function(len) {
  console.log(len) // 1
})
user.remove({ name: '小白' }, function(len) {
  console.log(len) // 1
})
```

