---
title: Unity内存管理
date: 2019-12-27
tags: ["Unity"]
categories: ["Unity"]
description: 
img: http://www.lua.org/images/luaa.gif
toc: true
draft: false
---

# Unity 托管内存

1. 用户代码分配的内存本质上在 `IL2CPP` 构建的 `VM` 的托管内存(`Managed Memory`)上，所以用户代码分配遵从于这个 `VM` 的分配方式。

2. `IL2CPP` 采用的是 `Boehm` 回收算法,这算法的缺陷是 `不分代`，`不压缩`，虽然提高了效率，但由于用户申请内存的不确定性，容易造成内存碎片，不利于此块的内存重使用。

3. 内存以 `Block` 来管理，当一个 `Block` 6次GC没有被访问，才会返回给 OS。

3. `Zombie Memory`,由于用户不主动释放，但实际没有使用。那么这块内存将不会被回收。

4. 对于一个物体，应该是 `Destory` 而不是置为 `Null`。

4. 下一代采用 `渐进式GC`（分帧GC，使CPU峰值更平滑），可以手动开关。

<!--more-->

# 官方地址

[浅谈Unity内存管理](https://www.bilibili.com/video/av79798486)


# Unity内存优化

## Assetbundle

1. TypeTree:
    
    本身是为了兼容 `Editor` 版本和 `Assetbundle` 版本不同的情况下可以互相使用，这个行为可以手动关闭，但必须保证 `Editor` 和 `Assetbundle` 版本相同。

2. LZ4:
    
    官方本身建议这种压缩算法，是一种基于 `Chunck` 的压缩算法，只需要舍弃一点内存，可以提升 `30%-%40` 左右的解压速率。听说后期带有加密功能。

3. Size&Count:

    由于每个 `Assetbundle` 都会有头信息，有时候过小的资源打包会造成比原始资源还大的现象，官方建议是 `3-5MB` 每个。
    

## Resources

> 本身是基于 R-B Tree 建立的索引，官方只建议在测试的时候使用。

## Textrue

1. 控制缓冲区大小

2. 对于确定只读的图片资源的话，关闭 Read/Write

3. Mipmaps 通常关闭


## Audio

1. DSP Buffer: 值过大，声音延时，过小CPU上升

2. Format: 音频格式

3. Compress Format: 压缩格式

4. Face to Mono: 不知道

## Mesh

1. Read/Write

2. Compress: 有Bug


## Coroutine

1. 在协程中，所有局部变量都不是局部变量，最后会被构造成 `IEunmator` 返回。官方建议即用即销毁。

2. 对于一个异步操作，`Coroutine` 本质是轮询。

## Code Size

1. 对于泛型组合

# CPU访问内存顺序

> Core -> L1 -> L2 -> L3 -> Memory -> Disk

上述访问由快到慢,提高命中率，就提高了速度


