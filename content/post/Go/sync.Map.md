---
title: sync.Map
date: 2022-04-14
tags: ['go']
categories: ['源码分析']
description: 
toc: true
draft: false
---

# `sync.Map` 自带的安全 `map`

> 源码位于 `${GOPATH}/src/sync/map.go`，值得注意的是`sync.Map`是`lazy load`,不需要初始化

<!--more-->

```go
type Map struct {
	mu Mutex  // 保护此结构字段

	read atomic.Value // 并发读  -> readOnly

	dirty map[any]*entry

	misses int // 从read中读不到指定key的时候转为从dirty中读，misses++，当misses大于dirty长度时
}


// readOnly is an immutable struct stored atomically in the Map.read field.
type readOnly struct {
	m       map[any]*entry
	amended bool // 当脏map中的key不在m中时，它为true
}


// An entry is a slot in the map corresponding to a particular key.
type entry struct {
	// p points to the interface{} value stored for the entry.
	//
	// If p == nil, the entry has been deleted, and either m.dirty == nil or
	// m.dirty[key] is e.
	//
	// If p == expunged, the entry has been deleted, m.dirty != nil, and the entry
	// is missing from m.dirty.
	//
	// Otherwise, the entry is valid and recorded in m.read.m[key] and, if m.dirty
	// != nil, in m.dirty[key].
	//
	// An entry can be deleted by atomic replacement with nil: when m.dirty is
	// next created, it will atomically replace nil with expunged and leave
	// m.dirty[key] unset.
	//
	// An entry's associated value can be updated by atomic replacement, provided
	// p != expunged. If p == expunged, an entry's associated value can be updated
	// only after first setting m.dirty[key] = e so that lookups using the dirty
	// map find the entry.
	p unsafe.Pointer // *interface{} 它必须是一个指针引用
}
```

# `entry`

> 它有三种状态 `nil` `expunged` `有效状态` 

+ 若为`nil` 表示它被删除了，那么`dirty`可能是空或者存在于`dirty`中

+ 若为`expunged` 表示它被删除了，`dirty`不为空并且不存在`dirty`中

+ 否则，它是有效的，存在于`read`中，并且`dirty`不为空时，它也存在于`dirty`中



# 总结

+ `sync.Map`不是万金油，仅适合读多写少的场景，而且不能对其中的元素进行更新(要么使用`Stroe`重存储，要么对这个对象加锁)

+ `dirty` 为空时，`read` 就是此 `map` 所有数据，否则是 `dirty`

+ 原理是读写分离来提高效率