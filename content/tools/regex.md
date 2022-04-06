---
title: Regular
date: 2019-08-27
tags: ["Regex"]
categories: ["Tools"]
description: Docker是一个好东西
img: https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=3775172144,3501685571&fm=58&bpow=500&bpoh=416
toc: true
draft: true
---

> 正则表达式(regular expression)描述了一种字符串匹配的模式（pattern），可以用来检查一个串是否含有某种子串、将匹配的子串替换或者从某个串中取出符合某个条件的子串等。



# 元字符

字符|描述
:-:|:-:
`\`|将下一个字符标记为一个特殊字符、或一个原义字符、或一个 向后引用、或一个八进制转义符。例如，'n' 匹配字符 "n"。'\n' 匹配一个换行符。序列 '\\' 匹配 "\" 而 "\(" 则匹配 "("。
`^`|匹配输入字符串的开始位置。如果设置了 RegExp 对象的 Multiline 属性，^ 也匹配 '\n' 或 '\r' 之后的位置。
`$`|匹配输入字符串的结束位置。如果设置了RegExp 对象的 Multiline 属性，$ 也匹配 '\n' 或 '\r' 之前的位置。