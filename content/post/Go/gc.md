---
title: Go GC分析
date: 2020-02-26
tags: ["GC"]
categories: ["go"]
description: go 内置命令
img: https://www.runoob.com/wp-content/uploads/2015/06/go128.png
toc: true
draft: false
---


# 如何启用GC跟踪

> GODEBUG=gctrace=1 go run *.go

其中 `gctrace=1` 表示只针对这个进程进行GC追踪


# 输出分析

```
gc 1 @0.035s 0%: 0+0.99+0 ms clock, 0+0/0/0+0 ms cpu, 4->5->1 MB, 5 MB goal, 12 P
scvg: 0 MB released
scvg: inuse: 5, idle: 2, sys: 7, released: 2, consumed: 5 (MB)
GC forced
```

<!--more-->
## GC 信息

+ `gc 1`：代表第几次执行GC，这是第一次

+ `@0.035s`：程序执行总时间。

+ `%0`：gc所占进程cpu时间的百分比。

+ `0+0.99+0 ms clock`：垃圾回收时间，分别为 STW(stop-the world)清扫时间,并发标记和扫描时间，STW标记时间。

+ `0+0/0/0+0 ms cpu`：本次gc占用时间。

+ `4->5->1 MB`：堆大小，gc后堆大小，存货堆大小。

+ `5 MB goal`：整体堆大小。

+ `12 P`：使用的逻辑核数量。

+ `GC forced`：强制使用了 `runtime.GC()` 方法。


## 系统内存回收信息

+ `inuse:5`：使用了多少M 内存。

+ `idle:2`：剩下要清除的内存。

+ `sys:7`：系统映射内存。

+ `released:2`：释放的系统内存。

+ `consumed:5`：申请的系统内存。

<!--more-->

# 如何定位

[参考Pprof](/2019/08/Go单元测试/)