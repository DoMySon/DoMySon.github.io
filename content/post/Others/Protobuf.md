---
title: Protobuf3
date: 2019-05-13
tags: [""]
categories: ["Protobuf3"]
description:  一种数据交换格式
img: https://www.runoob.com/wp-content/uploads/2015/06/go128.png
toc: true
draft: false
---

# 简介

`Protocol Buffers`，是Google公司开发的一种数据描述语言，类似于XML能够将结构化数据序列化，可用于数据存储、通信协议等方面。本文只介绍 `syntax = proto3` 的协议语法。


# 标准类型对照


|.proto|注释|C++|Python|Go|C#|
|:-:|:-:|:-:|:-:|:-:|:-:|
|double|定长编码|double|float|float64|double
|float|定长编码|float|float|float32|float
|int32|变长编码,负数编码效率低，可使用`sint32`|int32|int|int32|int
|int64|变长编码,负数编码效率低，可使用`sint64`|int64|int/long|int64|long
|uint32|变长编码|uint32|int/long|uint32|uint
|uint64|变长编码|uint64|int/long|unit64|ulong
|sint32|变长编码，对负数编码比`int32`更有效率|int32|int|int32|int
|sint64|变长编码，对负数编码比`int64`更有效率|int64|int/long|int64|long
|fixed32|总是`4`字节，如果值大于`2^28`比`uint32`更有效率|uint32|int/long|uint64|ulong
|fixed64|总是`8`字节，如果值大于`2^56`比`uint64`更有效率|uint64|int/long|uint64|ulong
|bool|1或0的变长编码|bool|boolean|bool|bool
|string|必须是`UTF-8`编码|string|str/unicode|string|string
|bytes|可包含任意的字节顺序|string|str|[]byte|ByteString

<!--more-->

# 定义消息类型

## Example

```protobuf
synatx = "proto3";
package Pb;

message Request{
    string  xxx = 1;
    int64   yyy = 2;
    float   zzz = 3;
    double  ppp = 4;
}
```

+ 第一行指定使用 `proto3` 语法，如果不指明，则默认使用 `proto2` 语法，这一行 `不允许空白字符和注释`

+ 第二行指明隶属于哪个包，在 `go` 中即为包名，在 `csharp` 中为命名空间

+ 使用 `//` 来注释

<!--more-->

## 指定标签

每一个字段都定义了一个唯一的 `数值标签`，这些唯一的数值标签用来标识 二进制消息 中你所定义的字段，一旦定义了编译后就无法修改。需要特别提醒的是标签 `1–15` 标识的字段编码仅占用 1 个字节（包括字段类型和标识标签）。 数值标签 `16–2047` 标识的字段编码占用 2 个字节。因此，你应该将标签 1–15 留给那些在你的消息类型中使用频率高的字段。记得预留一些空间（标签 1–15）给将来可能添加的高频率字段。

## 字段规则

+ 单数：该字段可以出现0或1次

+ 可重复 `repeated`：改字段可以重复任意次数，可以通过 `[packed=true]` 来申明更高效的编码：`repeated int32 samples = 1 [packed=true];`

## 消息嵌套

在一个消息结构内部定义另外一个消息结构

```protobuf
message Response{
    //消息嵌套，可以无限嵌套
    message Result{
        string url  = 1; //Field标签必须从1开始
        string title =2;
        repeated string snippets = 3;
    }
    repeated Result results = 1;
}

message OtherResponse{
    //外部使用内嵌消息
    Response.Result result =1;
}
```

## 保留字段

> 略

## 默认值

+ `string`默认值为空字符串。

+ `bytes`型默认值是空字节。

+ `bool`型默认值为 false。

+ 数值类型默认值位 0。

+ `enum`默认值是第一个枚举元素，它必须为 0。

+ `message`类型字段默认值为 null。

> 默认值字段是不会被序列化。

## 枚举

```protobuf
message Request{
    string url = 1;
    int number = 2;

    enum Corpus{
        None = 0; //枚举标签第一个必须为0
        Image=1;
        Viedo=2;
    }

    Corpus corpus = 4;
}
```


# 导入其它 `Protobuf`

```protobuf
import "proj/other.proto" //导入其他proto文件

import public "other.proto" //如果声明为public，那么other.proto导入的其他包也可以被引用
```

# Map

```protobuf
map<key,val> mapping = 1; //不能使用 repeated 修饰

//等效于

message Entry{
    key_type key = 1;
    val_type val = 2;
}
repeated Entry entry = 1;
```

> `key` 只能是除 `bytes` & `float、float64` 以外的任意类型。`key & val` 也可以是自定义类型.


# `RPC` 服务接口类型

```protobuf
syntax="proto3";

message SearchRequest{

}

message SearchResponse{

}

service SearchService {
    //rpc接口函数是Search
    //参数是SearchRequest，返回SearchResponse 
    Search (SearchRequest) returns (SearchResponse);
}
```