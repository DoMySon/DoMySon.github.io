---
title: Node.js
date: 2019-04-22
tags: ["Nodejs"]
categories: ["Javascript"]
description: Go是一个好东西
img: https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=470008297,289328854&fm=58&bpow=1280&bpoh=720
toc: true
draft: false
---


# 异步原理

1. Node 本身是多线程，但对于用户（Js代码）的执行只会在主线程中执行

2. Node 底层封装了 `libuv` 库

3. Node 只有执行完主线程，才会进入 `EventLoop`

4. Node 基于事件驱动

5. 事件机制的底层依赖库：`libuv`、`libeio`、`libev`

    > `epoll` 用于Linux系统，`IOCP` 用于Windows系统；`epoll` 是同步非阻塞模型：当事件资源满足时发出可处理通知消息（主线程需要自己去处理）；`IOCP` 是异步非阻塞模型，当事件完成时发出通知消息（工作线程帮主线程处理完了

6. Node 主线程的 event loop 在处理所有的任务/事件时，都是沿着事件队列顺序执行的，所以在其中任何一个任务/事件本身没有完成之前，其它的回调、监听器、超时、nextTick()的函数都得不到运行的机会。

6. 如果事件是 CPU 密集型，在这个事件处理完之前，其他事件没有机会执行，如果是 I/O 密集型，基于 `异步非阻塞I/O模型`，内核会立刻返回信号，其他事件会有机会执行


<!--more-->

![Node执行流程](/images/Js/Node执行流程.png)

7. 主线将同步代码执行完毕,开始执行异步代码
    >异步分为两种
    1. 非I/O:setTimeout() setInterval()
    2. I/O:从线程池中取出一个I/O线程

8. 若事件队列清空，则进程退出

    > V8引擎解析JavaScript脚本,解析后的代码，调用Node API libuv库负责Node API的执行。它将不同的任务分配给不同的线程，形成一个Event Loop（事件循环），以异步的方式将任务的执行结果返回给V8引擎,V8引擎再将结果返回给用户
    

![Node执行流程图](/images/Js/eventloop.png)

![Node执行流程图](/images/Js/eventloop1.png)

![Node执行流程图](/images/Js/eventloop2.png)


# API文档
+ [Node v8.x文档](https://www.nodeapp.cn)

+ [Node v10.x中文文档](http://nodejs.cn/api)

+ [Node v10.x文档](https://nodejs.org/dist/latest-v10.x/docs/api/)

# EventLoop

1. 关于 `setTimeout`

    >即便主线程为空，0毫秒实际上也是达不到的。根据HTML的标准，最低是 4 毫秒，也跟硬件最小计时间隔有关,setTimeout 当主线程阻塞，或者在他之前调用的事件阻塞时，延时将不会准确

2. 执行顺序

    >主线程逻辑 > `process.nextTick` > `Promise.then` > `setInterval` > `setTimeout` > `setImmediate`   (若相同，则按调用顺序执行)

3. 宏任务

    >主js代码 ，`setTimeout`， `setInerval`， `setImmediate`

4. 微任务
    >`Promise.then` ，`process.nextTick`

    ```
    在每次轮训检查中，各观察者的优先级分别是:
    主线程逻辑 > idle观察者 > I/O观察者 > check观察者

    idle观察者：process.nextTick
    I/O观察者：一般性的I/O回调，如网络，文件，数据库I/O等
    check观察者：setTimeout>setImmediate
    ```

5. 总结

    >同步代码执行顺序优先级高于异步代码执行顺序优先级；new Promise(fn)中的fn是同步执行；Promise 只是在获取返回值的时候加入下一次循环时调用Node整体运行在 事件循环中当进行 I/O 交互时，由主线程向 libuv 发起，libuv 分配I/O线程，负责与内核交互。总体来看，Js 还是单线程，而且 libuv 库只对 I/O线程有效，对于 Cpu 密集型计算不会放入I/O 线程，还在会在主线程中计算

---
# Buffer

## [Buffer文档](https://www.nodeapp.cn/buffer.html)

## 介绍
>Buffer 作为 Node.js 的 API 而非 JavaScript 的 API,使其能应用在 socket流和文件流等处理二进制的场景。Buffer 是全局变量，所以不需要引用

---
## 初始化
```js
//Buffer.from()
let b0 = Buffer.from([1,2,3]);

let b1 = Buffer.from("123");

let b2 = Buffer.from("123","base64");
//返回与b0共享同一内存的Buffer
let b3 = Buffer.from(b0)

//Buffer.alloc()
//分配20byte，默认为0的Buffer
let b4 = Buffer.alloc(20);
//分配10byte，默认为1的Buffer
let b5 = Buffer.alloc(10,1);

//Buffer.allocUnsafe()
//返回长度为10byte，但可能包含旧数据的Buffer，需要 write，fill重写数据，比alloc性能更好
let b6 = Bufferr.allocUnsafe(10);
```

---
## Buffer的字符编码
```js
let b = Buffer.from("hello world","ascii");

b.toString("hex");

b.toString("base64");
```

---
## Node支持的字符编码
编码|描述
:-:|:-:
ascii|sds
utf8|sds
utf16le|sds
ucs2|sds
base64|sds
lantin1|sds
binary|sds
hex|sds

---
## 迭代Buffer
```js
let b = Buffer.from("hello world","ascii");

for(let bt of b){
    //返回对应的byte值
}
```
>此外，buf.values()、buf.keys()、buf.entrues() 可用于创建迭代器

---
# CommonJs

## 模块导出
>`exports` 和 `module.exports`
```js
const PI = 3.1415;

function f0(){
    //TODO
}

function f1(){
    //TODO
}

class Export{
    constructor(){

    }
}

/*
    外部需要 
    const ff = require("");
    ff();即可执行到f0这个函数
*/
module.exports = f0;

/*
    外部需要 
    const ff = require("");
    ff.f();执行到f0这个函数
*/
exports.f = f0;

```
1. 对于 `z = require();` `exports.y = x `需要 z.y.x才能调用到, `module.exports = x` 需要 z.x 就可以调用到了 

2. `module.exports = {fn:f0}` 等价于 `exports.fn = f0`

3. `export` 推荐 常量、函数和`index` 文件中使用

4. `module.exports` 导出对象 包内使用

---
## index.js文件
>作为一个包的整体索引，提供了此包所有模块的配合，以及相互引用关系，将初始化，耦合关系全部集中在此文件中，提供了隐私保护，提供了调用接口，保护了内部实现的关系，方便了后期管理和包其他文件的解耦

---
## package.json
>`npm` 的包管理文件

名称|描述|必须性
:-:|:-:|:-:
`name`|项目名称|必须
`version`|项目版本|必须
`author`|项目作者|非必需
`description`|项目描述|非必需
`main`|主程序入口文件|必须
`dependencies`|项目依赖包|必须
`scripts`|项目执行命令|必须

```json
{
    "name": "MA",
    "version": "1.0.0",
    "author": "Treasure",
    "description": "maserver for js",
    "main": "test_Service.js",
    "scripts": {
        "start": "node test_Service.js"
    },
    "dependencies": {
        "log4js": "3.0.6",
        "mysql": "2.11.1",
        "node-schedule": "1.3.0",
        "redis": "2.8.0",
        "request": "latest",
        "rxjs": "6.3.3",
        "sequelize": "3.24.1"
    }
}
```