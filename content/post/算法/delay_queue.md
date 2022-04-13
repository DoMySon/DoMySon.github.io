---
title: 延时队列
date: 2022-04-11
tags: ['']
categories: ['算法']
description: 
toc: true
draft: false
---


# 原理
一个队列，没有明确触发时间，而是由某个触发器触发的调用。


# 实现

一般通过时间轮子来实现，也有redis的分布式延时队列实现（以后补充）

<!--more-->

```go
// 基于纯go的 delay_queue 伪代码
type Task struct{
    cycle int  // 第几次循环执行，0 即可执行，意味着某个循环的周期

    cb func()

    next *Task  // 减少数组移动，也可以使用ring
}

type wheel *Task

type delay_queue struct{

    p int64   // 当前任务队列指向的数组偏移

    wheelSize int64   // 时间轮尺寸， 那么时间轮周期为 interval * size

    wheelInterval time.Duration  // 最小tick周期

    wheelTimer timer.Tick  // 计时器

    wheels []wheel
}


func(dq *delay_queue) Run() {
    go func(){
        for range dq.wheelTimer{
            head := dq.wheels[dq.p%dq.wheelSize]
            next := head  // 防止链表前面任务晚于后续任务
            for head != nil {
               if head.cycle == 0 {
                   go head.cb()
                   dq.wheels[dq.p%dq.wheelSize] = head.next // 移除完成的任务
               } else{
                    head.cycle --
                    head = head.next
                }
            }
            dp.p ++
        } 
    }
}

func(dq *delay_queue) Put(callback func(),delay time.Duration) {
     pos :=  dq.p + delay
     cycle := pos / dp.wheelSize
     offset := pos%dp.wheelSize

     t := &Task {
        cycle:cycle,
        cb : callback,
     }
     if  dq.wheels[offset] == nil {
         dq.wheels[offset]  = wheel{t}
     }else{
        dq.wheels[offset].next = t
     }
}

```