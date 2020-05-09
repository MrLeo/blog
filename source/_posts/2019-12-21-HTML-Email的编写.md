---
title: HTML Email的编写
categories: 其他
tags:
  - email
  - 转载
abbrlink: 106ada5
date: 2019-12-21 01:25:56
updated: 2019-12-21 01:25:56
---
{% cq %}
[HTML Email的编写](https://juejin.im/post/5df0bdc25188251257286733)
{% endcq %}

总结回顾

- [这样回答继承，面试官可能更满意](https://juejin.im/post/5de67e76518825122322a9e2)
- [箭头函数和普通函数的10个区别](https://juejin.im/post/5de7ebd4518825127c26fbc1)
- [html 空白汉字占位符](https://juejin.im/post/5dee15a2518825125e1ba8e9)
- [我想了解更多判断数组的方式](https://juejin.im/post/5dee66936fb9a0161711ad55)
<!-- more -->
## 一、HTML Email的编写开发场景

- 你下单 可能 电商会给你发一份 详情邮件
- 招行可能给你发下你的账单邮件
- 生日了给你发个邮件
- 转正了给你发个邮件
- 入职周年邮件

## 二、遇到的问题

### Email的兼容性很差

邮件内容所在上下文或者说所在外部容器（以下简称环境）都是由邮箱服务商决定的，不同的邮件服务商对前端样式布局支持都存在在一些差别。这就要求邮件内容需要在任何一种情况下都要正常兼容显示。

### Email容器不同

你写的邮件前端代码可能被放在一个iframe中，那你的内容是被放在body里面的；可能放在一个div中，你的内容就被放在这个div里面。

### Email自带设置

邮箱软件本身设置设置了些css，他可能对你产生未知的影响。可能根本没有申明doctype，即使申明了，也不是你想要的doctype。

### 避免被嵌套在不正确的容器里

因为容器可能是body或div，我们邮件内容不应该是一个完整的html。所以邮件内容应该是以div为根节点的html片段。

## 三、环境（外部容器）

我们写的邮件代码在不用的邮件服务商下，对应的外部容器不太一样。

QQ邮箱：自己编写的内容被嵌套在一个div中

![16ef47792c6956c9.png](https://i.loli.net/2019/12/21/aqCZuxpdlKAw2ky.png)

outlook邮箱：自己编写的内容不知道被嵌套什么元素里了，它本身的元素加上我编写的元素被混在一起了

![16ef47aa05a4f633.png](https://i.loli.net/2019/12/21/3L9tIw6h4xNSzH2.png)

其他的邮箱你们可以自己测试一下

## 四、开发的Doctype

一个文档类型标记是一种标准通用标记语言的文档类型声明，它的目的是要告诉标准通用标记语言解析器，它应该使用什么样的文档类型定义（DTD）来解析文档。

兼容性最好的Doctype是XHTML 1.0 Strict，事实上Gmail和Hotmail会删掉你的Doctype，换上这个Doctype。使用这个Doctype，也就意味着，不能使用HTML5的语法。

![16ef48167b8d46b2.png](https://i.loli.net/2019/12/21/LHeGnzk9WD5RB2r.png)

![16ef4820bb240263.png](https://i.loli.net/2019/12/21/IQv2ZlkR3BXFAsw.png)

## 五、开发的布局

- 网页的布局（layout）推荐使用表格（table）
- css内嵌，不能在head标签中写style，也不能外联。
- 不能用浮动的方式定位。position：absolute;float:left;等都不行，float在qq邮箱客户端中可以识别，但是在outlook中无法识别。
- 为了保证兼容性，需要把邮件的宽度设置为600px，最大600px；

    ![16ef484d183ceefe.png](https://i.loli.net/2019/12/21/2bdzMVDwiEBLHWs.png)

> 网页的布局（layout）必须使用表格（table）。首先，放置一个最外层的大表格，用来设置背景。 在内层，放置第二个表格。用来展示内容。第二个table的宽度定为600像素，防止超过客户端的显示宽度。

## 六、开发的样式

- 避免css冲突或被覆盖
- 尽量使用div、span等无语义标签。
- 尽量避免CSS属性值的简写形式
- font-size:0; 很重要，否则qq邮箱 会自动填写很多空格，影响布局
- 减少不必要的间隙和空格等存在，影响页面美感
    ```html
    <!-- 错误的写法 -->
    <div style="font: 8px/14px Arial, sans-serif; margin: 1px 0;"> 
    
    <!-- 推荐写法 -->
    <div style="margin-top: 1px; margin-bottom: 1px; margin-left: 0; margin-right: 0;">
    ```

> 所有的CSS规则，最好都采用行内样式。因为放置在网页头部的样式，很可能会被客户端删除。客户端对CSS规则的支持情况 另外，不要采用CSS的简写形式，有些客户端不支持。因为环境中可能已经设置了css，比如一些reset、一些.class。 所以我们只能使用行内style来确保我们的效果，并且在内容根节点上设置基础style，并且尽量使用div、span等无语义标签。

## 七、开发图片

- 少用img，邮箱不会过滤你的img标签，但是系统往往会默认不载入陌生来信的图片
- 需要img的话，一定要写好alt和title；
- Outlook中img最高1728px，超过1728 的部分会被截掉
- Outlook可能自动缩小img，使其最高位1728px，（上次测试没缩放，直接裁了）
- 建议剪裁img，堆叠在一起
- 有些客户端会给img链接加上边框，要去除边框。
    ```html
    <img border="0" style="display:block;
                        outline:none; 
                        text-decoration:none; 
                        -ms-interpolation-mode: bicubic;
                        border:none;"> 
    ```

> 图片是唯一可以引用的外部资源。其他的外部资源，比如样式表文件、字体文件、视频文件等，一概不能引用。 有些客户端会给图片链接加上边框，要去除边框。 需要注意的是，不少客户端默认不显示图片（比如Gmail），所以要确保即使没有图片，主要内容也能被阅读。

## 八、开发的background

- 少用background 推荐尽可能使用切割的img
- Gmail也不支持css里面的背景图
- 在outlook2007、Outlook2010中，背景图片将无法显示

    ![16ef7c5af85ceff2.jpg](https://i.loli.net/2019/12/21/mviQVBXIrLYPlkn.jpg)

> 图片是唯一可以引用的外部资源。其他的外部资源，比如样式表文件、字体文件、视频文件等，一概不能引用。 有些客户端会给图片链接加上边框，要去除边框。 需要注意的是，不少客户端默认不显示图片（比如Gmail），所以要确保即使没有图片，主要内容也能被阅读。

## 九、email兼容总结

- 最好使用TABLE标签布局 ，通过tr td来控制距离 空白区域等
- 每个标签设置：margin:0;padding:0;font-size:0;（注意拆开写）
- 设置 width, height
- 少用img ,少用background
- 邮件不支持js，a标签慎用
- 在使用行高前建议添加mso-line-height-rule:exactly
- margin:0; padding: 0;colspan=“1” height=“375” 顺序不可换

> 客户端：foxmail outlook QQ邮箱 为了应付Email的怪癖，花了很多时间测试，确保搞定了所有Outlook的坑洼沟洄 但是….还是不可避免有兼容问题 如果你只要兼容 Foxmail and qq邮箱，那你几乎可以像写web一样写邮件。 由于邮件客户端对css支持各有不同，所以一定要多测试再发送，保证样式的正确。如果出现了不兼容的情况，一定要耐心的使用最简单的方式进行兼容，尽量少用特殊标签及比较复杂的属性。
