---
title: innodb
date: 2022-04-07
tags: ["mysql"]
categories: ["mysql"]
description: 
toc: true
draft: false
---

# `Innodb` 事务隔离级别有四种默认是`RR`

+ `READ UNCOMMITTED` 未提交读，A事务修改了数据但未提交，B事务可以读到这些未提交的数据（脏读）


+ `READ COMMITTED` 提交读，A事务可以读取到其他事务提交后的数据，意味着A事务中每次读到的数据可能不一样


+ `REPEATABLE READ` 可重复读，屏蔽了其它事务的`UPDATE`和`DELETE`操作，但会读取到其它事务`INSERT`的数据（幻读），只保证了第一次查询状态的一致性


+ `SERILIZABLE` 串行化，读操作会隐式获取共享锁，保证不同事务之间互斥


> 四个级别逐渐增强，每个级别解决一个问题

:-:|:-:|:-:|:-:
隔离级别|脏读|非重复读|幻读
RU|YES|YES|YES
RC|NO|YES|YES
RR|NO|NO|YES
SE|NO|NO|NO


# 测试
```sql
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED #设置当前会话的事务级别未RR

SET GLOABL TRANSACTION ISOLATION LEVEL READ UNCOMMITTED #设置全局事务级别
```


# [Mysql锁](https://zhuanlan.zhihu.com/p/29150809)

## 锁类型

+ 共享锁（读锁）：其他事务可以读，但不能写。
+ 排他锁（写锁） ：其他事务不能读取，也不能写。


## 粒度锁

+ 表级锁
> 开销小，加锁快；不会出现死锁；锁定粒度大，发生锁冲突的概率最高，并发度最低。引擎通过顺序获取锁来避免死锁，适用于查询较少的场景

+ 行级锁
> 开销大，加锁慢；会出现死锁；锁定粒度最小，发生锁冲突的概率最低，并发度也最高。适合于有大量按索引条件并发更新少量不同数据，同时又有并发查询的应用,
在 InnoDB 中，除单个 SQL 组成的事务外，
锁是逐步获得的，这就决定了在 InnoDB 中发生死锁是可能的。

+ 页级锁

> 开销和加锁时间界于表锁和行锁之间；会出现死锁；锁定粒度界于表锁和行锁之间，并发度一般。