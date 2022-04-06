---
title: Go Module
date: 2019-12-29
tags: ["Module"]
categories: ["Go"]
description: Go Mutex
img: https://www.runoob.com/wp-content/uploads/2015/06/go128.png
toc: true
draft: false
---

# Module

Golang 从1.11版本开始支持官方自带的依赖管理模块。根据项目路径中的 `go.mod` 文件来建立依赖管理。

<!--more-->

## 依赖添加

1. 通过 `import` 自动添加到 `go.mod` 文件中
    ```go
    import "github.com/xxx/yyy"
    ```

2. 编辑 `go.mod` 文件

    ```
    module xxx

    go 1.13.4

    require(
        xxxx v0.0.0
        yyyy v1.1.1
    )
    ```


## 依赖升级

1. 通过 go 命令
    ```bash
    #查看gin的所有版本
    go list -m -versions github.com/gin-gonic/gin

    #输出所有gin的版本
    github.com/gin-gonic/gin v1.1.1 v1.1.2 v1.1.3 v1.1.4 v1.3.0 v1.4.0 v1.5.0

    #下载所需依赖
    go mod tidy 
    ```

2. 直接编辑 `go.mod` 文件


## 删除未使用依赖项

`go mod tidy`


# 使用本地包

```
/*
    go.mod文件

    replace JB/Core/Packet v0.0.0 => ../JB/
*/

import "JB/Core/Packet" //将会引用到本地包
```