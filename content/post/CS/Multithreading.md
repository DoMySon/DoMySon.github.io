---
title: C#多线程
date:  2019-05-30
tags: ["Thread","Mutex","Async","Lock"]
categories: ["CSharp"]
img:
toc: true
draft: false
description: 
---

> 进程是CPU资源分配的最小单位，线程是CPU调度的最小单位。可以理解为，打开一个应用程序时，操作系统启动一个进程，为其分配虚拟内存、文件句柄等资源，一个进程至少拥有一个线程，这些线程共享该进程的资源（内存和堆），但是每个线程都有独立的栈，以记录函数的执行位置和局部变量。CPU对线程的调度可以实现任务的并行执行，提高程序的运行效率。


> `锁` 确保同一份资源不会被多个线程同时使用

<!--more-->

# Thread类

```cs
{
    Thread t = new Thread(x=>{});
    //这一步线程真正开始
    t.Start();
    //阻塞知道此线程执行完毕
    t.Join()
}
```

# 异步委托

> 本质调用了线程池线程，所以它是一个后台线程

```cs
{
    d = delegate {/*code*/};
    IAsyncResult ret = d.BeginInvoke(x =>{
        //TODO
    });
    d.EndInvoke(ret);
    /*
        通过 IAsyncResult.IsCompleted 来判断线程的状态，EndInvoke 得到结果
    */
}
```

# 线程池

+ 线程池中所有线程都是后台线程，如果前台线程终止 则所有后台线程都会被关闭

+ 不能把入池线程改为前台线程

+ 不能给入池线程设置优先级 默认为Normal

+ 入池线程用于处理时间较短的任务，否则使用Thread创建一个线程 并设为后台线程

```cs
{
    ThreadPool.QueueUserWrokItem(x=>{});
}
```

# Task

> 对于多线程，一般常用的是 `Thread`。在 `.net 4.0` 之后有一种基于 `任务的编程模型`，因为 `Task` 具有比 `Thread` 更小的开销。


## 版本要求
+ `.net 4.0` 以上

+ [Task Api文档](https://docs.microsoft.com/zh-cn/dotnet/api/system.threading.tasks.task?view=netframework-4.7.2)

```cs
//通过构造函数创建
var task0 = new Task(()=>{});
task0.Start();

var task1 = Task.Run(()=>{});

var task2 = Task.Factory.StartNew(() =>{});

 //Created: 任务被创建，如果通过Factory创建则没有此状态
    //WaitingToRun:等待任务调度器分配线程给任务执行
    //RanToCompletion:任务执行完毕
```


## 任务控制  
1. `task.Wait`  
     等待这个task实例完成

2. `Task.WaitAll(static)`  
    等待需要定制的task完成

3. `Task.WaitAny(static)`  
    等待任意task完成

4. `Task.ContinueWith(Member)`  
    等待task完成之后继续执行其他 task

5. `Task` 取消


## Task 嵌套

+ 嵌套 

```cs
var pTask = Task.Factory.StartNew(() => 
{
    var cTask = Task.Factory.StartNew(() =>
    {
        System.Threading.Thread.Sleep(2000);
        Console.WriteLine("Childen task finished!");
    },TaskCreationOptions.AttachedToParent);//指定此task附加到父task上
    Console.WriteLine("Parent task finished!");
});
pTask.Wait();
Console.WriteLine("Flag");
Console.Read();
//Output:Parent task finished! -> Childen task finished! -> Flag
//关联嵌套父task会等待子task完成
```

+ 非关联嵌套  

```csharp
var pTask = Task.Factory.StartNew(() => 
{
    var cTask = Task.Factory.StartNew(() =>
    {
        System.Threading.Thread.Sleep(2000);
        Console.WriteLine("Childen task finished!");
    });
    Console.WriteLine("Parent task finished!");
});
pTask.Wait();
Console.WriteLine("Flag");
Console.Read();
//Output:Parent task finished!  -> Flag -> Childen task finished!
```

+ 综合实例

```cs
/*
    任务2和任务3要等待任务1完成后，取得任务1的结果，然后开始执行。任务4要等待任务2完成，取得其结果才能执行，最终任务3和任务4都完成了，合并结果，任务完成
*/
var t1 = Task.Factory.StartNew<int>(() =>
{
    return 1;
});

t1.Wait();
//第一种实现
var t4 = Task.Factory.StartNew<int>(() =>
{
    var t2 = Task.Factory.StartNew<int>(() =>
    {
        return t1.Result + 2;
    }, TaskCreationOptions.AttachedToParent);

    return t2.Result + 4;
}); 

//第二种实现
var t4 = Task.Factory.StartNew<int>(() =>
{
    return t1.Result + 2;

}).ContinueWith<int>(t => {
    return t.Result + 4;
});

var t3 = Task.Factory.StartNew<int>(() =>
{
    return t1.Result+3;
});

Task.WaitAll(t3, t4);

Console.WriteLine(t3.Result + t4.Result);

Console.Read();
```

# Async/Await  

+ `async` 表明这个方法是异步的，声明的方法返回值必须是 `void`、`Task`、`Task<TResult>`。

+ `await` 必须用来修饰 `Task`、`Task<TResult>`

+ `await` 必须在 `async` 方法的修饰下

+ `await` 并不一定是异步的，只有在等待 `Task.Run` 等方法才会开启线程去执行



![线程池任务分配](/images/.net/task任务分配.png)

![task任务分配](/images/.net/线程池任务分配.png)



# SynchronizationContext

> 作用于通讯中充当传输者的角色，实现功能就是一个线程和另外一个线程的通讯。


```cs
SynchronizationContext context;

void Main(){
    context = new SynchronizationContext();
    //or SynchronizationContext.SetSynchronizationContext(context);
    Console.WriteLine("主线程ID : " + Thread.CurrentThread.ManagedThreadId);
    OhterThread();
    Thread.Sleep(6000);
    Console.WriteLine("主线程执行");
    context.Send(EventMethod, "Send");
    context.Post(EventMethod, "Post");
    Console.WriteLine("主线程结束");
    Console.ReadKey();
}

void OhterThread(){
    var t = new Thread(() =>
    {
        Console.WriteLine("子线程id：" + Thread.CurrentThread.ManagedThreadId);
        context.Send(EventMethod, "子线程Send");
        context.Post(EventMethod, "子线程Post");
        Console.WriteLine("子线程结束");
    });
    t.Start();
}

void EventMethod(object arg){
    Console.WriteLine("Callback     当前线程id：" + Thread.CurrentThread.ManagedThreadId + "     arg:" + (string)arg);
}
/*
`Send` 和 `Post` 方法的区别在于 `Send` 会在当前调用线程上去执行委托，即同步调用，`Post` 会在去线程池中找一个线程执行委托，即异步调用。 
Output:
    主线程ID ： 1
    子线程ID :  3
    Callback : 执行线程ID : 3 arg:子线程Send
    子线程结束
    Callback : 执行线程ID : 4 arg:子线程Post
    主线程结束
    Callback : 执行线程ID : 1 arg:主线程Send
    Callback : 执行线程ID : 5 arg:主线程Send
    主线程结束
*/
```

# 线程同步机制

## Semaphore

> 用来控制同一个资源或内存的同时可访问数量

```cs
{
    //第一个参数表示可使用的授权，第二表示最大可申请的授权
    Semaphore sema = new Semaphore(0,3);
    
    sema.WaitOne();

    int ret = sema.Release();
}
```

## Mutex

> 用于进程和线程，同一时间只有一个线程或进程独占这个资源和内存

## ManualResetEvent、AutoResetEvent