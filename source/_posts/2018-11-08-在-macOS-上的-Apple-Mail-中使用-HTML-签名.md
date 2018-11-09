---
title: 在 macOS 上的 Apple Mail 中使用 HTML 签名
date: 2018-11-08 23:09:23
updated: 2018-11-08 23:09:23
categories: [mac]
tags:
- mac
- mail
- 邮件
---

> 原文地址：[https://cherysunzhang.com/2017/01/how-to-make-an-html-signature-in-apple-mail-for-macos/](https://cherysunzhang.com/2017/01/how-to-make-an-html-signature-in-apple-mail-for-macos/)

在 macOS 上最常使用的邮件客户端就是内建的 Mail.app，默认地，Mail.app 的签名在编辑的时候只有纯文本输入，但实际上可以使用 HTML 使签名更具定制化。通常 macOS 将 Mail.app 称之为“邮件”或 Mail，这里为了与其他第三方的邮件客户端名称进行区分，我们将其称之为 Apple Mail。

本文以 macOS Sierra 10.12 为示例，其他版本的 macOS 有可能操作方法有些许不同，具体在各个版本上的区别就需要自行研究了。

<!--more-->

## 新建签名

在 Apple Mail 中，通过菜单选取“邮件”>“偏好设置…”，然后点按“签名”。下面简要说明一下如何新建签名。如果你之前一直有在使用 Apple Mail 的签名，那么应该对这项工作已经非常熟悉了。

1. 选取“邮件”>“偏好设置…”，然后点按“签名”。
2. 在左侧栏中，选择想要应用签名的电子邮件帐户，然后点按“+”￼。可以将签名从一个帐户拖到另一个帐户，或拖入“所有签名”以及从中拖出。如果在“所有签名”中创建签名，必须将该签名拖到帐户中才能使用。
3. 在中间栏中，为签名键入名称。当编写邮件时，该名称将出现在邮件标头的“签名”弹出式菜单中。
4. 在右侧栏（预览）中，创建签名。

这里，我们新建一个签名，并且随意输入一些文字，例如：

> This is a placeholder signature.

关闭偏好设置然后退出 Apple Mail。

## 编辑 HTML

创建一个 HTML 页面，例如下面这样。具体的方法不再赘述，想必如果你并没有掌握 HTML 和 CSS，也不会来阅读这篇文章。

![使用 Sublime Text 编辑 HTML](https://cherysunzhang.com/static/2017/01/editing-html.png)

> 需要注意的是，HTML 中不要包含 `<html>`、`</html>` 和 `<head> … </head>` 标签。只保留 `<body> … </body>` 标签中的内容即可。

如果你需要参考我所使用的 HTML，可以到 [这里](https://gist.github.com/cherysun/dbcfff9c03b145646b392d21d0780030) 查看 GitHub Gist。

## 修改 .mailsignature 文件

### 根据 iCloud Drive 使用情况以定位 .mailsignature 文件

由于 Apple Mail 并不允许直接在“偏好设置”中编辑 HTML，而实际上签名却又是以 HTML 的形式存储的，所以我们需要找到存储签名的文件并且对其进行编辑，将自己编辑的 HTML 放置于其中。

不过，这些存储签名的文件在 Finder 中并不可见，所以我们需要使用 Terminal。而且存储签名的文件的路径也并不一定相同，这依赖于你是否打开了 iCloud Drive，使用 iCloud Drive 同步数据。（为了检查是否打开了 iCloud Drive，选取“Apple 菜单”>“系统偏好设置”，点按“iCloud”，然后选择“iCloud Drive”。）

**使用 iCloud Drive 情况下的存储路径：**

```shell
~/Library/Mobile\ Documents/com~apple~mail/Data/V4/Signatures/
```

**不使用 iCloud Drive 情况下的存储路径：**

```shell
~/Library/Mail/V4/MailData/Signatures/
```

### 使用 Terminal 定位 .mailsignature 文件

打开 Terminal，在其中输入以下命令，以列出 Apple Mail 所存储的所有 .mailsignature 文件。在 Mail “偏好设置”中的所有签名，每一个签名都会被存储在该路径下的一个 .mailsignature 文件中。

**使用 iCloud Drive：**

```shell
$ ls -laht ~/Library/Mobile\ Documents/com~apple~mail/Data/V4/Signatures/*.mailsignature
```

**不使用 iCloud Drive：**

```shell
$ ls -laht ~/Library/Mail/V4/MailData/Signatures/*.mailsignature
```

可以看到，在示例中，我有 2 个存储签名的文件。

![使用 iCloud Drive 时通过 Terminal 定位 .mailsignature 文件](https://cherysunzhang.com/static/2017/01/list-mailsignature-files-in-terminal.png)

### 使用 Sublime Text 修改 .mailsignature 文件

如果你习惯于使用其他文本编辑器也是没有问题的，这里我以我自己最常使用的 Sublime Text 来做说明。有关 Sublime Text 的一些使用技巧，可以参考以下的几篇文章：

> - [使用 iCloud Drive 同步 Sublime Text 3 的偏好设置和扩展包](https://cherysunzhang.com/2016/07/sync-sublime-text-3-preferences-and-installed-packages-using-icloud-drive/)
> - [使用 Package Syncing 同步 Sublime Text 3 的偏好设置和扩展包](https://cherysunzhang.com/2016/08/syncing-sublime-text-3-preferences-and-installed-packages-using-package-syncing/)

在 Terminal 中，输入以下命令指定使用 Sublime Text 来打开 .mailsignature 文件。

**使用 iCloud Drive：**

```shell
$ open -a Sublime\ Text ~/Library/Mobile\ Documents/com~apple~mail/Data/V4/Signatures/*.mailsignature
```

**不使用 iCloud Drive：**

```shell
$ open -a Sublime\ Text ~/Library/Mail/V4/MailData/Signatures/*.mailsignature
```

打开后可以看到，前 5 行是有关该签名的元数据，不要进行修改。从第 7 行开始的 `<body> … </body>` 即是签名内容的 HTML，这时我们只要将此前编辑的 HTML 覆盖掉原有的 HTML 即可。

![使用 Sublime Text 修改 .mailsignature 文件](https://cherysunzhang.com/static/2017/01/changing-mailsignature-files.png)

> 再次注意，HTML 中不要包含 `<html>`、`</html>` 和 `<head> … </head>` 标签。只保留 `<body> … </body>` 标签中的内容即可。

存储并关闭 .mailsignature 文件。

## 如果不使用 iCloud Drive，锁定 .mailsignature 文件

> 如果使用 iCloud Drive，请跳过该步骤。

如果不使用 iCloud Drive，尽管此前已经存储了 .mailsignature 文件，但 Apple Mail 仍然会使用原有的签名并覆盖你对 .mailsignature 文件的修改。因此需要通过 Terminal 锁定 .mailsignature 文件以阻止写入。

打开 Terminal，输入以下命令锁定 .mailsignature 文件。

```shell
$ chflags uchg ~/Library/Mail/V4/MailData/Signatures/*.mailsignature
```

当需要再次编辑 .mailsignature 文件时，可以输入以下命令解除锁定 .mailsignature 文件。

```shell
$ chflags nouchg ~/Library/Mail/V4/MailData/Signatures/*.mailsignature
```

## 测试签名

重新打开 Apple Mail，在“偏好设置”中可以看到已经生效的 HTML 签名，只不过引用的图片暂时无法在这里显示出来。没关系，新建邮件，可以看到新的签名已经生效了。发送一封邮件试试吧。

![测试签名](https://cherysunzhang.com/static/2017/01/testing-signature.png)