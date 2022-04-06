---
title: Goroutine
date: 2019-05-12
tags: ["goroutine"]
categories: ["Go"]
description: Go 并发原理
img: https://www.runoob.com/wp-content/uploads/2015/06/go128.png
toc: true
draft: false
---

# 栈

> 一个 os 线程会有一个给固定大小的内存块（一般是 2MB），用来存储当前线程中调用或挂起函数的内部变量，固定大小的栈对于复杂和深层次递归是不够的，而 Goroutine 会以一个很小的栈（2KB）开始其生命周期，这个栈会动态伸缩，最大能到达 1GB（32位系统是 250M）


# 调度方式

> os 线程由操作系统内核调用，每过一定时间（毫秒），硬件计时器会中断处理器，并调用一个名为 scheduler 的内建函数，这个函数会挂起当前执行的线程并保存内存中它的寄存器内存，然后检查线程列表并决定下一次执行哪个线程，并从内存中恢复该线程的寄存器信息，恢复该线程的线程并执行，这就是上下文切换，增加了 CPU 的运行周期。而 Go 的 runtime 包含了自身的调度器，和 os 线程不同是，`Goroutine` 属于用户级线程由语言支持，调度由语言支持，所有开销会减少很多（相比于内核上下文切换）。

<!--more-->
# Go的调度器（Scheduler）

+ g 代表一个 goroutine，它包含：表示 goroutine 栈的一些字段，指示当前 goroutine 的状态，指示当前运行到的指令地址，也就是 PC 值。

+ m 表示内核线程，包含正在运行的 goroutine 等字段。

+ p 代表一个虚拟的 Processor，它维护一个处于 Runnable 状态的 g 队列，m 需要获得 p 才能运行 g。

+ 还有一个核心的结构体：sched，它总览全局。

> Runtime 起始时会启动一些 G：垃圾回收的 G，执行调度的 G，运行用户代码的 G；并且会创建一个 M 用来开始 G 的运行。随着时间的推移，更多的 G 会被创建出来，更多的 M 也会被创建出来。

1. 它是运行在用户态的，

2. 它维护有存储M和G的队列以及调度器的一些状态信息等，并让每个 `Goroutine` 有机会运行

2. `M` 每次取 `P` 中的队列是没有上下文切换开销的 


+ M ：代表 os（内核）线程
  
  OS线程抽象，代表着真正执行计算的资源，在绑定有效的P后，进入schedule循环；而schedule循环的机制大致是从Global队列、P的Local队列以及wait队列中获取G，切换到G的执行栈上并执行G的函数，调用goexit做清理工作并回到M，如此反复。M并不保留G状态，这是G可以跨M调度的基础，M的数量是不定的，由Go Runtime调整，为了防止创建过多OS线程导致系统调度不过来，目前默认最大限制为10000个。

+ P ：代表逻辑处理器
  
   `Processor`，表示逻辑处理器， 对G来说，P相当于CPU核（伪核，真正的执行体还是M所关联的内核线程），G只有绑定到P(在P的local runq中)才能被调度。对M来说，P提供了相关的执行环境(Context)，如内存分配状态(mcache)，任务队列(G)等，P的数量决定了系统内最大可并行的G的数量（前提：物理CPU核数 >= P的数量），P的数量由用户设置的GOMAXPROCS决定，但是不论GOMAXPROCS设置为多大，P的数量最大为256。

   1. `P` 维护了一个 `local goroutines` 队列



# 何时触发调度

> 由于 Go 语言是协作式的调度，不会像线程那样，在时间片用完后，由 CPU 中断任务强行将其调度走。对于 Go 语言中运行时间过长的 goroutine，Go scheduler 有一个后台线程在持续监控，一旦发现 goroutine 运行超过 10 ms，会设置 goroutine 的 “抢占标志位”，之后调度器会处理。

1. syscall
2. select-channel
3. I/O（包括网络和文件）
4. Gosched()函数调用
5. go func(){...}()
6. GC时
7. 同步互斥操作时


# Goroutine

> Goroutine 可以看作对 thread 加的一层抽象，它更轻量级，可以单独执行。因为有了这层抽象，Gopher 不会直接面对 thread

1. 创建一个 goroutine 的栈内存消耗为 2 KB，在运行过程中，如果栈空间不够用，会自动进行扩容


2. `G` 分为三种状态
    
    1. `Waiting`：表示被暂停了，需要等待一些事件发生才能继续，可能是因为 `syscall`,`channel` 或者互斥调用。

    2. `Runnable`：就绪状态，只要给 `M` 就可以运行

    3. `Running`：运行状态。goroutine 在 M 上执行指令


3. 每个Goroutine对应一个G结构体，G存储Goroutine的运行堆栈、状态以及任务函数，可重用。G并非执行体，每个G需要绑定到P才能被调度执行。

4. 在同一时刻，一个线程上只能跑一个 goroutine。当 goroutine 发生阻塞（例如上篇文章提到的向一个 channel 发送数据，被阻塞）时，runtime 会把当前 goroutine 调度走，让其他 goroutine 有执行的机会

## 异常捕获

> 当启动多个 `goroutine` 时，如果其中一个 `goroutine` 异常了，并且我们并没有对进行异常处理，那么整个程序都会终止，所以最好每个 `goroutine` 所运行的函数都做异常处理，异常处理采用 `recover`

```go
go func(){
    defer func(){
        if err := recover();err != nil{
            //TODO
        }
    }
    //Code...
    panic("exit")
}
```

### 注意

1. recover 只能在 defer 的匿名函数中调用

2. recover 能捕获panic传入的错误，来保证 goroutine 是否继续执行还是正常退出

## 如何同步

> 某些情况是主线程退出，但一部分 `goroutine` 还未执行完毕

+ 通过 `sync.WaitGroup` 来保证所有 `goroutine` 执行完成

+ 通过 `channnel` 来保证所有 `goroutine` 执行完成



# GC

+ 因为 GC 操作是使用自己的一组 `Goroutine` 来执行的，这些 `Goroutine` 需要一个 `M` 来运行。所以 GC 会导致调度混乱。但是，因为调度器是知道 `Goroutine` 要做什么的，所以它可以做出明智的决策。其中一个明智的决策是，在 GC 过程中，暂停那些需要访问堆空间的 `Goroutine`（`Stop The World`），运行那些不需要访问堆空间的。
