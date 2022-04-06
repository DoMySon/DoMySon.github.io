---
title: MySQL
date: 2019-03-16
tags: ["mysql"]
categories: ["database"]
description: MySQL 是最流行的关系型数据库管理系统，在 WEB 应用方面 MySQL 是最好的 RDBMS(Relational Database Management System：关系数据库管理系统)应用软件之一。
img: http://www.runoob.com/wp-content/uploads/2014/03/mysql.jpg
toc: true
draft: false
---

# 简介

> MySQL 是最流行的关系型数据库管理系统，在 WEB 应用方面 MySQL 是最好的 RDBMS(Relational Database Management System：关系数据库管理系统)应用软件之一。

# 下载地址
[MySQL下载地址](http://dev.mysql.com/downloads/mysql/)

# 基本类型

名称|大小|范围
:-:|:-:|:-:
`tinyint(m)`|1字节|-2^7~2^7-1
`smallint(m)`|2字节|-2^15~2^15-1
`mediumint(m)`|3字节|-2^23~2^23-1
`int(m)`|4字节|-2^31~2^31-1
`bigint(m)`|8字节|-2^63~2^63-1
`char(n)`|1字节|最多255个字符
`varchar(n)`|最多65535个字符
`tinytext`|最多255个字符
`text`|最多65535个字符
`mediumtext`|最多2的24次方-1个字符
`longtext`|最多2的32次方-1个字符
`date`|日期 '2008-12-2'
`time`|时间 '12:25:36'
`datetime`|日期时间 '2008-12-2 22:06:44'
`timestamp`|自动存储记录修改时间

<!--more-->

# 专业名

+ SQL（Structure Query Language）结构化查询语言

+ DQL（data query language）数据查询语言 select操作

+ DML（data manipulation language）数据操作语言，主要是数据库增删改三种操作

+ DDL（data defination language）数据库定义语言，主要是建表、删除表、修改表字段等操作

+ DCL（data control language）数据库控制语言，如commit，revoke之类的，在默认状态下，只有sysadmin,dbcreator,db_owner或db_securityadmin等人员才有权力执行DCL


# 查询

> 执行顺序：select –>where –> group by–> having–>order by

## 排序查询

```sql
# desc为降序，asc为升序
select 字段名 from 表名 order by 列名 [desc|asc];
# 若row1相同则按row2升序排序
select * form tb order by row1 asc,row2 asc;
```

## 聚合函数

> 聚合函数指在查询数据时可以将一列数据进行纵向的计算。

```sql
select count(x) from y
```

函数名|作用|格式
:-:|:-:|:-:
count|求指定列的个数|count(列名)
min|求指定列的最小值|min(列名)
max|求指定列的最大值|max(列名)
sum|求指定列的和|sum(列名)
avg|求指定列的平均值|avg(列名)

> 每个列对应的字段类型要为可比较的，如 Text 将会出现意外的结果

## 分组查询

> 按照特定条件把数据进行分组，把每一组当做一个整体，分别对某一组数据进行计算。

### 对所有数据分组查询

```sql
# 按性别进行分组，查询数学的平均成绩
SELECT sex,AVG(math) FROM student GROUP BY sex;
```

### 分组前查询

```sql
# 按数学成绩大于70分的条件进行男女分组，并查询平均成绩
SELECT sex, AVG(math),COUNT(id) FROM student WHERE math>70 GROUP BY sex;
```

### 分组后查询 

```sql
# 按数学成绩大于70分的条件进行男女分组，并查询平均成绩，再筛查人数大于2的组
SELECT sex, AVG(math),COUNT(id) FROM student WHERE math>70 GROUP BY sex HAVING COUNT(id)>2;

# 使用 As 取别名
SELECT sex, AVG(math) AS 平均分,COUNT(id) AS 个数 FROM student WHERE math>70 GROUP BY sex HAVING 个数>2;
```

## 分页查询

> 当要查询的数据量比较多的时候，采用一次查询固定条记录的方式。

```sql
# 查询索引开始为6，数量为3,即 6，7，8
select * from tb limit 6,3;
```


# 更新

## WHERE

```sql
select field1... from table1... [where cond1 [AND[OR] cond2...]]
```

## UPDATE

+ 可以更新一个或多个字段

+ 可以用 `where` 指定约束条件

```sql
update talbe set field=nVal ... [where cond]
```

## DELETE

+ 若不指定条件则删除所有记录

+ 可以用 `where` 指定约束条件

+ `delete`、`truncate`、`drop` 的区别在于，前两者只删除数据，后者直接删除表。`delete` 是 DML 语句，可以在事务中回滚，后两者是 DDL 语句。执行速度 drop > truncate > delete

```sql
delete from table1 [where cond]
```


## LIKE


## GROUP BY