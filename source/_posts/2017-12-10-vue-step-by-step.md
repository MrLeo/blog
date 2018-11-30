---
title: 一步步基于vue-cli搭建vue2.0项目
date: 2017-12-10 12:33:16
updated: 2017-12-10 12:33:16
categories: [前端, vue]
tags: [前端, dev, vue, vue-cli]
top: 100
---

# 准备

- [node](https://nodejs.org/en/) & npm

  ```Bash
  $ brew install node
  ```

- 检查 node & npm

  ```Bash
  $ node -v
  $ npm -v
  ```

- Vue-cli

  ```Bash
  $ npm install -g vue-cli
  ```

<!-- more -->

# 初始化

```Bash
$ vue init <template-name> <project-name>
```

举例

```Bash
vue init webpack vue-step-by-step
```

根据提示依次输入相关信息 ↓
![](https://image.xuebin.me/FkJL3BJVzwCx4ZsJfq07RUh8OpJf)
最后出现`finished`安装完成 ↓
![](https://image.xuebin.me/FuojPwH5ToccPFjaFl6vbzi3MuQc)
在终端中运行 ↓

```
cd vue-step-by-step
npm run dev
```

即可查看初始化完成的效果

# 添加依赖

项目初始化完成后添加项目常用依赖包

```
npm install --save vuex axios qs
npm install --save-dev node-sass sass-loader pug pug-loader
```

包含[`vuex`](https://vuex.vuejs.org/zh-cn/)、[`axios`](https://github.com/axios/axios)、[`qs`](https://github.com/ljharb/qs)、`sass`、`pug`等，其他依赖包根据项目需求自己选择
[`vue-router`](https://router.vuejs.org/zh-cn/)在脚手架 init 的时候会提示是否选择安装

# 完善项目结构

## 添加`views`文件夹

> src 下添加 views 文件夹主要存放页面级的 vue 组件
> src 下的 components 文件夹主要用于存放通用的组件

在 views 文件夹中创建`Home.vue`作为主页

删除`App.vue`中无用的内容，只保留`router-view`

```HTML
<template>
  <div id="app">
    <router-view/>
  </div>
</template>
```

如果是移动端项目用 rem 作为单位，可以在`src/main.js`中添加如下代码做自适应 ↓

```js
if (window.addEventListener) {
  const html = document.documentElement
  function setFont() {
    const k = 750
    html.style.fontSize = (html.clientWidth / k) * 100 + 'px'
  }
  setFont()
  setTimeout(function() {
    setFont()
  }, 300)
  document.addEventListener('DOMContentLoaded', setFont, false)
  window.addEventListener('resize', setFont, false)
  window.addEventListener('load', setFont, false)
}
```

## 调整[`router`](https://router.vuejs.org/zh-cn/)配置

> 更多路由相关使用方法请访问：[https://router.vuejs.org/zh-cn/](https://router.vuejs.org/zh-cn/)

目录结构 ↓

```
router
    ├── index.js          # 我们组装模块并导出 store 的地方
    └── modules
        ├── home.js       # 首页模块
        ├── cart.js       # 购物车模块
        └── products.js   # 产品模块
```

修改路由主文件`router/index.js`

使用`require.context`实现路由[`去中心化`](https://github.com/wuchangming/blog/blob/master/docs/webpack/require-context-usage.md)

```js
import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

let router = new Router({
  base: '/', // 应用的基路径
  mode: 'hash', // "hash" (URL hash 模式) | "history"(HTML5 History 模式) | "abstract" (Node.js 环境)
  scrollBehavior(to, from, savedPosition) {
    // 路由切换的滚动行为，只在 HTML5 history 模式下可用
    if (savedPosition) {
      return savedPosition
    } else {
      return { x: 0, y: 0 }
    }
  },
  routes: (r => {
    // 去中心化
    // console.log('r', r); // __webpack_require__
    let sourceMap = []
    let res = r.keys().map(key => {
      let rKey = r(key)
      sourceMap.push(...rKey.default)
      // console.log('key', key, rKey); // ./modules/home/route.js  // {default: Array(3), __esModule: true}
      return rKey
    })
    return sourceMap
  })(require.context('./', true, /^\.\/modules\/\w+\.js$/)),
})

router.beforeEach((to, from, next) => {
  // console.log('router beforeEach=>', to, from)
  // 全局路由切换前执行
  // 是否有用户信息，并且用户ID是否存在
  // if (window.localStorage.getItem("loginInfo") && JSON.stringify(window.localStorage.getItem("loginInfo")).userId) {
  //     next({path: '/login'})//重定向到登录页面
  // } else {
  //     next()//正常跳转
  // }
  next()
})

router.afterEach((to, from) => {
  // console.log('router afterEach=>', router)
})

export default router
```

在 router 文件夹下添加 `modules` 文件夹

在 modules 文件夹下添加 `home.js` ，这个 home.js 对应首页业务模块，首页相关的路由页面都可以写到 home.js 文件里。

如果以后添加其他业务模块，只需要在 modules 文件夹添加相对应的业务模块文件，并在其中添加业务相关的路由页面。这样所有不同业务线的开发人员就可以互不干扰 ↓

```js
import Home from '../../views/Home'
const routes = [
  {
    path: '/',
    name: 'index',
    redirect: '/home',
  },
  {
    path: '/home',
    name: 'home',
    component: Home,
  },
]
export default routes
```

对于不需要即时加载的非一级页面可以使用异步路由组件

```js
// region 异步组件 - 路由地址demo
// ES 提案的 import（推荐）
{ name: 'index', path: '/', component: () => import('../views/index')},
// ES 提案的 import，带分组，指定webpackChunkName，相同的name打包到一个js文件
{ name: 'index', path: '/', component: () => import(webpackChunkName:'viewsIndex','../views/index')},
// Webpack 风格的异步组件
{ name: 'index', path: '/', component: resolve => require.ensure(['views/Foo.vue'], () => resolve(require('views/Foo.vue')))},
// Webpack 风格的异步组件，带分组
{ name: 'index', path: '/', component: resolve => require.ensure([], () => resolve(require('views/index.vue')), 'group-index')},
// AMD 风格的异步组件
{ name: 'index', path: '/', component: resolve => require(['views/index.vue'], resolve)},
// endregion
```

## 添加`store`文件夹

> src 下的 store 文件夹主要是存放 [vuex](https://vuex.vuejs.org/zh-cn/) 相关信息的
> 更多 vuex 相关使用方法请访问：[https://vuex.vuejs.org/zh-cn/](https://vuex.vuejs.org/zh-cn/)

在 store 文件夹下创建目录结构 ↓

```
store
    ├── index.js               # 我们组装模块并导出 store 的地方
    ├── getters.js             # 根级别的 getter
    ├── actions.js             # 根级别的 action
    ├── mutations.js           # 根级别的 mutation
    ├── mutation-types.js      # 定义链接 action 和 mutation 的方法名常量
    └── modules
        ├── base.js            # 首页模块
        ├── cart.js            # 购物车模块
        └── products.js        # 产品模块
```

下面开始改造 store 文件夹 ↓

1.  在`mutation-types.js`中添加一个常量

    ```js
    export const BASE = {
      SET_USER_INFO: 'SET_USER_INFO',
    }
    ```

1.  在`action-types.js`中添加一个常量

    ```js
    export const BASE = {
      login: 'login',
    }
    ```

1.  修改`modules/base.js`

    ```js
    import Vue from 'vue'
    import { base } from '../mutation-types'
    import axios from 'axios'
    import qs from 'qs'

    const state = {
      version: '',
      token: null,
      user: {
        userID: '',
        userName: '',
        name: '',
        tel: '',
        email: '',
        head: '',
      },
    }

    const getters = {
      versionGetter(state, getters) {
        return state.version
      },
    }

    const mutations = {
      [BASE.SET_USER_INFO](state, userInfo) {
        userInfo.userID && (state.user.userID = userInfo.userID)
        userInfo.USERNAME && (state.user.userName = userInfo.USERNAME)
        userInfo.NAME && (state.user.name = userInfo.NAME)
        userInfo.TEL && (state.user.tel = userInfo.TEL)
        userInfo.EMAIL && (state.user.email = userInfo.EMAIL)
        userInfo.HEAD && (state.user.head = userInfo.HEAD)
      },
    }

    const actions = {
      async login({ commit, dispatch, state }, { userName, password }) {
        let userInfo = await axios.post('/api/login', qs.stringify({ userName, password }))
        commit(BASE.SET_USER_INFO, userInfo)
      },
    }

    export default {
      // namespaced: true, // https://vuex.vuejs.org/zh/guide/modules.html#命名空间
      state,
      mutations,
      actions,
      getters,
    }
    ```

1.  修改 vuex 主文件`index.js`，组合所有状态模块

    ```js
    import Vue from 'vue'
    import Vuex from 'vuex'
    import getters from './getters'
    import actions from './actions'
    import mutations from './mutations'

    import base from './modules/base'
    import cart from './modules/cart'
    import products from './modules/products'

    // import createLogger from 'vuex/dist/logger' //vuex内置的Logger日志插件
    const debug = process.env.NODE_ENV !== 'production' // 发布品种时需要用 Webpack 的 DefinePlugin 来转换 process.env.NODE_ENV !== 'production' 的值为 false

    Vue.use(Vuex)

    const state = {}

    export default new Vuex.Store({
      state,
      getters,
      mutations,
      actions,
      modules: {
        base,
        cart,
        products,
        // https://vuex.vuejs.org/zh/guide/modules.html#模块动态注册
      },
      strict: debug, // 开发阶段使用
      // plugins: debug ? [createLogger()] : []//vuex插件,https://vuex.vuejs.org/zh/guide/plugins.html
    })
    ```

1.  修改`main.js`，引入 vuex

    ```js
    //...
    import store from './store/index'

    //...
    new Vue({
      el: '#app',
      router,
      store,
      // components: { App },
      // template: '<App/>',
      render: h => h(App), // https://cn.vuejs.org/v2/guide/render-function.html#JSX
    })
    ```

> https://juejin.im/post/5bcd967b6fb9a05d07197b1e
>
> [Vuex 实战：如何在大规模 Vue 应用中组织 Vuex 代码](https://juejin.im/post/5860cc47128fe10069e19c26)
>
> [super-vuex](https://github.com/cevio/super-vuex)

## 添加`mixins`文件夹

目录结构 ↓

```
mixins
    ├── index.js               # 全局mixin
```

## 添加`filters`文件夹

目录结构 ↓

```
filters
    ├── index.js               # 全局过滤器
```

## 添加`utils`文件夹

目录结构 ↓

```
utils
    ├── fetch.js               # axios
    ├── filters.js             # 全局filter
    └── mixin.js               # 全局mixin
```

`src/main.js`中添加全局引用 ↓

```js
import * as filters from './utils/filters'
import fetch from './utils/fetch'

/* 全局注册fetch */
Vue.prototype.$fetch = fetch

/* 注册全局过滤器 */
Object.keys(filters).forEach(key => {
  Vue.filter(key, filters[key])
})
```

## 封装 axios

```js
import Vue from 'vue'
import router from '../router'
import axios from 'axios'
import qs from 'qs'
import Toast from '../components/toast'

// #region config
// 每页条数
export const ROW = 10
// 加载最小时间
export const MINI_TIME = 300
// 超时时间（超时时间）
export const TIME_OUT_MAX = 8000
// 环境value
export const _env = process.env.NODE_ENV
// 请求组（判断当前请求数）
export const _requests = []
// #endregion

// #region 实例化axios
const _instance = axios.create({
  timeout: TIME_OUT_MAX,
})
// #endregion

// region request统一处理操作
_instance.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded;charset=UTF-8'
// POST传参序列化
_instance.interceptors.request.use(
  config => {
    if (config.method === 'post') {
      config.data = qs.stringify(config.data)
    }
    return config
  },
  error => {
    Toast('错误的传参')
    return Promise.reject(error)
  },
)
// endregion

// region response统一处理操作
_instance.interceptors.response.use(
  res => {
    let _message = null
    if (res.status !== 200) {
      console.error(res)
      switch (res.status) {
        case 404:
          _message = '404,错误请求'
          break
        case 401:
          router.push({ path: '/login', query: { redirect: router.currentRoute.fullPath } })
          _message = '未授权'
          break
        case 403:
          _message = '禁止访问'
          break
        case 408:
          _message = '请求超时'
          break
        case 500:
          _message = '服务器内部错误'
          break
        case 501:
          _message = '功能未实现'
          break
        case 503:
          _message = '服务不可用'
          break
        case 504:
          _message = '网关错误'
          break
        default:
          _message = '未知错误'
      }
      Toast(_message)
      return Promise.reject(_message)
    } else {
      return res
    }
  },
  error => {
    console.error(error)
    Toast(error || '服务器繁忙，请稍后重试')
    return Promise.reject(error || '服务器繁忙，请稍后重试')
  },
)
// endregion

// #region send get/post
let toast = null

/**
 * 发送GET请求
 * @param api 接口api
 * @param params 请求参数
 * @returns {Promise.<T>}
 */
async function get(api, params) {
  try {
    if (!toast) toast = Toast({ time: -1, message: '加载中', icon: 'loading' })
    let { data } = await _instance.get(api, { params })
    toast.close()
    return data
  } catch (e) {
    toast.close()
    Toast({ message: '网络异常', position: 'bottom' })
    throw e
  }
}

/**
 * 发送POST请求
 * @param api 接口api
 * @param params 请求参数
 * @returns {Promise.<T>}
 */
async function post(api, params) {
  try {
    if (!toast) toast = Toast({ time: -1, message: '加载中', icon: 'loading' })
    let { data } = await _instance.post(api, qs.stringify(params))
    toast.close()
    return data
  } catch (e) {
    toast.close()
    Toast({ message: '网络异常', position: 'bottom' })
    throw e
  }
}
// #endregion

export default {
  _instance,
  get,
  post,
}
```

## config 配置

### build 生成的文件路径使用相对路径

修改`config/index.js`文件中`build`节点的`assetsPublicPath`值

```js
module.exports = {
  dev: {
    // ...
  },

  build: {
    // ...
    assetsPublicPath: './',
    // ...
  },
}
```

### 开发的的时候需要使用代理(proxy)跨域访问服务器接口

修改`config/index.js`文件中`dev`节点的`proxyTable`值

```js
module.exports = {
  dev: {
    // ...
    proxyTable: {
      '/api': {
        target: 'https://123.57.89.97:8081',
        changeOrigin: true,
        // pathRewrite: {
        //   '^/api': '/api'
        // }
      },
    },
    // ...
  },
}
```

### 分离线上环境和本地环境的配置信息

修改`config/dev.env.js`与`config/prod.env.js`，为不同的环境配置文件添加与`NODE_ENV`同级的环境变量

```js
module.exports = {
  NODE_ENV: '"development"',
  API: '"https://123.57.89.97:8081"',
}
```

# 通用样式(SCSS)

目录结构 ↓

```
assets
    └── scss
        ├── base.scss         # 基础样式
        ├── common.scss       # 通用样式
        ├── fun.scss          # 函数
        ├── mixin.scss        # 混合
        └── variable.js       # 变量
```

## base.scss

```scss
@charset "utf-8";
@import 'variable';
@import 'fun';
@import 'mixin';
@import 'common';

/*基础样式*/

html,
body,
#app {
  position: absolute;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 1;
  width: 100%;
  height: 100%;
  font-family: Arial, 'Microsoft YaHei', '微软雅黑', Verdana, sans-serif;
}

ul,
li {
  padding: 0;
  margin: 0;
  list-style: none;
}

* > img {
  max-width: 100%;
  max-height: 100%;
}

button {
  position: relative;
  display: block;
  margin-left: auto;
  margin-right: auto;
  padding-left: 14px;
  padding-right: 14px;
  box-sizing: border-box;
  font-size: 18px;
  text-align: center;
  text-decoration: none;
  line-height: 2.55555556;
  border-radius: 5px;
  -webkit-tap-highlight-color: transparent;
  overflow: hidden;
  color: #000000;
  background-color: #f8f8f8;

  &::after {
    content: ' ';
    width: 200%;
    height: 200%;
    position: absolute;
    top: 0;
    left: 0;
    border: 1px solid rgba(0, 0, 0, 0.2);
    -webkit-transform: scale(0.5);
    transform: scale(0.5);
    -webkit-transform-origin: 0 0;
    transform-origin: 0 0;
    box-sizing: border-box;
    border-radius: 10px;
  }
}

//页面切换动画
.slide {
  &-enter,
  &-leave-to {
    -webkit-transform: translate(100%, 0);
    transform: translate(100%, 0);
  }

  &-enter-active,
  &-leave-active {
    transition: all 0.5s cubic-bezier(0.55, 0, 0.1, 1);
  }

  &-enter-to,
  &-leave {
    -webkit-transform: translate(0, 0);
    transform: translate(0, 0);
  }
}
```

## common.scss

```scss
@charset "UTF-8";
@import 'fun';
@import 'mixin';
@import 'variable';

/*通用样式*/

* {
  box-sizing: border-box;
}

.clear {
  display: block !important;
  clear: both !important;
  float: none !important;
  margin: 0 !important;
  padding: 0 !important;
  height: 0;
  line-height: 0;
  font-size: 0;
  overflow: hidden;
}

.clearfix {
  zoom: 1;
}

.clearfix:after {
  content: '';
  display: block;
  clear: both;
  height: 0;
}
```

## fun.scss

```scss
@charset "UTF-8";

/*函数*/

@function rem($pixels) {
  @return $pixels / 100px * 1rem;
}
```

## mixin.scss

```scss
@charset "UTF-8";

/*混合*/

@mixin fullpage {
  position: absolute;
  top: 0;
  bottom: 0;
  right: 0;
  left: 0;
}
```

## variable.scss

```scss
@charset "UTF-8";

@import 'fun';

/*变量*/

$headerHeight: rem(50px);
```

> **demo 地址**：[https://github.com/MrLeo/wedive](https://github.com/MrLeo/wedive)

# 查缺补漏

### 我用了 `axios` , 为什么 IE 浏览器不识别(IE9+)

那是因为 IE 整个家族都不支持 promise, 解决方案:

```bash
npm install es6-promise
```

```js
// 在 main.js 引入即可
// ES6的polyfill
require('es6-promise').polyfill()
```
