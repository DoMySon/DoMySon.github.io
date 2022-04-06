---
title: C#不安全代码
date: 2019-08-31
tags: ["Pointer"]
categories: ["CSharp"]
description: 不安全指针
img: /images/1.png
toc: true
draft: false
---

# 关键字

## `volatile`

> 用于多线程变量

```csharp
int i1;

//作用于多线程变量
//但不能作用于局部变量
volatile int i2;

/*
多个线程同时访问一个变量，CLR为了效率，允许每个线程进行本地缓存，这就导致了变量的不一致性。volatile就是为了解决这个问题，volatile修饰的变量，不允许线程进行本地缓存，每个线程的读写都是直接操作在共享内存上，这就保证了变量始终具有一致性。

编译器在优化代码时，可能会把经常用到的代码存在Cache里面，然后下一次调用就直接读取Cache而不是内存，这样就大大提高了效率。但是问题也随之而来了。

在多线程程序中，如果把一个变量放入Cache后，又有其他线程改变了变量的值，那么本线程是无法知道这个变化的。它可能会直接读Cache里的数据。但是很不幸，Cache里的数据已经过期了，读出来的是不合时宜的脏数据。这时就会出现bug。

用Volatile声明变量可以解决这个问题。用Volatile声明的变量就相当于告诉编译器，我不要把这个变量写Cache，因为这个变量是可能发生改变的。
*/
```
<!--more-->
## `stackalloc`

> `stackalloc` 运算符在堆栈上分配内存块，但必须是一个值类型。堆栈分配的内存块不受垃圾收集而不必 `fixed`。（默认是分配在托管堆上）

```csharp
int* ptr = stackalloc int[100];
/*
    在 stack 上分配 100个大小为int的内存，内存地址被保存在 ptr 上，此内存不受立即回收的制约，生存周期仅限定于该内存块所在方法的生存周期。需要存在于 unsafe 的上下文中
*/
```

## `unsafe`

> `unsafe` 用以声明不安全的上下文，`unsafe`只能用来修饰块，类和方法

```csharp
unsafe{
    int[] arr = new int[]{0,1,2,3,4};

    fixed(int *p = arr){
        /*
            1.fixed只能在unsafe区域出现
            2.因为C#的自动垃圾回收机制会允许已经分配的内存在运行时进行位置调整，如果那样，p可能一开始指的是array，但后来array的位置被调整到别的位置后，p指向的就不是array了。所以要加一个fixed关键字，把它定在那里一动不动，之后的操作才有保障。
        */
        //dosomething
    }
}
```


## `checked` `unchecked`

> `checked` 对整形算数运算符，和类型转换提供溢出检查，`unchecked` 取消溢出和转换检查，此时算法溢出会被忽略，结果会被截断。

```csharp
int Add(int a,int b){
    //默认是 checked
    return unchecked(a+b);
}
```


# 泛型

## 协变和逆变