---
title: "关于"
description: AAAAA
date: 2019-02-13
type: about
---

> 专业 Unity、Golang 划水师，专注于各种花式打杂，会拼写 `C、Golang、CSharp、Lua、Js、MySQL、Redis` 等单词

# 技术栈

Docker、Nginx、Golang、Git、Centos、Markdown，WebHook

# 技术栈变更

## 为什么使用 `Golang`

之前使用 `Node.js` 作为服务端，总的来说 V8 性能并不低，但比起 `Golang` 静态编译型还是差了数量级，而且 `Docker` 打包 `Node.js` 和 `npm` 造成镜像过大，（将近 `1.2GB`），但使用 `Golang` 二进制执行文件后,镜像目前优化到 `600MB`。（项目文件接近 `300MB`），也就是说，所有环境仅仅 `300MB` 不到。

## 为什么使用 `Docker`

`Docker` 的一个好处是 **一次打包，到处部署**，如果后续服务迁移的话不用担心重新部署环境。

## 为什么使用 `Nginx`

> 目前由于单机部署，所以 `Nginx` 的负载均衡并没有到

+ 高性能

+ 占比大

+ 配置方便

