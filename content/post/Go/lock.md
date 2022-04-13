---
title: golang内置锁
date: 2019-12-11
tags: ["go"]
categories: ["源码分析"]
description: Go Mutex
toc: true
draft: false
---

# sync.Mutex

1. mutex相关的所有事情都是通过sync.Mutex类型的两个方法sync.Lock()和sync.Unlock()函数来完成的，前者用于获取sync.Mutex锁，后者用于释放sync.Mutex锁。sync.Mutex一旦被锁住，其它的Lock()操作就无法再获取它的锁，只有通过Unlock()释放锁之后才能通过Lock()继续获取锁。

2. 不区分读写锁，只有Lock()与Lock()之间才会导致阻塞的情况

3. 不与 `Goroutine` 关联

> 在Lock()和Unlock()之间的代码段称为资源的临界区(critical section)，在这一区间内的代码是严格被Lock()保护的，是线程安全的，任何一个时间点都只能有一个goroutine执行这段区间的代码。由于内核调度的不确定性，所以谁获取锁也是不确定的


# sync.RWMutex

1. `RWMutex` 基于 `Mutex`,并增加了读、写信号量，增加了获取读锁的计数

2. 读锁和读锁兼容，写锁和读锁互斥，写锁和写锁互斥
    
    + 可以同时申请多个读锁

    + 读锁存在，则写锁阻塞，反之亦然

    + 写锁存在，写锁和读锁都阻塞，同一时间仅一个能写

3. 不与 `Goroutine` 关联

## 源码

```go
//RwMutex source code
type RWMutex struct{
    w   Mutex
    writerSem   uint32
    readerSem   uint32
    readerCount int32
    readerWait  int32
}

//example
var rw sync.RWMutex

func Something(){
    // Lock() UnLock()   获取和释放写锁
    // RLock() RUnlock() 获取和释放读锁
}
```


# sync.Cond 条件锁

`sync.Cond` 实现了一个条件变量，在 `Locker` 的基础上增加了一个消息通知的功能，其内部维护了一个等待队列，队列中存放的是所有等待在这个 `sync.Cond` 的 `goroutine`，即保存了一个通知列表。可以用来唤醒一个或所有因等待条件变量而阻塞的 `goroutine`，以此来实现多个 Go 程间的同步。


## 源码

```go
type Cond struct {
	noCopy noCopy
	L Locker            // 基于原生的锁
	notify  notifyList  //通知列表
	checker copyChecker
}

// 基于一个锁来创建，可以是 RWMutex 或 Mutexs
func NewCond(l Locker) *Cond {
	return &Cond{L: l}
}

// 挂起 goroutine 直到调用 Broadcast和Signal
func (c *Cond) Wait() {
	c.checker.check()
	t := runtime_notifyListAdd(&c.notify) //汇编实现
	c.L.Unlock()
	runtime_notifyListWait(&c.notify, t)
	c.L.Lock()
}

// 随即唤醒一个此等待的 goroutine
func (c *Cond) Signal() {
	c.checker.check()
	runtime_notifyListNotifyOne(&c.notify)
}

// 唤醒所有因此等待的goroutine
func (c *Cond) Broadcast() {
	c.checker.check()
	runtime_notifyListNotifyAll(&c.notify)
}
```

## Example

```go
var(
    cond = sync.NewCond(&RWMutex{})
)


for i:=0;i<1000;i++{
    go func(){
        for{
            cond.Wait()
            //Some Code
        }
    }
}
//if the goroutine be in Wait
cond.Signal()       //any goroutine execute
cond.Broadcast()    //all goroutine execute

//or use raw lock
cond.L.Lock()
cond.L.Unlock()
```

# sync.Once

> 基于 `Mutex`，和一个标志量

## 作用

保证 `sync.Once(func())` 只会执行一次，实现原理执行完毕之后对这个标志量进行原子相加。