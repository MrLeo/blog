---
title: vscode snippet 插件开发
categories:
  - 工具
tags:
  - 工具
  - vscode
  - snippet
  - 插件
abbrlink: a0508b9c
date: 2019-03-12 10:16:22
updated: 2019-03-12 10:16:22
---



> 应用商店地址: [https://marketplace.visualstudio.com/items?itemName=MrLeo.zpm-snippet](https://marketplace.visualstudio.com/items?itemName=MrLeo.zpm-snippet)



每个程序猿都有很多自己的代码片段，没到使用的时候都是 Ctrl+C & Ctrl+V 粘过来粘过去，对于一个爱偷懒的程序猿，这样的重复工作能不能减少呢。

工欲善其事必先利其器。vscode作为优秀的开发工具，给我的日常开发工作提供了极大的便利。其拓展机制更是如此。

于是便想着自己来开发这么个东西来管理自己的代码片段，一方面方便后边自己使用，一方面也能学习下vscode的插件开发、发布方法，另一方面要是发布后对其他人有所帮助就更好了。



# 参考

- [VS Code 插件开发文档-中文版](https://liiked.github.io/VS-Code-Extension-Doc-ZH/#/)
- [VSCode插件开发全攻略](http://blog.haoji.me/vscode-plugin-overview.html)
- [插件市场](https://marketplace.visualstudio.com/) / [插件管理](https://marketplace.visualstudio.com/manage)



<!--more-->

# vscode插件开发、发布主要流程

1. 插件开发前的准备：vscode、nodejs、vscode插件生产工具、git、微软账号
2. 插件开发：插件构思、[官方文档](https://code.visualstudio.com/api/get-started/your-first-extension)查阅
3. 插件发布：打包、上传、[插件市场](https://marketplace.visualstudio.com/)操作
4. 插件维护：更新迭代后打包、上传、[插件市场](https://marketplace.visualstudio.com/)操作



# 准备

vscode、nodejs、git、微软账号，这个的准备无需多说。

vscode插件生产工具：[官方推荐](https://code.visualstudio.com/api/get-started/your-first-extension)使用Yeoman 和 VS Code Extension Generator。用如下命令安装：

```bash
# 插件生成器
npm install -g yo generator-code
```

至此开发所需的准备已做好。



# 开发

```bash
# 初始化代码
yo code
```

结果如下：

```bash
$ yo code

     _-----_     ╭──────────────────────────╮
    |       |    │   Welcome to the Visual  │
    |--(o)--|    │   Studio Code Extension  │
   `---------´   │        generator!        │
    ( _´U`_ )    ╰──────────────────────────╯
    /___A___\   /
     |  ~  |
   __'.___.'__
 ´   `  |° ´ Y `

? What type of extension do you want to create? (Use arrow keys)
> New Extension (TypeScript)
  New Extension (JavaScript)
  New Color Theme
  New Language Support
  New Code Snippets
  New Keymap
  New Extension Pack
(Move up and down to reveal more choices)
```

在os系统上通过上下键来选择要创建的类型，在win上输入1、2、3后按回车来选择。

其余步骤根据提示即可。得到如下结构目录结构：

```
.
├── .vscode                              // 资源配置文件
├── CHANGELOG.md                         // 更改记录文件，会展示到vscode插件市场
├── README.md                            // 插件介绍文件，会展示到vscode插件市场
├── logo.png                             // 插件图标
├── package.json                         // 资源配置文件
├── snippets                             // 存放所有片段
│   └── javascript.json                  // javascript的代码片段
└── vsc-extension-quickstart.md
```

> **ps：**其余项目类型的文档目录可能会有所差别，以生成的文件目录为准。在snippet拓展项目下，最重要的就是``snippets/*.json`和`package.json`

如果不知道如何编写snippet文件，可以使用[snippet-generator](https://snippet-generator.app/)生成你需要的代码片段

如果想知道具体vscode支持的代码片段格式，可以阅读：[Creating your own snippets](https://code.visualstudio.com/docs/editor/userdefinedsnippets)

开发其他vscode插件，可以查阅文档[vscode-api](https://code.visualstudio.com/api/references/vscode-api)



添加不同语言的代码片段，只需要在`snippets`文件夹中添加对应语言的`.json`文件，然后向`package.json`文件的`contributes.snippets`属性中添加片段文件路径并制定应用的语言👇

```json
{
  "name": "zpm-snippet", // 插件的名称必须用全小写无空格的字母组成。
  "displayName": "zpm-snippet", // 插件市场所显示的插件名称。
  "description": "智联 ZPFE API 项目 VSCode 代码片段", // 简单地描述一下你的插件是做什么的。
  "version": "0.0.10", // 版本号
  "publisher": "MrLeo", // 发行方名称
  "icon": "logo.png", // 应用图标
  // 插件市场所显示的插件关联的github仓库
  "repository": {
    "type": "git",
    "url": "https://github.com/MrLeo/zpm-snippet.git"
  },
  // 一个至少包含vscode字段的对象，其值必须兼容 VS Code版本。
  // 不可以是*。
  // 例如：^0.10.5 表明最小兼容0.10.5版本的VS Code。
  "engines": {
    "vscode": "^1.31.0"
  },
  // 你想要使用的插件分类，可选值有：[Programming Languages, Snippets, 
  // Linters, Themes, Debuggers, Formatters, Keymaps, SCM Providers, 
  // Other, Extension Packs, Language Packs]
  "categories": [
    "Snippets"
  ],
  // 描述插件发布内容的对象。
  "contributes": {
    "snippets": [
      {
        "language": "javascript",
        "path": "./snippets/javascript.json"
      }
    ]
  }
}
```

> 更多插件清单文件说明：[package.json](https://liiked.github.io/VS-Code-Extension-Doc-ZH/#/extensibility-reference/extension-manifest)



# 构建

```bash
# 安装打包&发布工具
npm install -g vsce

# 打包插件
vsce package
```

打包成功后会在根目录下得到：`zpm-snippet-0.0.10.vsix`文件



# 发布

在[插件市场官网](https://marketplace.visualstudio.com/manage/publishers/)创建发布人

![image-20190312113750984](https://ws2.sinaimg.cn/large/006tKfTcly1g0zuxvhq1rj30y107zmy9.jpg)

- 方法一：用vsce的`vsce publish`工具来发布，但是需要在官网配置`Personal Access Token`较为繁琐。可参考[官方教程](https://code.visualstudio.com/api/working-with-extensions/publishing-extension)

- 方法二：在官网直接上传发布

  ![](https://ws4.sinaimg.cn/large/006tKfTcly1g0zv5eor8hj30yg07dwg3.jpg)
  ![](https://ws1.sinaimg.cn/large/006tKfTcly1g0zv4jpijaj30xs07imxd.jpg)
  ![](https://ws3.sinaimg.cn/large/006tKfTcly1g0zv5qseo2j30wx0gc3zq.jpg)上传后点击确定即可发布成功。



# 检查

- 在插件市场官网看状态

  ![](https://ws1.sinaimg.cn/large/006tKfTcly1g0zv8cg750j30x107x3yz.jpg)

- 在插件市场官网搜索

  ![](https://ws2.sinaimg.cn/large/006tKfTcly1g0zv8eai49j30x70cptaf.jpg)

- 在vscode插件页搜索

  ![](https://ws1.sinaimg.cn/large/006tKfTcly1g0zv8h3w76j30yg0f5ab4.jpg)



# 维护

在发现bug和新功能开发完成后，需要更新插件，只需要将新生产的.vsix包上传到官网即可。

![](https://ws1.sinaimg.cn/large/006tKfTcly1g0zv9v8qcwj30yb0bmdgi.jpg)

