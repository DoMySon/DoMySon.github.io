---
title: go历代版本
date: 2020-02-13
categories: ["go"]
description: go版本变迁史
toc: true
draft: false
---


# Go 版本变迁差异

<!--more-->

# Go 1.14

> [摘自](https://www.toutiao.com/i6792777465518359054/)

## `defer` 大幅度提升，相较于上个版本，开销几乎为0

## 支持异步抢占

```go
package main
import (
    "runtime"
    "time"
)
func main() {
    runtime.GOMAXPROCS(1)
    go func() {
        for {

        }
    }()
    time.Sleep(time.Millisecond)println("OK")}
```

+ 在历史版本中,上述代码不会有任何输出

+ Go1.14程序启动时，在 runtime.sighandler 函数中注册了 SIGURG 信号的处理函数 runtime.doSigPreempt，在触发垃圾回收的栈扫描时，调用函数挂起goroutine，并向M发送信号，M收到信号后，会让当前goroutine陷入休眠继续执行其他的goroutine。

## ticker 性能提升

+ 提升Go计时器性能的关键是消除唤醒一个 timer 时进行 M/P 频繁切换的开销

+ Go1.14 直接在每个P上维护自己的timer堆，像维护自己的一个本地队列runq一样。

## 允许嵌入有相同方法集的接口

## 添加了新包hash/maphash

## 移除了 SSLv3

## go test t.Log 不再在结束时输出


# Go1.17

