---
title: 预处理器
date: 2020-07-04
tags: ["c"]
categories: ["c"]
description: 
toc: true
draft: false
---

# 预处理器

+ `#pragma` 用于指示编译器完成一些特定的动作

    1. #pragma message usermessage
         ```c
        //example:test.c
        #include <stdio.h>
        #define IOS
        #if defined IOS
            #pragma message "ready complie ios..."
        #endif
        //complie output:
            note: #pragma message: ready complie ios...
        ```

    2. #pragma once 确保头文件仅被编译一次
        ```c
        //example:test.h
        #pragma once
        int value = 10;
        //example:test.c
        #include "test.h"
        #include "test.h"
        ```

    3. #pragma pack(size_t) 指定内存对齐
        ```c
        //example:test.c
        // 2byte 对齐
        #pragma pack(2)
        struct foo{
            char c1;
            char c2:
            short 2;
            int i;
        };

        // 4byte 对齐
        #pragma pack(4)
        struct bar{
            char c1;
            shirt s;
            char c2;
            int i;
        };

        void main(){
            printf("%d\n",sizeof(struct foo)); //8
            printf("%d\n",sizeof(struct bar)); //12
        }
        ```

    4. 在不同编译器之间不可移植，在不同编译器可能以不同的方式解释，预处理器将忽略不被识别的此指令



指令|描述|示例
:-:|:-:|:-:
#define|定义宏|
#include|包含一个源代码文件
#undef|取消一个定义的宏
#ifdef|是否定义了宏
#ifndef|是否没有定义一个宏
#if|条件检测
#else|条件分支
#elif|条件分支
#endif|结束条件分支
#error|当遇到标准错误，输出错误消息
#pragma|使用标准化方法，向编译器发布特殊的命令到编译器中
#line|重置下一行行数|#line 100

<!--more-->


# Example
```c
#define unsigned int Byte

#undef SIZE
#define SIZE 42

#ifndef SIZE
    #define SIZE 20
#endif

#define MESSAGE(a,b) \
    printf(#a" and " #b":ok\n")
// #字符串常量化运算符，把参数转换为字符串常量

#define TOKEN(n) printf("token" #n " =%d", token##n)

#define SQR(x)((x)*(x))
// 宏定义内的标记粘贴运算符（##）会合并两个参数
void main(){
    MESSAGE(A,B); //output: A and B:ok
    TOKEN(34) //output:token = 40
}
```


# 预定义宏

+ `__FILE__`：当前行所在的源文件名称

+ `__LINE__`：十进制表示当前行所在源文件的行号

+ `__FUNCTION__` 或 `__func__`：当前行所属的函数名，C99支持

+ `__DATE__`：当前日期，以 `MMM DD YY` 格式表示的字符串

+ `__TIME__`：源文件编译时间，一个以 `HH:MM:SS` 格式表示的字符串

+ `__STDC__`：当编译器以 ANSI 标准编译时，则定义为 1。

+ `__STDC__HOSTED__`：为本机环境为1，否则为0，todo

+ `__STDC__VERSION__`：为C99时，输出 199901L，todo

```c
// os: mac book pro 2018
// arch: amd64
#include <stdio.h>

void main(void){
    printf("File :%s\n", __FILE__ );
    printf("Date :%s\n", __DATE__ );
    printf("Time :%s\n", __TIME__ );
    printf("Line :%d\n", __LINE__ );
    printf("ANSI :%d\n", __STDC__ );
    printf("FUNC :%s\n", __FUNCTION__ );
    printf("HOSTED :%s\n", __STDC__HOSTED__ );
    printf("VERSION :%s\n", __STDC__VERSION__ );
}

/*
    output: 
        File :/Users/chen/Desktop/github/Tinyhttpd/test.c
        Date :Jul  5 2020
        Time :01:48:42
        Line :11
        ANSI :1
        FUNC :main
*/
```

# gcc

> gcc编译一个c文件的过程，会经过几个步骤：预编译，编译，汇编，链接。

选项|描述
:-:|:-:
`-S`|编译，将`.o`文件编译成汇编文件`.s`
`-c`|汇编，生成目标文件`.o`
`-E`|预编译，将`#`指令重新展开到`.i`文件中
`-std`|使用哪个C标准,`-std=c99`
`-Wall`|产生尽可能多的警告
`-Werror`|将所有警告当成错误处理
`-pedantic`|使用了ANSI/ISO C语言扩展语法的地方将产生相应的警告信息

1. 直接编译 `gcc hello.c -o hello`

2. 仅处理预处理 `gcc -E hello.c -o hello.i`

3. 编译为汇编   `gcc -S hello.c(.i) -o hello.s`

4. 汇编 `gcc -c hello.c -o hello.o`

5. 连接 `gcc hello -o hello`

6. `-g` 编译期间输出调试信息

7. `-O0 -O1 -O2 -O3` 优化等级，-O3 最高