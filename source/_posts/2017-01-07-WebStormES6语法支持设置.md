---
title: WebStorm ES6 语法支持设置
tags:
  - 工具
  - dev
  - webstorm
categories:
  - 工具
abbrlink: '931279e8'
date: 2017-01-07 17:29:25
---

在 webstorm 写下了这段代码，体验一下 ES6 语法的便利，但是一大堆报错
![](https://i.loli.net/2019/06/29/5d172336126a428437.png)

<!-- more -->

## 语法支持设置

> Preferences > Languages & Frameworks > JavaScript

这里只要配置 ECMAScript 版本即可

![Preferences > Languages & Frameworks > JavaScript](https://i.loli.net/2019/06/29/5d17235239ba830464.png)

## 自动转码为 ES5

> file watcher + [babel](https://babeljs.io/)（ES6 转码器）

1.  `npm install -g babel-cli` / `npm install --save-dev babel-cli`
2.  Preferences > Tools > File watchers
3.  点击“+”按钮
    ![](https://i.loli.net/2019/06/29/5d1723672d2d917430.png)

    > **File Type**：配置该监听器监听的文件类型，可以在 Preferences > Editor > File types 中配置
    > **Scope**：配置该监听器的监听范围，可自定义新的范围，也可以使用 Preferences > Appearance & Behavior > Scopes
    > **Program**：babel 的安装位置
    > `C:\Users\lxbin\node_modules\.bin\babel.cmd`
 > **Arguments**：命令执行参数，参见 Babel CLI
    > `$FilePathRelativeToProjectRoot$ --out-dir dist --source-maps --presets es2015`
 > **Working directory**：babel 命令执行的位置，默认为文件所在目录
    > `dist\$FileDirRelativeToProjectRoot$\$FileNameWithoutExtension$.js:dist\$FileDirRelativeToProjectRoot$\$FileNameWithoutExtension$.js.map`

4.  最后在项目目录下面添加一个`.babelrc`文件
    ```json
    {
      "presets": ["es2015"]
    }
    ```
