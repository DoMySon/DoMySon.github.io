---
title: Http
date: 2020-02-09
tags: ["http"]
categories: ["Network"]
description: 解决并发场景下的数据竞争问题
img: https://www.runoob.com/wp-content/uploads/2015/06/go128.png
toc: true
draft: false
---

# Http 请求构成

## 请求行 

> 请求行以一个方法符号开头，以空格分开，后面跟着请求的URI和协议的版本，格式如下：Method Request-URI HTTP-Version CRLF  其中 Method表示请求方法；Request-URI是一个统一资源标识符；HTTP-Version表示请求的HTTP协议版本；CRLF表示回车和换行（除了作为结尾的CRLF外，不允许出现单独的CR或LF字符）。

Method|Desc
:-:|:-:
GET     |请求获取Request-URI所标识的资源
POST    |在Request-URI所标识的资源后附加新的数据
HEAD    |请求获取由Request-URI所标识的资源的响应消息报头
PUT     |请求服务器存储一个资源，并用Request-URI作为其标识
DELETE  |请求服务器删除Request-URI所标识的资源
TRACE   |请求服务器回送收到的请求信息，主要用于测试或诊断
CONNECT |保留将来使用
OPTIONS |请求查询服务器的性能，或者查询与资源相关的选项和需求

+ `POST` 和 `GET` 的区别:

    + 副作用：服务器上的资源做改变，如搜索是无副作用的，注册是副作用的。

    + 幂等：幂等指发送 M 和 N 次请求（两者不相同且都大于 1），服务器上资源的状态一致。

    在规范的应用场景上说，Get 多用于无副作用，幂等的场景，例如搜索关键字。Post 多用于副作用，不幂等的场景，例如注册。

    + Get 请求能缓存，Post 不能
    
    + Post 相对 Get 安全一点点，因为Get 请求都包含在 URL 里（当然你想写到 body 里也是可以的），且会被浏览器保存历史纪录。Post 不会，但是在抓包的情况下都是一样。

    + URL有长度限制，会影响 Get 请求，但是这个长度限制是浏览器规定的，不是 RFC 规定的

    + Post 支持更多的编码类型且不对数据类型限制

<!--more-->


## 消息报头

## 请求正文


# Http 响应构成

## 状态行

> HTTP-Version Status-Code Reason-Phrase CRLF。其中，HTTP-Version表示服务器HTTP协议的版本；Status-Code表示服务器发回的响应状态代码；Reason-Phrase表示状态代码的文本描述。

## 消息报头

## 响应正文


> 首部分为请求首部和响应首部，并且部分首部两种通用

[See Http Tool](/post/Http)

