---
title: Bitmap
date: 2019-05-01
tags: ["Bitmap"]
categories: ["Algorithm"]
img: https://www.runoob.com/wp-content/uploads/2015/06/go128.png
toc: true
description: Bitmap（基于位的映射）
draft: false
---

# Bitmap

## 原理

`bitmap` 使用一个 `bit` 来标记某个元素对应的一个 `value（0、1）` ，其实质性作用节省了内存空间

## 作用

查询对应的一个元素是否存在，比如一个网页请求（[BoolmFilter](#BoolmFilter)）， 经过多次 `hash` 之后会得到一个数值 然后在 `bitmap` 中查找 `value ?= 1`，比 `map` 这种数据结构省了大量的内存。其本质还是将 `key` 计算的值存储，而非存储 `key` 本身，所以牺牲了时间而换取了空间

## 缺陷

+ 不支持非运算
    
    取非之后的结果，并不一定包含真实的信息，比如 `[]int{0,1,2,3,5}` ,只不包含 4 个这个数,但是如果这个 `bitmap` 有10个空间，那么会认为也不包括 `[]int{6,7,8}` ，但其本身不包含。全量 `bitmap: [1,1,1,1,1,1,0,0,0,0]` 与其 `XOR` 运算可得缺少的数正好是第四位上的数。

+ 统计

    仅仅能判断存在，而不能判断存在几个

+ 碰撞
    
    不同的数据也能有相同的 `hash`，所以会存在碰撞问题

+ 稀疏
    
    对于数据过少的，也需要一定量的空间，也许比原始数据空间更大。可以通过 [RoaringBitmap](#RoaringBitmap) 解决 或 `Google(EWAH)`


## 实现

```go
type bitmap struct {
	bytes []byte

	cap int
}

func NewBitMap(cap int) *bitmap {
	return &bitmap{
        //左移三位的作用是，1个byte可以存储8bit
		make([]byte, (cap>>3)+1),
		cap,
	}
}

func (this *bitmap) Add(val int) {
	idx := val >> 3
	pos := val % 8
	this.bytes[idx] |= 1 << uint(pos)
}

func (this *bitmap) Contain(val int) bool {
	idx := val >> 3
	pos := val % 8
	return (this.bytes[idx] & (1 << uint(pos))) != 0
}

func (this *bitmap) Clear(val int){
	idx := val >> 3
	pos := val % 8
    this.bytes[idx] &= ~ (1 << uint(pos))
}
```

# BoolmFilter

> 待完善

+ 减少了 I/O

# RoaringBitmap

> 待完善

# 啄木鸟Bitmap

> 待完善