---
title: CSharp's GC
date: 2019-08-20
tags: ["GC"]
categories: ["CSharp"]
description: 描述个蛋蛋
img: https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=3546132657,3900052359&fm=58&bpow=519&bpoh=518
author: "Treasure丶"
toc: true
draft: false
#weight: 2 文章排序权重，越小越靠前
---

> .NET的GC机制有这样两个问题：

1. GC并不是能释放所有的资源。它并不能自动释放非托管资源。

2. GC并不是实时性的，这将会造成系统性能上的瓶颈和不确定性。

3. GC并不是实时性的，这会造成系统性能上的瓶颈和不确定性。所以有了`IDisposable`接口，`IDisposable`接口定义了`Dispose`方法，这个方法用来供程序员显式调用以释放非托管资源。使用`using`语句可以简化资源管理。

![XX](/images/abc.png)

<!--more-->

# 托管资源和非托管资源

+ 托管资源指的是.NET可以自动进行回收的资源，主要是指托管堆上分配的内存资源。托管资源的回收工作是不需要人工干预的，有.NET运行库在合适调用垃圾回收器进行回收。

+ 非托管资源指的是.NET不知道如何回收的资源，最常见的一类非托管资源是包装操作系统资源的对象，例如文件，窗口，网络连接，数据库连接，画刷，图标等。这类资源，垃圾回收器在清理的时候会调用Object.Finalize()方法。默认情况下，方法是空的，对于非托管对象，需要在此方法中编写回收非托管资源的代码，以便垃圾回收器正确回收资源。

>在.NET中，Object.Finalize()方法是无法重载的，编译器是根据类的析构函数来自动生成Object.Finalize()方法的，所以对于包含非托管资源的类，可以将释放非托管资源的代码放在析构函数。


# 关于GC优化

正常情况下，我们是不需要去管GC这些东西的，然而GC并不是实时性的，所以我们的资源使用完后，GC什么时候回收也是不确定的，所以会带来一些诸如内存泄漏、内存不足的情况，比如我们处理一个约500M的大文件，用完后GC不会立刻执行清理来释放内存，因为GC不知道我们是否还会使用，所以它就等待，先去处理其他的东西，过一段时间后，发现这些东西不再用了，才执行清理，释放内存。

```c#
GC.SuppressFinalize(obj);//请求CLRb不要调用指定对象的终结器

GC.GetTotalMemory(false);//检索当前需要分配的字节,参数代表是否需要d等待一段时间再返回 单位 B

GC.Collect();//强制进行一次GC
```

## GC运行机制

```
GC是一个后台线程，他会周期性的查找对象，然后调用Finalize()方法去销毁他，我们继承IDispose接口，调用Dispose方法，销毁了对象，而GC并不知道。GC依然会调用Finalize()方法，而在.NET中Object.Finalize()方法是无法重载的，所以我们可以使用析构函数来阻止重复的释放。我们调用完Dispose方法后，还有调用GC.SuppressFinalize(this)方法来告诉GC，不需要在调用这些对象的Finalize()方法了。
```

```c#
public class Garbage:IDisposable{

    StringBuilder sb = null;

    //构造函数
    public Garbage(){
        sb = new StringBuilder();
    }

    //析构函数
    ~Grabage(){
        M_Diso(false);
    }

    //手动制造垃圾
    public void MakeGarbage(){
        for(int i = 0;i<99999;i++){
            sb.Append("abc");
        }
    }

    //实现IDisposable接口
    public void Dispose(){
        M_Diso(true);
    }


    void M_Diso(bool real){
        if (!disposing)
        {
            return;
        }
        sb = null;
        GC.Collect();
        GC.SuppressFinalize(this);
    }
}

//测试代码
using(Garbage g = new Garbage())
{
    g.MakeGarbage();
    Console.WriteLine("Total memory is {0} KBs.", GC.GetTotalMemory(false) / 1024);
}

Console.WriteLine("After GC total memory is {0} KBs.", GC.GetTotalMemory(false) / 1024);

Console.Read();

```

## 代码如何运行
会先调用Dispose方法，如果去掉`GC.SuppressFinalize`,那么然后才会调用析构函数。所以,当调用Dispose方法后,GC才会去调用析构函数销毁对象，释放内存。