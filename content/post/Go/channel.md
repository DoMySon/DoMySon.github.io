---
title: channel
date: 2020-01-20
tags: []
categories: ["go"]
description: 
toc: true
draft: false
---

>`CSP(communicating sequential processes)` 模型由并发执行实体(进程，线程或协程)，和消息通道组成，实体之间通过消息通道发送消息进行通信。和 `Actor` 模型不同，`CSP` 模型关注的是消息发送的载体，即通道，而不是发送消息的执行实体。Go 语言的并发模型参考了 CSP 理论，其中执行实体对应的是 `goroutine，` 消息通道对应的就是 `channel`。`CSP` 模型的核心是：不通过共享内存来达到通讯，而是通过通讯来共享内存。


> `channel` 提供了一种通信机制，通过它，一个 `goroutine` 可以与另一 `goroutine` 发送消息。`channel` 本身还需关联了一个类型，也就是可以发送数据的类型。可以通过 `len()` 获取通道当前缓冲数量。 `cap()` 获取通道最大缓冲。

<!--more-->


`channel` 用于在不同的 `goroutine` 中实现数据传递和共享，是一个FIFO的队列，同样也是一个线程安全的结构。

1. 只读：不可写，`make(<-chan struct{},n)`。

2. 只写：不可读，`make(chan <- struct{},n)`。

3. 双通道：可读可写，`make(chan struct{},n)`。

4. 无缓冲：如果有数据，则读写阻塞，如果无数据，则在写入之前，读阻塞。`make(chan struct{})`。




# How to use

1. 如果 `channel` 未关闭，在读取超时会引发 `deadlock` 异常。

2. 如果 `channel` 关闭进行写入则会 `panic`。

3. 如果 `channel` 无数据则会读取到这个值的零值。

4. 使用 `range` 读取，如果管道未关闭触发 `deadlock`。

5. 未初始化的 `channel` 读会一直阻塞

>对于未关闭的 `channel` 也不会 `deadlocks`，每个 `case` 都有机会执行，并且不会在关闭的 `channel` 等待。



5. 创建
    > 只能通过 `make` 创建，缓冲只对于数据未填满写，未空读，如果缓冲满了，那么些写入将阻塞，若过缓冲空了，那么读取将阻塞
    ```go
    //无缓冲，数据类型为int的channel
    ch0 := make(chan int)

    //缓冲，数据类型为int的channel,只要容量大于0即可
    ch1 := make(chan int,1)
    ```

6. 读取写数据
    ```go
    ch := make(chan int,10)

    //通过迭代读取
    for x := range ch{
        //如果channel关闭，那么直接退出循环不出异常，所以 for-range可以检查channel的状态
    }

    /*
        读取，如果通道关闭则返回channel类型的0值
        如果ch没有数据则阻塞
    */
    x := <- ch

    /*
        如果ok为false，代表ch关闭
    */
    y,ok := <- ch
    ```

7. `close(channel)`

    + 关闭一个未初始化(nil) 的 channel 会产生 panic

    + 重复关闭同一个 channel 会产生 panic

    + 向一个已关闭的 channel 中发送消息会产生 panic

    + 从已关闭的 channel 读取消息不会产生 panic，且能读出 channel 中还未被读取的消息，若消息均已读出，则会读到类型的零值。从一个已关闭的 channel 中读取消息`永远不会阻塞`，并且会返回一个为 false 的 `val,ok`，可以用它来判断 channel 是否关闭。

    + 关闭 channel 会产生一个广播机制，所有向 channel 读取消息的 goroutine 都会收到消息。

    + 对于统一关闭的 `Goroutine` 建议使用同一个 `channel` 控制，上述原理。


8. `select-case`
    ```go
    //select用于监听 channel 的触发
    select{
        case <- ch1:
        //TODO
        case <- ch2:
        //TODO
        case ch1 <- 10:
        //TODO
        default:
        //TODO
    }
    ```

    + `select` 不会在 `nil` 上等待。

    + `select` 可以同时监听多个 `channel` 的写入或读取。

    + 执行 `select` 时，若只有一个 `case` 通过(不阻塞)，则执行这个 `case` 块。

    + 若有多个 `case` 通过，则随机挑选一个 `case` 执行。

    + 若所有 `case` 均阻塞，且定义了 `default` 模块，则执行 `default` 模块。若未定义 `default` 模块，则 `select` 语句阻塞，直到有 `case` 被唤醒。

    + 使用 `break` 会跳出 `select` 块。

    + `select` 阻塞会触发 `goroutine` 调度。


5. 单向的`channel`
    ```go
    //只写channel 无任何实际意义
    ch0 := make(chan <- int)

    //只读channel 只能做一个初始化的容器 无任何实际意义
    ch1 := make(<- chan int)
    ```

# 其它 
   `Mutex` 和 `channel` 本质都是处理并发竞争问题，但是对于给予特定 `Goroutine` 的数据，`channel` 可能更加适合，而对于同一时间任何`Goroutine`都能访问的数据，`Mutex`更好,而且`Mutex`比`channel`更轻量。
    

