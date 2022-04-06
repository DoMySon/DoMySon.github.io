---
title: mysql100问
date: 2022-04-06
tags: ['mysql']
categories: ['mysql']
description:  mysql面试题
toc: true
draft: false
---

# 聚集、非聚集、联合索引

+ A1: 聚集索引（主键索引）所有ROW都会按照主键索引进行排序

+ A2: 非聚集索引即普通索引加上字段

+ A3: 几个字段组成的索引

+ A4: 聚集索引在物理上连续，非聚集索引在物理上不连续，但在逻辑上连续

+ A5: 聚集索引影响物理存储顺序，而非聚集索引不影响

+ A6: 聚集索引插入慢，查询快，非聚集索引反之

+ A7: 索引是通过二叉树来描述的，聚集索引的子叶节点也是数据节点，而非聚集索引子叶节点仍是索引节点


# 自增主键有哪些问题

+ A1: 分表分库的时候可能会出现重复情况（可使用uuid替代）
+ A2: 产生表锁
+ A3: id耗尽 


# 索引无效的情况

+ A1: 以`%`开头的`LIKE`语句，模糊匹配
+ A2: `OR` 前后字段未同时使用索引
+ A3: 数据类型隐式转换（varchar->int)


# 查询优化

+ A1: 在`WHERE`和`ORDER BY`所涉及的列上加上索引
+ A2: `SELECT`避免使用`*`,SQL语句全部大写
+ A3: 避免`WHERE`对索引列上进行`IS NULL`判断，替换成`IS NOT NULL`
+ A4: `IN`和`NOT IN`会导致全表扫描,替换为`EXISTS`或`NOT EXISTS`
+ A5: 避免在索引上进行计算
+ A6: `WHRER`使用`OR`会放弃索引进而全表扫描


# CHAR和VARCHAR的区别

+ A1: 存储和检索方式不同
+ A2: `CHAR`长度在创建时候指定(1~255),在存储时尾部全部填充空格


# 主键索引和唯一索引的区别

+ A1: 主键是一种约束
+ A2: 主键一定包含一个唯一索引，反之不成立
+ A3: 主键索引不允许包含空值，而唯一索引可以
+ A4: 一张表只能有一个主键索引，而唯一索引可以有多个


# CPU飙升问题排查

+ A1: top命令观察`mysqld`
+ A2: 若是，则`show processlist`查看是否是 SQL 的问题，
+ A3: 若是，则检查执行计划是否准确，是否索引确实，数据是否太大
+ A4: kill上述线程，加索引，改内存，改SQL并重跑
+ A5: 若不是，可能是短时间有大量连接，可以限制最大连接数


# 如何创建索引

+ A1: 
    ```sql 
    CREATE INDEX indexName ON table; #创建普通索引

    DROP INDEX indexName ON table;
    ```

+ A2: 唯一索引和普通索引的区别是唯一索引值不允许重复
    ```sql
    CREATE UNIQUE INDEX indexName ON table;
    
    ALTER TABLE table ADD [UNIQUE|PRIMARY KEY] indexName; #修改表

    # 直接在创建时指定 
    ```

+ A3:
    ```sql
    SHOW INDEX from talbe; #显示表中的索引
    ```