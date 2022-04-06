---
title: pointer
date: 2020-05-02
tags: ["pointer"]
categories: ["C"]
description: xLua为Unity、 .Net、 Mono等C#环境增加Lua脚本编程的能力，借助xLua，这些Lua代码可以方便的和C#相互调用。
img: http://www.lua.org/images/lua.gif
toc: true
draft: false
---

<!--more-->
# Pointer

> 定义一个指针 `type *name;`，但 `type* name;` 也无错误，仅仅是风格问题

## 使用指针

```c
{
    int var = 20;   
    int *p;         //声明int类型指针
    ip = &var;      //获取var的地址
}
```

## NULL 指针

```c
#include <stdio.h>
int main(){
    int *ptr = NULL;
    printf("ptr addr %p\n",ptr);
    if(ptr){
        // ptr is NULL?
    }
    return 0;
}
//将输出 ptr addr 0x0
```

## 指针运算

> 指针在32位cpu上是一个32位的int，而64上是一个64的int，每递增一次或递减一次将指向下一个或上一个元素的存储单元

```c
#include <stdio.h>
int main(){
    int var[] = {10,100,200};
    int i,*ptr;
    ptr = var; //指向数组第一个元素
    for(i=0;i<3;i++){
        printf("val %d\n",*ptr);
        ptr++; //移动至下一个数组的位置，如果这个数组的元素不都为int的长度，那么数值未知
    }
}
```

## 指针数组

```c
#include <stdio.h>
int main(){
    int i,*ptr[3]; //声明一个包含3个 int* 指针的数组
    int var[] = {10,100,100};
    //赋值
    for(i=0;i<3;i++){
        ptr[i] = &var[i];
    }

    const char *names[] ={
        "ABC",
        "BCD",
        "CDE",
        "DEF",
    };
```

## 指向指针的指针

> 声明一个指向指针的指针 `type **var;`


向指针的指针是一种多级间接寻址的形式，或者说是一个指针链。通常，一个指针包含一个变量的地址。当我们定义一个指向指针的指针时，第一个指针包含了第二个指针的地址，第二个指针指向包含实际值的位置。

```c
#include <stdio.h>
int main(){
    int var,*ptr,**pptr;
    var = 1000;
    ptr = &var;
    pptr = &ptr;
    printf("value is %d,%d,%d\n",var,*ptr,**pptr);
}
```


## 传递指针

```c
#include <stdio.h>
#include <time.h>
int main(){
    unsigned long sec;
    Second(&sec);
    printf("number is %d\n",sec);
    return 0;
}

//传递指针原始数值会被修改
void Second(unsigned long *ptr){
    *ptr = time(NULL);
    return;
}
```

## 函数返回指针

```c
#include <stdio.h>
#include <time.h>
#include <stdlib.h> 
int *random(){
    /*
        C 不支持在调用函数时返回局部变量的地址，除非定义局部变量为 static 变量。

        或者通过 calloc 或 malloc 来分配内存来返回
    */
    static int r[10];
    int i;
    srand((unsigned)time(NULL));
    for(i=0;i<10;++i){
        r[i] = rand();
    }
    return r;
}
```

## 函数指针

> 函数指针是指向函数的指针变量

> `typedef int(*func_ptr)(int,int);`

```c
int max(int x,int y){
    return x>y?x:y;
}

int main(){
    int (*p)(int,int) = &max;
    int d;
    //等价于：d = max(10,20); 
    d = p(10,20);
    return 0;
}
```

## 回调函数

> 函数指针作为某个函数的参数

```c
#include <stdlib.h>  
#include <stdio.h>

void callback(int *array,size_t arraySize,int (*getValue)(void)){
    for(size_t i=0;i<arraySize;i++){
        array[i] = getValue();
    }
}

int randomValue(void){
    return rand();
}

int main(void){
    int arr[10];
    callback(arr,10,randomValue);
    for(int i = 0; i < 10; i++) {
        printf("%d ", arr[i]);
    }
    return 0
}
```

# 枚举

> enum name{elem1,elem2,...};

```c
enum DAY{
    //这个类似Csharp,默认从0开始
    MON=1, TUE, WED, THU, FRI, SAT, SUN
};

enum DAY day1,day2;

int a;
a = int(day1.Mon);
```

# 结构体

```c
struct People{
    char *name;
    age  int;
} p1,p2; //可以不需要

//也可以直接设置初始值

struct People{
    char *name;
    age  int;
} p1 = {"Treasure",10};

{
    People p1,*p2;
    // 对于普通struct的访问
    p1.name; p1.age;
    // 对于指针struct的访问
    p2->name; p2->age;
}

```

> 这里有一个注意点，struct的成员如果嵌入其他struct类型必须在最后面。


# 预处理器

指令|描述
:-:|:-:
#define|定义宏
#include|包含一个源代码文件
#undef|取消已定义的宏
#ifdef|如果宏已经定义，则返回真
#ifndef|如果宏没有定义，则返回真
#if|如果给定条件为真，则编译下面代码
#else|#if 的替代方案
#elif|如果前面的 #if 给定条件不为真，当前条件为真，则编译下面代码
#endif|结束一个 #if……#else 条件编译块
#error|当遇到标准错误时，输出错误消息
#pragma|使用标准化方法，向编译器发布特殊的命令到编译器中

## 预定义宏

宏|描述
__DATE__|当前日期，一个以 "MMM DD YYYY" 格式表示的字符常量。
__TIME__|当前时间，一个以 "HH:MM:SS" 格式表示的字符常量。
__FILE__|这会包含当前文件名，一个字符串常量。
__LINE__|这会包含当前行号，一个十进制常量。
__STDC__|当编译器以 ANSI 标准编译时，则定义为 1。

示例
```c
#include <stdio.h>

void mian(){
    printf("File :%s\n", __FILE__ );
    printf("Date :%s\n", __DATE__ );
    printf("Time :%s\n", __TIME__ );
    printf("Line :%d\n", __LINE__ );
    printf("ANSI :%d\n", __STDC__ );
}
```

## 预处理器运算符

```c
#define message(a,b) \
    printf(#a " ---- " #b ":define message function")
/*
    宏延续运算符 \ 但是如果宏太长，一个单行容纳不下，则使用宏延续运算符（\）

    字符串常量化运算符（#） 在宏定义中，当需要把一个宏的参数转换为字符串常量时，则使用字符串常量化运算符（#）。

    标记粘贴运算符（##），宏定义内的标记粘贴运算符（##）会合并两个参数。它允许在宏定义中两个独立的标记被合并为一个标记。
*/

#include <stdio.h>

#define tokenpaster(n) printf ("token" #n " = %d", token##n)

int main(void)
{
   int token34 = 40;
   tokenpaster(34);
   return 0;
}
//output: token34 = 40
```

## 参数化宏

```c
int square(int x){
    return x*x;
}
//类似于
#define square(x) ((x)*(x))
```


# 储存类

+ auto：局部变量的默认存储类, 限定变量只能在函数内部使用；

+ register：代表了寄存器变量，不在内存（RAM）中使用；

+ static：全局变量的默认存储类,表示变量在程序生命周期内可见；

+ extern：表示全局变量，即对程序内所有文件可见，类似于Csharp中的public关键字


# 关于C inline static extern

1. 普通函数：定义和声明默认情况下是extern

2. 静态函数：默认是不导出的，以便于其他文件中定义不会冲突，可以认为是私有的，
静态函数会被自动分配在一个一直使用的存储区，直到退出应用程序实例，避免了调用函数时压栈出栈，速度快很多。

3. extern：显式导出函数，但不能和static混用

4. inline：告知编译器进行内联优化，减少汇编代码
5. 调用约定
   [doc](https://blog.csdn.net/a3192048/article/details/82084374)
 '顾名思义就是对函数调用的一个约束和规定(规范)，描述了函数参数是怎么传递和由谁清除堆栈的。它决定以下内容：(1)函数参数的压栈顺序，(2)由调用者还是被调用者把参数弹出栈，(3)以及产生函数修饰名的方法。'
    1. __stdcall:stdcall是由微软创建的调用约定，是Windows API的标准调用约定。非微软的编译器并不总是支持该调用协议。GCC编译器如下使用
    2. __cdecl