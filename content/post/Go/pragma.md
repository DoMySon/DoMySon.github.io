---
title: Go 编译指示
date: 2020-04-18
tags: ["pragma"]
categories: ["go"]
description: go pragma
img: https://www.runoob.com/wp-content/uploads/2015/06/go128.png
toc: true
draft: false
---


# 编译指示

在计算机编程中，`编译指示(pragma)` 是一种语言结构，它指示编译器应该如何处理其输入。指示不是编程语言语法的一部分，因编译器而异。


# Go中的编译指示

```go
//go:pragma
func Echo(){}
```

# 指示详解

## //go:noinline

> 使函数不内联，内联是在编译期间发生的，将函数调用处替换为被调用函数主体的一种编译器优化手段。

+ 减少函数调用的开销，提高执行速度。

+ 复制后的更大函数体为其他编译优化带来可能性，如 过程间优化

+ 消除分支，并改善空间局部性和指令顺序性，同样可以提高性能。

+ 代码复制带来的空间增长。

+ 如果有大量重复代码，反而会降低缓存命中率，尤其对 CPU 缓存是致命的。


### 内联

```go
func Max(a, b int) int {
        if a > b {
                return a
        }
        return b
}

func F() {
        const a, b = 100, 20
        if Max(a, b) == b {
                panic(b)
        }
}

// `Max` 函数被内联，死码消除之后，`F()` 函数被变成了 `F(){ return }`
```

内联级别：默认常规内联，-gcflags=-l 禁用内联，`-gcflags='-l -l'` 二级内联，`-gcflags='-l -l -l'` 三级内联，`-gcflags='-l -l -l -l'` 四级内联，级数越大，也许更快，但bug更多 



## //go:nosplit

> 跳过栈溢出检测。默认一个 `goroutine` 起始栈是2K，而后根据需求动态增长。

+ 不执行栈溢出检测可以提高性能

+ 可能发生 `stack overflow`


## //go:noescape

> 禁止逃逸，且必须指示一个只有声明没有主体的函数

+ gc压力变小

+ 可能返回为空

+ 需要使用汇编实现其主体

### 逃逸分析

> 在 Go 中，如果一个值超过了函数调用的生命周期，编译器会自动将之移动到堆中.

```go
type Echo struct{}

func New() *Echo {
    return &Echo{}
}
```

而某些变量在函数周期之内调用的话，将会在栈上分配，使用完毕即释放，但这个不绝对，go会根据对象的大小来确定分配的位置。而且 `new` 函数也不一定分配在堆上。

+ 如何分析

`go build gcflags=-m main.go` 即可查看内联优化建议。

`go build gcflags=-S main.go` 查看汇编。

```go
type Echo1 struct{}

func Reverse(e *Echo1){}

func New(){
    e := new(Ec)
    Reverse(e)
    // todo
}
```

这段代码也不会逃逸，因为 `Reverse` 被内联了。


## //go:norace

> 跳过竞态检测

+ 减少编译时间

+ 增加数据竞争的风险