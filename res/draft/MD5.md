---
title: MD5
date: 2019-05-22
tags: ["channel"]
categories: ["Algorithm"]
description: go 内置命令
img: https://www.runoob.com/wp-content/uploads/2015/06/go128.png
toc: true
draft: false
---

# 简介
1. MD5(Messgae-digest algorithm5)信息摘要
2. 将任意长度的明文生成 `128bit` 或 `16byte` 的哈希值，也为`16个byte`,一般转为16进制表示,所以会显示32个字符，而MD5(16)则截取32个字符中间的串。
# 原理

## 步骤

1. 处理原文
    
    计算出原文长度（bit)，然后对 `512` 相除，得出 `M`，取余为 `K`，若 `K ≠ 448`,往后填充数据。（第一位填 `1`，往后填 `0`），直到 `K = 0`，原文长度现在变为 `512*M+448`。剩下 `512-448=64` 位用来填充原文原始长度，原文长度现在变为 `512*(M+1)`

2. 设置初始值

    `MD5` 哈希之后为 `128bit`，根据 `A,B,C,D` 四个初始值计算得到 `4个32bit` 。

    Name|Val
    :-:|:-:
    A|0x01234567
    B|0x89ABCDEF
    C|0xFEDCBA98
    D|0x76543210


3. 循环加工

4. 拼接结果

# 其他

> MD5+slat 即 明文+特定数字 生成新的MD5，或 原始MD5+随机生成16位数字组成48个字符的串
