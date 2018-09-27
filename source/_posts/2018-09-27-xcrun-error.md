---
title: Mac升级Mojave后使用出现xcrun：error错误
date: 2018-09-27 11:39:49
updated: 2018-09-27 11:39:49
categories:
  - mac
tags:
  - mac
  - error
  - Homebrew
  - brew
---

# 错误信息

使用 Homebrew 时发现出错了，提示:

```bash
Updating Homebrew...
==> Homebrew has enabled anonymous aggregate formulae and cask analytics.
Read the analytics documentation (and how to opt-out) here:
  https://docs.brew.sh/Analytics

xcrun: error: invalid active developer path (/Library/Developer/CommandLineTools), missing xcrun at: /Library/Developer/CommandLineTools/usr/bin/xcrun
Error: Failure while executing; `git config --local --replace-all homebrew.analyticsmessage true` exited with 1.
```

<!-- more -->

# 解决办法

可能原因：mac 系统升级后，自动卸载 xcode-select，引起 Git 不能正常工作引起的。

解决方法就是：

```shell
sudo xcode-select --install
```

# 参考

- [How to fix homebrew error: “invalid active developer path” after upgrade to OS X El Capitan?](https://apple.stackexchange.com/questions/209624/how-to-fix-homebrew-error-invalid-active-developer-path-after-upgrade-to-os-x)
