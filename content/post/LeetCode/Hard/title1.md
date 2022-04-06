---
title: 二叉树的后序遍历
date: 2019-04-23
tags: ["hard"]
categories: ["LeetCode"]
description: Go是一个好东西
img: https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555997539093&di=2ef6151fd6808dca288f23a79df80759&imgtype=0&src=http%3A%2F%2Fpic2.zhimg.com%2Fv2-7322df28fae463d7e7c925dde562818a_1200x500.jpg
toc: true
draft: true
---


# 描述

给定一个二叉树，返回它的 后序 遍历。
```
输入: [1,null,2,3]  
   1
    \
     2
    /
   3 

输出: [3,2,1]
```

# 解释

优先遍历左子叶，然后右子叶，最后节点

<!--more-->
# 难度

困难

# 链接

[二叉树的后序遍历](https://leetcode-cn.com/problems/binary-tree-postorder-traversal/)

# 解答

+ Go

```go
/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */

var result []int

func postorderTraversal(root *TreeNode) []int {
    if root == nil {
        return []int{}
    }

    if root.Left != nil {
        result = postorderTraversal(root.Left)
    }

    if root.Right != nil {
        result = postorderTraversal(root.Right)
    }

    result = append(result, root.Val)

    return result
}
```
> 这段代码在本地能通过，但在 `LeetCode` 上测试 `result` 变量会缓存上一次结果，所以测试结果未知