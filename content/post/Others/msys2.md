---
title: Msys2
date: 2020-03-12
tags: ["msys2"]
categories: ["others"]
description: 高性能web代理
img: https://www.runoob.com/wp-content/uploads/2015/06/go128.png
toc: true
draft: false
---


# 简介

+ msys2集成了mingw，同时msys2还有一些其他的特性，例如包管理器等。 

+ msys2可以在windows下搭建一个完美的类linux环境，包括bash、vim、gcc、make等工具都可以通过包管理器来添加和卸载 

+ msys2的包管理器是使用的是 `pacman`

[下载地址](https://www.msys2.org/)

<!--more-->

# 修改源

## 需要修改的文件

+ `\etc\pacman.d\mirrorlist.mingw32`

    在文件开头添加：`Server = http://mirrors.ustc.edu.cn/msys2/mingw/i686/`

+ `\etc\pacman.d\mirrorlist.mingw64`

    在文件开头添加：`Server = http://mirrors.ustc.edu.cn/msys2/mingw/x86_64/`

+ `\etc\pacman.d\mirrorlist.msys`

    在文件开头添加：`Server = http://mirrors.ustc.edu.cn/msys2/msys/$arch/`




# `pacman` 指令

+ pacman -Sy    更新软件包数据

+ pacman -Syu   更新所有

+ pacman -Ss sf 搜索软件信息

+ pacman -S sf  安装软件

+ pacman -R sf  删除软件