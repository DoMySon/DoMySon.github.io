---
title: unsafe包
date: 2019-08-25
categories: ["go"]
description: 
toc: true
draft: false
---

> Golang 默认指针是类型安全的，但它有很多限制。Golang 还有非类型安全的指针，这就是 unsafe 包提供的 unsafe.Pointer。在某些情况下，它会使代码更高效，当然，也更危险。unsafe 包用于 Go 编译器，在编译阶段使用。从名字就可以看出来，它是不安全的，官方并不建议使用。Go 语言类型系统是为了安全和效率设计的，有时，安全会导致效率低下。unsafe 包绕过了 Go 的类型系统，达到直接操作内存的目的，使用它有一定的风险性。但是在某些场景下，使用 unsafe 包提供的函数会提升代码的效率，Go 源码中也是大量使用 unsafe 包。

<!--more-->

# `unsafe` 包

```go
//定义
type ArbitraryType int

type Pointer *ArbitraryType 

//函数
func Sizeof(x AribitraryType) uintptr{}

func Offsetof(x AribitraryType) uintptr{}

func Alignof(x AribitraryType) uintptr{}
```

# 分析

+ `Pointer` : 指向任意类型，类似于 C 中的 `void*`。

+ `Sizeof` : 返回所传类型的大小，指针只返回指针的本身（`x64 8byte x86 4byte`），而不会返回所指向的内存大小。

+ `Offsetof` : 返回 `struct` 成员在内存中的位置，相对于此结构体的头位置，所传参数必须是结构体成员。传入指针，或者结构体本身，会 `error`

+ `Alignof` : 返回 M，M 是内存对齐时的倍数。

+ 任意指针都可以和 `unsafe.Pointer` 相互转换。

+ `uintptr` 可以和 `unsafe.Pointer` 相互转换。

> 综上，`unsafe.Pointer` 是不能进行指针运算的，只能先转为 `uintptr` 计算完再转回 `unsafe.Pointer` ,还有一点要注意的是，
`uintptr` 并没有指针的语义，意思就是 `uintptr` 所指向的对象会被 gc。而 `unsafe.Pointer` 有指针语义，可以保护它所指向的对象在“有用”的时候不会被垃圾回收。

# 注意

+ `uintptr`：只代表了一个地址的值，其本身是一个整形变量，那么意味着其表示地址的内存可能会被GC。

+ `unsafe.Poniter`：本身指向一个确定内存的地址，相当于其它类型指针的一个抽象，那么其指向的内存将不会被GC。

# 应用
 

## 获取 `slice` 的长度和容量

```go
//runtime/slice.go
type slice struct{
    array unsafe.Pointer
    len int
    cap int
}

//而make时创造一个 slice 的结构体
func makeslice(et *_type,len,cap int) slice

//那么
s := make([]int,10,20)

//这一步网上教程有一个错误：直接加上8的偏移，这在x64机器上这个偏移将会是4
l := *(*int(unsafe.Pointer((uintptr(unsafe.Pointer(&s))+unsafe.Alignof(s)))))

c := *(*int(unsafe.Pointer((uintptr(unsafe.Pointer(&s))+unsafe.Alignof(s)*2))))
```

## `string` 和 `slice` 的转换

```go
//高性能的做法是 zero-copy，那么共享底层 []byte 即可

//reflect/value.go
type StringHeader struct {
    Data uintptr
    Len int
}

type SliceHeader struct {
    Data uintptr
    Len int
    Cap int
}

//所以
func String2Bytes(s string) []byte {
	strH := (*reflect.StringHeader)(unsafe.Pointer(&s))
	bh := reflect.SliceHeader{
		Data: strH.Data,
		Len:  strH.Len,
		Cap:  strH.Len,
	}
	return *(*[]byte)(unsafe.Pointer(&bh))
}

func Bytes2String(b []byte) string {
	byteH := (*reflect.SliceHeader)(unsafe.Pointer(&b))
	sh := reflect.StringHeader{
		Data: byteH.Data,
		Len:  byteH.Len,
	}
	return *(*string)(unsafe.Pointer(&sh))
}
```

## Cgo

[Cgo](/post/Cgo)

> 还没写