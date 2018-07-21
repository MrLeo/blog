---
title: 定制Vue项目模板
date: 2018-03-24 09:17:14
updated: 2018-03-24 09:17:14
categories: [前端,vue]
tags: [前端,dev,vue,vue-cli]
---

> 懒人改变世界

用过[`Vue.js`][vue]的同学对`vue-cli`一定都不陌生，借助`vue-cli`我们可以通过问答的形式，方便地初始化一个 vue 工程，完全不用担心繁琐的 webpack、eslint 配置等。

<!-- more -->

# 什么是[vue-cli][vue-cli]

引用 vue-cli 官方文档的一句话：

> A simple CLI for scaffolding Vue.js projects.
> 一个简单的 Vue.js 工程命令行脚手架工具。

在全局安装 vue-cli 之后，就可以通过一条命令初始化我们的 vue 工程：

```Bash
$ vue init <template-name> <project-name>
```

接下来 vue-cli 就会按照这个`<template-name>`模板内部的设置，抛出几个问答选项。在回答完问答选项以后，我们的 vue 工程目录就已经生成好了，接下来只要把依赖安装完，直接就可以跑起来，是不是非常方便呢？

接下来，我们就要看看，这一条命令的背后，究竟发生了一些什么事。

# vue-cli 初始化项目的原理

从[官方文档][vue-cli-readme]可以知道，vue-cli 使用了[download-git-repo][download-git-repo]这个工具去下载远端 git 仓库里面的工程，如果加上了`--clone`参数，则会在内部运行`git clone`，通过克隆的方式把远端 git 仓库拉取到本地。明白这一点至关重要：

**vue-cli 并非从无到有地凭空生成一个项目，而是通过下载/拉取已有的工程到本地，完成生成项目的工作**。

而这个“已有的工程”，就是所谓的“模板（template）”。

当然，vue-cli 可不只是把模板拉取到本地这么简单，它还允许我们通过问答的形式对模板进行个性化配置，这个又是如何做到的呢？

vue-cli 使用了[inquirer.js][inquirer.js]实现了“问答环节”，简单来说是这样子的：

```js
// 准备几个问题
const questions = [
  {
    type: 'input',
    name: 'name',
    message: 'What's your name?'
  },
  {
    type: 'input',
    name: 'age',
    message: 'How old are you?',
  }
]
```

然后把这段问题传给 inquirer.js 就可以了：

```js
inquirer.prompt(questions).then(({ name, age }) => {
  console.log(`My name is ${name}, and I'm ${age} years old`)
})
```

在运行的时候，vue-cli 会在命令行里面把`What's your name?`和`How old are you?`这两个问题相继抛出，获取用户输入，把输入赋值给`name`和`age`变量，这样就能够获取用户的输入信息了。接着我们引出下一个问题，这些用户输入，是如何跟模板的自定义关联起来的呢？

我们打开一个 vue-cli 的模板，比如[webpack-simple 里面的 README.md][webpack-simple-readme]，它长这样：

```
# {{ name }}

> {{ description }}
```

上面使用双括号包裹起来的，最终会根据用户的输入而更改为具体的内容。是不是觉得这种写法很熟悉？其实就是[Handlebars][handlebars]的模板语法。

以这个 README.md 文件为例，在 vue-cli 运行的过程中，会首先读取文件的内容放在内存，然后通过`inquirer.js`获取用户输入，把输入的值替换到文件内容里面，最后通过另外一个名叫[Metalsmith][metalsmith]的工具，把替换好的内容输出为文件，也就生成了具有个性化内容的 README.md 文件了。

整个流程并不复杂，在明白这些原理后，我们就能更深入地使用 vue-cli 了。

# vue-cli 与 vue

vue-cli 不仅仅能初始化 vue 工程，理论上能够初始化**一切工程**，包括 react，angular 等等等等，只要你有一份能够运行的**模板**，就能够通过 vue-cli 进行工程的初始化。

在讨论区有许多类似的问题：

- “vue-cli 当中如何配置 sass？”
- “vue-cli 中如何修改 devServer 的端口？”
- “vue-cli 中发现项目跑不起来”
- ……

vue-cli 说：“这锅我不背。”

是的，所遇到的问题都不是 vue-cli 的问题，而是相关模板的问题。那么应该如何写一份合格的模板呢？下面我们一起来研究一下。

# 写一份 vue-cli 模板

参考[官方文档][custom-templates]，也许还是不能理解到底应该怎么写，那么我们可以直接参考官方例子[vuejs-templates/webpack][vuejs-templates-webpack]，看看它到底是怎么写的。

## 初始化项目

- 先全局安装 [vue-cli][vue-cli] 脚手架工具：

  ```Bash
  $ npm install -g vue-cli
  ```

- 如果喜欢尝鲜的可以使用最新版的[`@vue/cli 3.0`](https://github.com/vuejs/vue-cli/tree/dev)

  > [`@vue/cli 3.0`](https://github.com/vuejs/vue-cli)默认是没有根据模板 init 项目的，不过官方提供了一个插件`@vue/cli-init`

  ```bash
  $ npm install -g @vue/cli
  # or
  $ yarn global add @vue/cli
  ```

  ```bash
  # vue init now works exactly the same as vue-cli@2.x
  $ npm install -g @vue/cli-init
  ```

安装完成后，初始化基于 `webpack` 的项目模板，按照指示依次填写项目信息和选择需要的模块：

```bash
$ vue init webpack vue-pro-demo
? Project name vue-pro-demo
? Project description A Vue.js project
? Author yugasun <leo@xuebin.com>
? Vue build standalone
? Install vue-router? Yes
? Use ESLint to lint your code? Yes
? Pick an ESLint preset Airbnb
? Set up unit tests No
? Setup e2e tests with Nightwatch? No
? Should we run `npm install` for you after the project has been created? (recommended) npm
   vue-cli · Generated "vue-pro-demo".
# Installing project dependencies ...
# ========================
...
# Project initialization finished!
# ========================
To get started:
  cd vue-pro-demo
  npm run dev
Documentation can be found at https://vuejs-templates.github.io/webpack
```

执行完成后，当前目录下就会生成命名为 `vue-pro-demo` 的项目文件夹，结构如下：

```bash
.
├── README.md           # 项目说明文件
├── build               # 存放webpack 构建文件
├── config              # 存放webpack 配置文件
├── index.html          # 项目html模板文件
├── package.json        # 存储项目包依赖，以及项目配置信息
├── src                 # 开发文件夹，一般业务代码都在这里写
└── static              # 项目静态资源文件夹
4 directories, 4 files
```

对于 `src` 目录，我们在开发中也会根据文件的功能进行文件夹拆分，比如我个人比较喜欢的结构如下（仅供参考）：

```bash
.
├── App.vue             # 项目根组件
├── api                 # 接口相关文件
├── assets              # 项目资源文件
│   ├── images          # -- 图片
│   └── scss            # -- 样式
├── components          # 通用组件
├── directive           # 全局自定义指令
├── filters             # 全局过滤器
├── main.js             # 项目入口文件
├── mixins              # 混入 (mixins)
├── mock                # mock数据
├── plugin              # 插件
├── router              # 路由
├── store               # vuex状态管理
├── utils               # 工具函数
└── views               # 视图类组件
```

规范的目录结构可以很好的规范化你的开发习惯，代码分工明确，便于维护。

## 定制开发项目模板

每个人在使用官方项目模板开发项目的时候，都或多或少的会修改一些默认的 `webpack` 配置，然后添加一些项目经常使用的的插件，也会根据自己需要在 `src` 目录下添加一些通用的文件夹目录，比如上面所说到的。

这就存在一个问题，每次我们在初始化项目的时候，都需要重复完成这几项操作，作为一个懒癌晚期患者的程序员，又怎么能容忍此类事情发生呢？所以定制化的需求蠢蠢欲动了。

下面就介绍下如何对官方的 [webpack 模板][vuejs-templates-webpack] 进行二次开发。

### 二次开发

要做到这点，只需要三步：

1.  Fork 官方源码 [vuejs-templates/webpack][vuejs-templates-webpack]
2.  克隆到本地二次开发，添加自己想要的配置和插件，并 push 到 github
3.  初始化项目时，使用我们自己的仓库就行

对于**步骤 1**，会使用 github 的朋友应该都没问题。

接下来，重点介绍下**步骤 2**。

克隆项目[vuejs-templates/webpack][vuejs-templates-webpack]到我们的本地后，你会发现目录结构是这样的：

```bash
.
├── LICENSE
├── README.md
├── deploy-docs.sh
├── docs
├── meta.js
├── package-lock.json
├── package.json
├── scenarios
├── template
└── utils
```

这里我们只需要关心`meta.js`和`template` 目录就够了，`meta.js`用来配置问答信息，`template`目录存放的就是我们的项目模板。

打开 `template/src/main.js` 文件（项目入口文件），代码如下：

```js
{{#if_eq build "standalone"}}
// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
{{/if_eq}}
import Vue from 'vue'
import App from './App'
{{#router}}
import router from './router'
{{/router}}

Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
  el: '#app',
  {{#router}}
  router,
  {{/router}}
  {{#if_eq build "runtime"}}
  render: h => h(App)
  {{/if_eq}}
  {{#if_eq build "standalone"}}
  components: { App },
  template: '<App/>'
  {{/if_eq}}
})
```

其中包含了很多 [Handlebars][handlebars] 的语法，这里主要用到了 `if` 条件判断语法，也很好理解。

然后就可以按照官方的模板照猫画虎修改自己的模板配置。

- **修改`template`模板文件**

  首先我们对 `template/package.json`做些调整，添加 vuex、axios、qs、pug、scss……依赖。最终修改完成的 package.json 文件如下。

  > 有可能一些小项目不需要 vuex，所以我对 vuex 添加`if`条件判断。

  ```json
  {
    "name": "{{ name }}",
    "version": "1.0.0",
    "description": "{{ description }}",
    "author": "{{ author }}",
    "private": true,
    "scripts": {
      "dev": "webpack-dev-server --inline --progress --config build/webpack.dev.conf.js",
      "start": "npm run dev",
      {{#if_eq runner "jest"}}
      "unit": "jest --config test/unit/jest.conf.js --coverage",
      {{/if_eq}}
      {{#if_eq runner "karma"}}
      "unit": "cross-env BABEL_ENV=test karma start test/unit/karma.conf.js --single-run",
      {{/if_eq}}
      {{#e2e}}
      "e2e": "node test/e2e/runner.js",
      {{/e2e}}
      {{#if_or unit e2e}}
      "test": "{{#unit}}npm run unit{{/unit}}{{#unit}}{{#e2e}} && {{/e2e}}{{/unit}}{{#e2e}}npm run e2e{{/e2e}}",
      {{/if_or}}
      {{#lint}}
      "lint": "eslint --ext .js,.vue src{{#unit}} test/unit{{/unit}}{{#e2e}} test/e2e/specs{{/e2e}}",
      {{/lint}}
      "build": "node build/build.js"
    },
    "dependencies": {
      "vue": "^2.5.2",
      {{#vuex}}
      "vuex": "^3.0.1",
      {{/vuex}}
      {{#router}}
      "vue-router": "^3.0.1",
      {{/router}}
      "axios": "^0.18.0",
      "qs": "^6.5.1"
    },
    "devDependencies": {
      {{#lint}}
      "babel-eslint": "^7.2.3",
      "eslint": "^4.15.0",
      "eslint-friendly-formatter": "^3.0.0",
      "eslint-loader": "^1.7.1",
      "eslint-plugin-vue": "^4.0.0",
      {{#if_eq lintConfig "standard"}}
      "eslint-config-standard": "^10.2.1",
      "eslint-plugin-promise": "^3.4.0",
      "eslint-plugin-standard": "^3.0.1",
      "eslint-plugin-import": "^2.7.0",
      "eslint-plugin-node": "^5.2.0",
      {{/if_eq}}
      {{#if_eq lintConfig "airbnb"}}
      "eslint-config-airbnb-base": "^11.3.0",
      "eslint-import-resolver-webpack": "^0.8.3",
      "eslint-plugin-import": "^2.7.0",
      {{/if_eq}}
      {{/lint}}
      {{#if_eq runner "jest"}}
      "babel-jest": "^21.0.2",
      "babel-plugin-dynamic-import-node": "^1.2.0",
      "babel-plugin-transform-es2015-modules-commonjs": "^6.26.0",
      "jest": "^22.0.4",
      "jest-serializer-vue": "^0.3.0",
      "vue-jest": "^1.0.2",
      {{/if_eq}}
      {{#if_eq runner "karma"}}
      "cross-env": "^5.0.1",
      "karma": "^1.4.1",
      "karma-coverage": "^1.1.1",
      "karma-mocha": "^1.3.0",
      "karma-phantomjs-launcher": "^1.0.2",
      "karma-phantomjs-shim": "^1.4.0",
      "karma-sinon-chai": "^1.3.1",
      "karma-sourcemap-loader": "^0.3.7",
      "karma-spec-reporter": "0.0.31",
      "karma-webpack": "^2.0.2",
      "mocha": "^3.2.0",
      "chai": "^4.1.2",
      "sinon": "^4.0.0",
      "sinon-chai": "^2.8.0",
      "inject-loader": "^3.0.0",
      "babel-plugin-istanbul": "^4.1.1",
      "phantomjs-prebuilt": "^2.1.14",
      {{/if_eq}}
      {{#e2e}}
      "babel-register": "^6.22.0",
      "chromedriver": "^2.27.2",
      "cross-spawn": "^5.0.1",
      "nightwatch": "^0.9.12",
      "selenium-server": "^3.0.1",
      {{/e2e}}
      "autoprefixer": "^7.1.2",
      "babel-core": "^6.22.1",
      "babel-helper-vue-jsx-merge-props": "^2.0.3",
      "babel-loader": "^7.1.1",
      "babel-plugin-syntax-jsx": "^6.18.0",
      "babel-plugin-transform-runtime": "^6.22.0",
      "babel-plugin-transform-vue-jsx": "^3.5.0",
      "babel-preset-env": "^1.3.2",
      "babel-preset-stage-2": "^6.22.0",
      "chalk": "^2.0.1",
      "copy-webpack-plugin": "^4.0.1",
      "css-loader": "^0.28.0",
      "extract-text-webpack-plugin": "^3.0.0",
      "file-loader": "^1.1.4",
      "friendly-errors-webpack-plugin": "^1.6.1",
      "html-webpack-plugin": "^2.30.1",
      "webpack-bundle-analyzer": "^2.9.0",
      "node-notifier": "^5.1.2",
      "node-sass": "^4.7.2",
      "postcss-import": "^11.0.0",
      "postcss-loader": "^2.0.8",
      "postcss-url": "^7.2.1",
      "pug": "^2.0.1",
      "pug-loader": "^2.3.0",
      "sass-loader": "^6.0.7",
      "semver": "^5.3.0",
      "shelljs": "^0.7.6",
      "optimize-css-assets-webpack-plugin": "^3.2.0",
      "ora": "^1.2.0",
      "rimraf": "^2.6.0",
      "uglifyjs-webpack-plugin": "^1.1.1",
      "url-loader": "^0.5.8",
      "vue-loader": "^13.3.0",
      "vue-style-loader": "^3.0.1",
      "vue-template-compiler": "^2.5.2",
      "portfinder": "^1.0.13",
      "webpack": "^3.6.0",
      "webpack-dev-server": "^2.9.1",
      "webpack-merge": "^4.1.0"
    },
    "engines": {
      "node": ">= 6.0.0",
      "npm": ">= 3.0.0"
    },
    "browserslist": [
      "> 1%",
      "last 2 versions",
      "not ie <= 8"
    ]
  }
  ```

  修改入口文件如下

  ```js
  /*
   *                     _ooOoo_
   *                    o8888888o
   *                    88" . "88
   *                    (| -_- |)
   *                    O\  =  /O
   *                 ____/`---'\____
   *               .'  \\|     |//  `.
   *              /  \\|||  :  |||//  \
   *             /  _||||| -:- |||||-  \
   *             |   | \\\  -  /// |   |
   *             | \_|  ''\---/''  |   |
   *             \  .-\__  `-`  ___/-. /
   *           ___`. .'  /--.--\  `. . __
   *        ."" '<  `.___\_<|>_/___.'  >'"".
   *       | | :  `- \`.;`\ _ /`;.`/ - ` : | |
   *       \  \ `-.   \_ __\ /__ _/   .-` /  /
   *  ======`-.____`-.___\_____/___.-`____.-'======
   *                     `=---='
   *  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   *              佛祖保佑       永无BUG
   */
  {{#if_eq build "standalone"}}
  // The Vue build version to load with the `import` command
  // (runtime-only or standalone) has been set in webpack.base.conf with an alias.
  {{/if_eq}}
  import Vue from 'vue'
  import App from './App'
  {{#router}}
  import router from './router'
  {{/router}}
  {{#vuex}}
  import store from './store'
  {{/vuex}}

  Vue.config.productionTip = false

  Vue.nextTick(() => {
    if (window.addEventListener) {
      const html = document.documentElement
      let setFont = () => {
        const k = 750
        html.style.fontSize = html.clientWidth / k * 32 + 'px'
      }
      setFont()
      setTimeout(function () {
        setFont()
      }, 300)
      document.addEventListener('DOMContentLoaded', setFont, false)
      window.addEventListener('resize', setFont, false)
      window.addEventListener('load', setFont, false)
    }
  })

  /* eslint-disable no-new */
  new Vue({
    el: '#app',
    {{#router}}
    router,
    {{/router}}
    {{#vuex}}
    store,
    {{/vuex}}
    {{#if_eq build "runtime"}}
    render: h => h(App)
    {{/if_eq}}
    {{#if_eq build "standalone"}}
    components: { App },
    template: '<App/>'
    {{/if_eq}}
  })
  ```

- 修改`meta.js`

  例如上面的我在 main.js 中添加 vuex 的相关信息，但是有些小项目可能用不上 vuex，这是我们可以模仿官方的问答模式添加自己的问题，这里我选择询问是否安装 router 之后询问是否安装 vuex。

  > - `prompts`：问答列表。
  > - `filters`：根据问答列表要过滤的文件夹。

  - 例如我在 prompts 的 router 下一条添加 vuex ↓

    ```js
    vuex: {
      when: 'isNotTest',
      type: 'confirm',
      message: 'Install vuex?'
    }
    ```

  - 如果选择了不需要 vuex 的，则对应不生成 store 文件夹，所以在 filters 里添加 ↓
    ```js
    'src/store/**/*': 'vuex'
    ```

  完整的 `meta.js` 修改如下：

  ```js
  const path = require('path')
  const fs = require('fs')

  const { sortDependencies, installDependencies, runLintFix, printMessage } = require('./utils')
  const pkg = require('./package.json')

  const templateVersion = pkg.version

  const { addTestAnswers } = require('./scenarios')

  module.exports = {
    metalsmith: {
      // When running tests for the template, this adds answers for the selected scenario
      before: addTestAnswers,
    },
    helpers: {
      if_or(v1, v2, options) {
        if (v1 || v2) {
          return options.fn(this)
        }

        return options.inverse(this)
      },
      template_version() {
        return templateVersion
      },
    },

    prompts: {
      name: {
        when: 'isNotTest',
        type: 'string',
        required: true,
        message: 'Project name',
      },
      description: {
        when: 'isNotTest',
        type: 'string',
        required: false,
        message: 'Project description',
        default: 'A Vue.js project',
      },
      author: {
        when: 'isNotTest',
        type: 'string',
        message: 'Author',
      },
      build: {
        when: 'isNotTest',
        type: 'list',
        message: 'Vue build',
        choices: [
          {
            name: 'Runtime + Compiler: recommended for most users',
            value: 'standalone',
            short: 'standalone',
          },
          {
            name:
              'Runtime-only: about 6KB lighter min+gzip, but templates (or any Vue-specific HTML) are ONLY allowed in .vue files - render functions are required elsewhere',
            value: 'runtime',
            short: 'runtime',
          },
        ],
      },
      router: {
        when: 'isNotTest',
        type: 'confirm',
        message: 'Install vue-router?',
      },
      vuex: {
        when: 'isNotTest',
        type: 'confirm',
        message: 'Install vuex?',
      },
      lint: {
        when: 'isNotTest',
        type: 'confirm',
        message: 'Use ESLint to lint your code?',
      },
      lintConfig: {
        when: 'isNotTest && lint',
        type: 'list',
        message: 'Pick an ESLint preset',
        choices: [
          {
            name: 'Standard (https://github.com/standard/standard)',
            value: 'standard',
            short: 'Standard',
          },
          {
            name: 'Airbnb (https://github.com/airbnb/javascript)',
            value: 'airbnb',
            short: 'Airbnb',
          },
          {
            name: 'none (configure it yourself)',
            value: 'none',
            short: 'none',
          },
        ],
      },
      unit: {
        when: 'isNotTest',
        type: 'confirm',
        message: 'Set up unit tests',
      },
      runner: {
        when: 'isNotTest && unit',
        type: 'list',
        message: 'Pick a test runner',
        choices: [
          {
            name: 'Jest',
            value: 'jest',
            short: 'jest',
          },
          {
            name: 'Karma and Mocha',
            value: 'karma',
            short: 'karma',
          },
          {
            name: 'none (configure it yourself)',
            value: 'noTest',
            short: 'noTest',
          },
        ],
      },
      e2e: {
        when: 'isNotTest',
        type: 'confirm',
        message: 'Setup e2e tests with Nightwatch?',
      },
      autoInstall: {
        when: 'isNotTest',
        type: 'list',
        message: 'Should we run `npm install` for you after the project has been created? (recommended)',
        choices: [
          {
            name: 'Yes, use NPM',
            value: 'npm',
            short: 'npm',
          },
          {
            name: 'Yes, use Yarn',
            value: 'yarn',
            short: 'yarn',
          },
          {
            name: 'No, I will handle that myself',
            value: false,
            short: 'no',
          },
        ],
      },
    },
    filters: {
      '.eslintrc.js': 'lint',
      '.eslintignore': 'lint',
      'config/test.env.js': 'unit || e2e',
      'build/webpack.test.conf.js': "unit && runner === 'karma'",
      'test/unit/**/*': 'unit',
      'test/unit/index.js': "unit && runner === 'karma'",
      'test/unit/jest.conf.js': "unit && runner === 'jest'",
      'test/unit/karma.conf.js': "unit && runner === 'karma'",
      'test/unit/specs/index.js': "unit && runner === 'karma'",
      'test/unit/setup.js': "unit && runner === 'jest'",
      'test/e2e/**/*': 'e2e',
      'src/router/**/*': 'router',
      'src/store/**/*': 'vuex',
    },
    complete: function(data, { chalk }) {
      const green = chalk.green

      sortDependencies(data, green)

      const cwd = path.join(process.cwd(), data.inPlace ? '' : data.destDirName)

      if (data.autoInstall) {
        installDependencies(cwd, data.autoInstall, green)
          .then(() => {
            return runLintFix(cwd, data, green)
          })
          .then(() => {
            printMessage(data, green)
          })
          .catch(e => {
            console.log(chalk.red('Error:'), e)
          })
      } else {
        printMessage(data, chalk)
      }
    },
  }
  ```

### 本地测试使用

好了，这样我们的自定义组件已经添加完成了，那么在提交之前，我们还需要先测试下修改后的模板是否有效，运行命令进行初始化：

```npm
$ vue init path/to/webpack-template my-project
```

这里 `vue init` 的第一个参数 `path/to/webpack-template` 就是当前修改后的模板路径，之后还是重复交互式的配置过程，然后运行你的项目就行了。

不出意外地话，你的项目会很顺利的 `npm run dev` 跑起来，之后我们只需要 `push` 到我们自己的 `github` 仓库就行了。

### 使用

提交以后，项目同事都可以共享这份模板了，用的时候只需要运行以下命令：

```bash
$ vue init MrLeo/webpack my-project
```

> 这里的 `MrLeo/webpack` 参数就是告诉 `vue-cli` 在初始化的时候到用户 `MrLeo` 的 github 仓库下载 `webpack`项目模板。

之后你就可以愉快的编写输出你的 `Hello world` 了。

### 补充说明

当你你足够熟悉项目模板，你也可以对 `webpack` 配置进行更个性化的配置，或者添加 `vue init` 时的交互式命令。感兴趣的可以参看下我的个人模板 [MrLeo/webpack][mrleo/webpack]。

> by [yugasun](https://yugasun.com/) from <https://yugasun.com/post/you-dont-know-vuejs-9.html>
>
> by [jrainlau](https://segmentfault.com/u/jrainlau) from <https://segmentfault.com/a/1190000011643581?_ea=2709729>

[vue]: https://cn.vuejs.org/ 'Vue.js - A progressive, incrementally-adoptable JavaScript framework for building UI on the web.'
[vue-cli]: https://github.com/vuejs/vue-cli/tree/master 'A simple CLI for scaffolding Vue.js projects.'
[vue-cli-readme]: https://github.com/vuejs/vue-cli/blob/master/README.md 'vue-cli README.md'
[download-git-repo]: https://github.com/flipxfx/download-git-repo 'Download and extract a git repository (GitHub, GitLab, Bitbucket) from node.'
[inquirer.js]: https://github.com/SBoudrias/Inquirer.js 'A collection of common interactive command line user interfaces.'
[webpack-simple-readme]: https://github.com/vuejs-templates/webpack-simple/blob/master/template/README.md
[handlebars]: https://handlebarsjs.com/ 'Handlebars provides the power necessary to let you build semantic templates effectively with no frustration.'
[metalsmith]: https://github.com/segmentio/metalsmith 'An extremely simple, pluggable static site generator.'
[vuejs-templates-webpack]: https://github.com/vuejs-templates/webpack 'A full-featured Webpack + vue-loader setup with hot reload, linting, testing & css extraction.'
[custom-templates]: https://github.com/vuejs/vue-cli/blob/master/README.md#custom-templates "It's unlikely to make everyone happy with the official templates."
[mrleo/webpack]: https://github.com/MrLeo/webpack 'A full-featured Webpack + vue-loader + vuex setup with hot reload, linting, testing & css extraction.'
