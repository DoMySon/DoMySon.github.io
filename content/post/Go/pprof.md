---
title: Go性能分析
date: 2019-08-23
tags: ["pprof"]
categories: ["go"]
description: Go单元测试&基准测试
img: https://www.runoob.com/wp-content/uploads/2015/06/go128.png
toc: true
draft: false
---

> 单元测试（unit testing），是指对软件中的最小可测试单元进行检查和验证。对于单元测试中单元的含义，一般要根据实际情况去判定其具体含义，如 C语言中单元指一个函数,单元就是人为规定的最小的被测功能模块。单元测试是在软件开发过程中要进行的最低级别的测试活动，软件的独立单元将在与程序的其他部分相隔离的情况下进行测试。

<!--more-->

## `go test` 命令

参数|描述
:-:|:-:
 `-v` |输出细节信息。
 `-run regexp` |运行满足正则匹配的函数。
 `-count=n` |运行多少次，默认一次。
 `-cover` |开启覆盖率测试。

# 测试规范

+ 测试脚本必须以 `*_test.go` 来命名，并且不会被编译到执行文件中


# `T` 测试

>又称 `单元测试`，测试函数以 `TestXXX(t *testing.T)` 表示，仅接受一个 `*testing.T` 类型参数

```go
func Test_Sum(t *testing.T){
    a := ""
	for i := 0; i < 100000; i++ {
		a += "a"
	}
}
/*
Output:
=== RUN   Test_Sum
--- PASS: Test_Sum (0.75s) 表示测试结果和时间
*/
```

## `T` 方法

参数|描述
:-:|:-:
 `Fail` |标记失败，但继续执行
 `FailNow` |失败并立即中止当前函数测试
 `Log` |输出信息
 `Error` |相当于 `Fail + Log`
 `Fatal` |相当于 `FailNow + Log`
 `Skip` |跳过当前测试函数，用于多个测试同时进行
 `SetBytes`|开启字节数处理
 `ReportAllocs`|报告内存分配状况，对应命令行参数 -benchmem


# `B` 测试

> 又称 `基准测试`，基准测试函数以 `BenchmarkXXX(b *testing.B)` 表示，仅接受一个 `*testing.B` 参数类型。
若要使用 `go test` 执行 `Benchmark`，必须使用 `-bench=functionName` 指定性能测试函数，或者 `.` 测试所有 `Benchmark*` 函数，也可以再添加测试脚本名，指定测试改脚本内的所有 `*` 函数。

```go
func BenchmarkJoin(b *testing.B) {
	a := ""
	for i := 0; i < b.N; i++ {
		a += "a"
	}
}
/*
Output:
goos                :测试系统
goarch              :系统架构
pkg                 :测试包名
Benchmark_main-4    :测试函数使用几个cpu核心
5000000             :总执行次数
1530 ns/op          :执行一次耗时 1530ns
1104 B/op           :每次执行分配 1104字节
7 allocs/op         :每次执行申请了 7 次内存
*/
```

## `benchmark` 命令参数 

参数|描述
:-:|:-:
 `-bench=func` |指定测试函数名
 `-benchmem` |是否输出内存测试信息
 `-cpu=4` |指定使用多少CPU逻辑核心测试
 `-benchtime=3s` |指定测试时长
 `-timeout=5s` |测试超时时间
 `-memprofile memp.out` |输出内存分析文件
 `-cpuprofile cpup.out` |输出cpu分析文件
 `-memprofilerate=N` |调整采样率，1/N
 `-blockprofile block.out` |输出阻塞性能分析文件
 `-count n` |运行多少次测试，默认1次
 `-v` |显示测试的详细信息


> `go test` 运行测试文件时，会提示找不到该定义，只需要在执行 `*_test.go` 脚本时，后面加上所引用的库文件即可

# 性能分析

## pprof

> Go语言自带强大的性能测试工具pprof。

### 关注的模块

+ CPU profile：报告程序的 CPU 使用情况，按照一定频率去采集应用程序在 CPU 和寄存器上面的数据

+ Memory Profile（Heap Profile）：报告程序的内存使用情况

+ Block Profiling：报告 goroutines 不在运行状态的情况，可以用来分析和查找死锁等性能瓶颈

+ Goroutine Profiling：报告 goroutines 的使用情况，有哪些 goroutine，它们的调用关系是怎样的


### 如何使用

pprof开启后，每隔一段时间（10ms）就会收集下当前的堆栈信息，获取格格函数占用的CPU以及内存资源；最后通过对这些采样数据进行分析，形成一个性能分析报告。

> 注意，只应该在性能测试的时候才在代码中引入pprof。


`pprof` 涉及两个包

+ `net/http/pprof`：主要是通过 Http 的方式将信息实时显示，如果服务器长久运行，推荐这种方式。

	```go
	import _ "net/http/pprof"
	//如果使用默认的 http.DefaultServeMux
	http.ListenAndServe("0.0.0.0:8000", nil)

	//如果自定义Mux
	r.HandleFunc("/debug/pprof",pprof.Index)
	r.HandleFunc("/debug/pprof/cmdline",pprof.Cmdline)
	r.HandleFunc("/debug/pprof/profile",pprof.Profile)
	r.HandleFunc("/debug/pprof/symbol",pprof.Symbol)
	r.HandleFunc("/debug/pprof/trace",pprof.Trace)

	```

+ `runtime/pprof`：

	1. 通过 `pprof.StartCPUProfile(w io.Writer)` 开启Cpu分析，`pprof.StopCPUProfile()` 停止Cpu分析。

	2. 通过 `pprof.WriteHeapProfile(w io.Writer)` 记录堆信息。

	3. 得到 `dump` 文件后，使用 `go tool pprof` 来进行分析。

	4. `go tool pprof` 默认使用 `-inuse-space` 进行统计，还可以使用 `-inuse-objects` 查看对象分配数量。


### `go tool pprof -h`

>命令格式：`go tool pprof <format> [options] [binary] <source> ...`

+ format 默认不填的话将打开shell交互命令

+ binary 可选cpu或者memory分析文件

+ go tool pprof -http=:9999 binary 直接网页浏览


### `go tool trace`

> 命令格式：`go tool trace [flags] trace.out`


在代码中如何直接生成
```go
import "runtime/trace"

func f(){
	trace.Start(os.Stdout)
	//do something
	trace.Stop()
}

// go run xxx.go > trace.out
// go tool trace -http=:7777 trace.out 查看

// go test -trace xxx.go 也可以生成 trace.out 文件
```

+ 支持分析 `network blocking`,`sync`,`syscall`,`sche`

+ -http=:6060 直接在网页上分析

### 火焰图

1. 下载 `graphviz`

[windows](https://graphviz.gitlab.io/_pages/Download/Download_windows.html)

macOS：`brew install graphviz`

centos：`yum install -y graphviz`


2. 名词解释

```
Type: cpu    									分析类型为cpu
Time: Apr 14, 2020 at 4:20pm (CST)				分析开始时间
Duration: 30s, Total samples = 140ms ( 0.47%)	采样时间30s，采样间隔140ms
Entering interactive mode (type "help" for commands, "o" for options)
(pprof) top10									分析前10的耗时
Showing nodes accounting for 140ms, 100% of 140ms total		显示出来的函数占用了140ms，占总时间的100%
Dropped 67 nodes (cum <= 0.03s)					总计耗时小于0.03s的67个函数丢弃不显示
Showing top 10 nodes out of 47					总共47个函数，只显示了前10个
      flat  flat%   sum%        cum   cum%
      50ms 35.71% 35.71%       50ms 35.71%  runtime.stdcall1
      20ms 14.29% 50.00%       50ms 35.71%  runtime.timerproc
      10ms  7.14% 57.14%       10ms  7.14%  runtime.casgstatus
      10ms  7.14% 64.29%       10ms  7.14%  runtime.cgocall
      10ms  7.14% 71.43%       20ms 14.29%  runtime.chansend
      10ms  7.14% 78.57%       10ms  7.14%  runtime.mget
      10ms  7.14% 85.71%       10ms  7.14%  runtime.osyield
      10ms  7.14% 92.86%       10ms  7.14%  runtime.stdcall2
      10ms  7.14%   100%       10ms  7.14%  sync.(*entry).load
         0     0%   100%       10ms  7.14%  encoding/json.(*encodeState).marshal

sum% 	= 上一行的flat%+本行的flat%,
flat% 	= 自身执行时长和total时长的比例 50ms/140ms=0.3571
cum% 	= 自身代码+所有调用的函数的执行时长和total时长的比例
```

## expvar


