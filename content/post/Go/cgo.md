---
title: Cgo
date: 2022-04-06
tags: ["go","c"]
categories: ["go"]
description: 
toc: true
draft: false
---


# cgo 一种go与c交互的技术

## 开启cgo
> 要求系统安装C/C++工具链，macos和linux(gcc 自带)，windows(mingw),并确保环境变量`CGO_ENAVBLE=on`,最后源码需要导入 `import "C"`


## cgo类型映射
C type|Cgo type|Go type
---|----|---
char|C.char|byte
signed char|C.schar|int8
unsigned char|C.uchar|uint8
short|C.short|int16
unsigned short|C.ushort|uint16
int|C.int|int32
unsigned int|C.uint|uint32
long|C.long|int32
unsigned long|C.ulong|uint32
long long int|C.longlong|int64
unsigned long long int|C.ulonglong|uint64
float|C.float|float32
double|C.double|double
size_t|C.size_t|uint

### 函数指针
> go引用c的函数指针比较特别
1. 官方给出的Example(https://github.com/golang/go/wiki/cgo#function-pointer-callbacks)

2. 我这里给出另外一种,通过c wrap 这个函数指针成一个普通函数，然后go调用它

```C
//example.h
typedef int (*add)(int a);

int wrap_add(add f,int a){
    if(f){
        return add(a);
    }
    return 0;
}
```


## struct、union、enum

1. go通过`C.struct_XXX` 来访问c中的结构体，若结构体是 typedef 定义的则不需要 `struct_` 前缀

2. 若c中结构体名称是go关键字，则需要加 `_`，如 _type

3. union在go中会被替换成等长byte数组

    ```go
    //example.go
    /*
    union U1{
        int a;
        long long int b;
    };
    */
    import "C"

    func Mock(){
        var u = C.union_U1; // u的type为 [8]byte
    }
```
4. 枚举在cgo中会被替换为一个常量，通过 C.Enum来访问



## 函数调用

> c call go: 通过编译指示 `go:export`来导出可供c调用的函数，但是参数及返回值都是c类型

> go call c: 通过`C.funcName`来调用，但是参数及返回值都是c类型

### 关于 `<errno.h>`

> 因为C语言不支持返回多个结果，因此<errno.h>标准库提供了一个errno宏用于返回错误状态。我们可以近似地将errno看着一个线程安全的全局变量，可以用于记录最近一次错误的状态码，
CGO也针对<errno.h>标准库的errno宏做的特殊支持：在CGO调用C函数时如果有两个返回值，那么第二个返回值将对应errno错误状态。

```C
#include <errno.h>
int div(int a, int b){  // 如果b=0,在go中将返回 (0,invalid argument)
    if(b == 0){
        erron = EINVAL;
        return 0;
    }
    return a/b;
}
```


## 编译和连接参数 (https://www.cntofu.com/book/73/ch2-cgo/ch2-11-link.md)

