---
title: Snowflake
date: 2019-08-27
tags: [""]
categories: ["算法"]
description: 分布式ID算法
img: https://www.runoob.com/wp-content/uploads/2015/06/go128.png
toc: true
draft: false
---

> `snowflake`（雪花算法）是一种分布式ID算法。

# 对比其他的优缺点

+ `UUID` : 对于数据敏感场景不宜使用，且不适合于分布式场景。

+ `GUID` : 采用无意义字符串，数据量增大时造成访问过慢，且不宜排序。

<!--more-->

# 描述

+ 最高位是符号位，始终为0，不可用。

+ 41位的时间序列，精确到毫秒级，41位的长度可以使用69年。时间位还有一个很重要的作用是可以根据时间进行排序。

+ 10位的机器标识，10位的长度最多支持部署1024个节点。

+ 12位的计数序列号，序列号即一系列的自增id，可以支持同一节点同一毫秒生成多个ID序号，12位的计数序列号支持每个节点每毫秒产生4096个ID序号。


## 实现

```go
/* snowFlake 64bit
|-+----------------41bit----------------+---10bit---+----12bit----|
|0 00000000 00000000 00000000 00000000 0 00000000 00 00000000 0000|
|-+--------------时间戳-----------------+---机器ID---+----序列号---|
*/

var(
    sn int64                          //序列号 从0开始 范围为 0~4095
    lastTs int64 = time.Now().Unix()  //基于秒
)

func snowfalke(machineID int64) int64 {
	// 同一毫秒
	ts := time.Now().Unix()
	if time.Now().Unix() == lastTS {
		sn++
		// 序列号占 12 位,十进制范围是 [ 0, 4095 ]
		if sn > 4095 {
			sn = 0
		}
		// 取 64 位的二进制数 0000000000 0000000000 0000000000 0001111111111 1111111111 1111111111 1 ( 这里共 41 个 1 )和时间戳进行并操作
		// 并结果( 右数 )第 42 位必然是 0, 低 41 位也就是时间戳的低 41 位
		rightBinValue := ts & 0x1FFFFFFFFFF
		// 机器 id 占用10位空间,序列号占用12位空间,所以左移 22 位; 经过上面的并操作,左移后的第 1 位,必然是 0
		rightBinValue <<= 22
		id := rightBinValue | machineID | sn
		return id
	}
	if ts > lastTS {
		sn = 0
		lastTS = ts
		// 取 64 位的二进制数 0000000000 0000000000 0000000000 0001111111111 1111111111 1111111111 1 ( 这里共 41 个 1 )和时间戳进行并操作
		// 并结果( 右数 )第 42 位必然是 0, 低 41 位也就是时间戳的低 41 位
		rightBinValue := curTS & 0x1FFFFFFFFFF
		// 机器 id 占用10位空间,序列号占用12位空间,所以左移 22 位; 经过上面的并操作,左移后的第 1 位,必然是 0
		rightBinValue <<= 22
		id := rightBinValue | machineID | sn
		return id
	}
	if ts < lastTS {
		return 0
	}
	return 0
}
```