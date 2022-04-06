---
title: ClassicSort
date: 2019-07-27
tags: ["Sort"]
categories: ["算法"]
description: 经典排序算法
img: https://www.runoob.com/wp-content/uploads/2015/06/go128.png
toc: true
draft: false
---


# 概念

## 稳定排序，非稳定排序

> 如果 a 原本在 b 的前面，且 a == b，排序之后 a 仍然在 b 的前面，则为稳定排序。若可能 a 不在 b 的后面则为  `非稳定排序`

## 原地排序，非原地排序

> 原地排序就是指在排序过程中不申请多余的存储空间，只利用原来存储待排数据的存储空间进行比较和交换的数据排序。若利用了其他辅助数组，则为 `非原地排序`

## 时间复杂度

> 一个算法执行所耗费的时间

## 空间复杂度

> 完成算法所需的内存空间大小

<!--more-->

# 冒泡排序(Bubble Sort)

> 冒泡排序（Bubble Sort）是一种简单直观的排序算法。它重复地走访过要排序的数列，一次比较两个元素，如果他们的顺序错误就把他们交换过来。走访数列的工作是重复地进行直到没有再需要交换，也就是说该数列已经排序完成。这个算法的名字由来是因为越小的元素会经由交换慢慢"浮"到数列的顶端。
 
## 算法步骤

+ 比较相邻的元素。如果第一个比第二个大，就交换他们两个。

+ 对每一对相邻元素作同样的工作，从开始第一对到结尾的最后一对。这步做完后，最后的元素会是最大的数。

+ 针对所有的元素重复以上的步骤，除了最后一个。

+ 持续每次对越来越少的元素重复上面的步骤，直到没有任何一对数字需要比较。

## 动态图

![BubbleSort](/images/Algorithm/BubbleSort.gif)


## 复杂度

|Avg|Best|Bad|Space|Mode|Stability
|:-:|:-:|:-:|:-:|:-:|:-:
O(n^2)|O(n^2)|O(n^2)|O(1)|In-Space|Yes

## 实现

```go
func BubbleSort(arr []int) []int {
    l := len(arr)
    for i := 0; i < l-1; i++ {
        for j := i + 1; j < l; j++ {
            if arr[i] > arr[j] {
                arr[i], arr[j] = arr[j], arr[i]
            }
        }
    }
    return arr
}
```


# 快速排序(Quick Sort)

> 快速排序(Quick Sort)使用分治法策略。它的基本思想是：选择一个基准数，通过一趟排序将要排序的数据分割成独立的两部分；其中一部分的所有数据都比另外一部分的所有数据都要小。然后，再按此方法对这两部分数据分别进行快速排序，整个排序过程可以递归进行，以此达到整个数据变成有序序列。算法依据是 `分治法`

## 算法步骤

+ 从数列中挑出一个基准值。

+ 将所有比基准值小的摆放在基准前面，所有比基准值大的摆在基准的后面(相同的数可以到任一边)；在这个分区退出之后，该基准就处于数列的中间位置。

+ 递归地把"基准值前面的子数列"和"基准值后面的子数列"进行排序。


## 动态图

![QuickSort](/images/Algorithm/QuickSort.gif)


## 复杂度

|Avg|Best|Bad|Space|Mode|Stability
|:-:|:-:|:-:|:-:|:-:|:-:
O(nlogn)|O(nlogn)|O(n^2)|O(logn)|Out-Space|No

## 实现

```go
func QuickSort(arr []int, start, end int) {
    //双指针法
    if start >= end {
        return
    }
    //第一次调用 设置第一个元素 pivot
    pivot, left, right := arr[start], start, end

    for left != right {
        for left < right && arr[right] > pivot {
            right--
        }
        for left < right && arr[left] <= pivot {
            left++
        }
        if left < right {
            arr[left], arr[right] = arr[right], arr[left]
        }
    }
    //pivot和指针重合点交换
    arr[left], arr[start] = arr[start], arr[left]
    //此时 left 的位置已经是正确位置，所以不用参与排序 应当排除
    QuickSort(arr, start, left-1)
    QuickSort(arr, left+1, end)
}
```

# 插入排序(Insertion Sort)

> 它的工作原理是通过构建有序序列，对于未排序数据，在已排序序列中从后向前扫描，找到相应位置并插入。插入排序和冒泡排序一样，也有一种优化算法，叫做拆半插入。

## 算法步骤

+ 将第一待排序序列第一个元素看做一个有序序列，把第二个元素到最后一个元素当成是未排序序列。

+ 从头到尾依次扫描未排序序列，将扫描到的每个元素插入有序序列的适当位置。（如果待插入的元素与有序序列中的某个元素相等，则将待插入元素插入到相等元素的后面。


## 动态图

![InsertionSort](/images/Algorithm/InsertionSort.gif)


## 复杂度

|Avg|Best|Bad|Space|Mode|Stability
|:-:|:-:|:-:|:-:|:-:|:-:
O(n^2)|O(n)|O(n^2)|O(1)|In-Space|Yes

## 实现

```go
func InsertionSort(arr []int) {
    for i := 1; i < l; i++ {
		curor, cur = i-1, arr[i]
		for curor >= 0 && arr[curor] > cur {
			arr[curor+1] = arr[curor]
			curor--
		}
		arr[curor+1] = cur
	}
}   
```

# 堆排序(Heap Sort)

> 堆积是一个近似完全二叉树的结构，并同时满足堆积的性质：即子结点的键值或索引总是小于（或者大于）它的父节点。堆排序可以说是一种利用堆的概念来排序的选择排序。分为两种方法：
大顶堆：每个节点的值都大于或等于其子节点的值，在堆排序算法中用于升序排列；小顶堆：每个节点的值都小于或等于其子节点的值，在堆排序算法中用于降序排列

## 算法步骤

+ 创建一个堆 H[0……n-1]；

+ 把堆首（最大值）和堆尾互换；

+ 把堆的尺寸缩小 1，并调用 shift_down(0)，目的是把新的数组顶端数据调整到相应位置；

+ 重复步骤 2，直到堆的尺寸为 1。


## 动态图

<!--![InsertionSort](/images/Algorithm/InsertionSort.gif)-->

## 复杂度

|Avg|Best|Bad|Space|Mode|Stability
|:-:|:-:|:-:|:-:|:-:|:-:
O(nlgn)|O(nlgn)|O(nlgn)|O(1)|In-Space|No

## 实现

```go
func heapSort(arr []int){
    arrLen := len(arr)
    for i := arrLen / 2 - 1; i >= 0; i-- {
        heapify(arr, i, arrLen)
    }
    for i := arrLen - 1; i >= 0; i-- {
        arr[0],arr[i] = arr[i],arr[0]
        arrLen -= 1
        heapify(arr, 0, arrLen)
    }
}

func heapify(arr []int, root, arrLen int) {
    /*
        根据完全二叉的性质
        左边子节点位置 = 当前父节点的两倍 + 1，右边子节点位置 = 当前父节点的两倍 + 2
    */
    left := 2*root + 1
    right := 2*root + 2
    //假定最大的元素是父节点
    max := root
    //保证父节点最大
    if left < arrLen && arr[left] > arr[max] {
        max = left
    }
    if right < arrLen && arr[right] > arr[max] {
        max = right
    }
    if max != root {
        arr[i],arr[max] = arr[max],arr[i]
        //递归直至完成一次堆排序
        heapify(arr, max, arrLen)
    }
}
```


# 归并排序(Merge Sort)

> 归并排序（Merge sort）是建立在归并操作上的一种有效的排序算法。该算法是采用分治法（Divide and Conquer）的一个非常典型的应用。自上而下的递归（所有递归的方法都可以用迭代重写，所以就有了第 2 种方法）；自下而上的迭代；归并排序是稳定排序，它也是一种十分高效的排序，能利用完全二叉树特性的排序一般性能都不会太差。

## 算法步骤

+ 申请空间，使其大小为两个已经排序序列之和，该空间用来存放合并后的序列；

+ 设定两个指针，最初位置分别为两个已经排序序列的起始位置；

+ 比较两个指针所指向的元素，选择相对小的元素放入到合并空间，并移动指针到下一位置；

+ 重复步骤 3 直到某一指针达到序列尾；

+ 将另一序列剩下的所有元素直接复制到合并序列尾。


## 动态图

![MergeSort](/images/Algorithm/MergeSort.gif)

## 复杂度

|Avg|Best|Bad|Space|Mode|Stability
|:-:|:-:|:-:|:-:|:-:|:-:
O(nlogn)|O(nlogn)|O(nlogn)|O(n)|Out-Space|Yes

## 实现

```go
func MergeSort(arr []int) []int {
    length := len(arr)
    if length < 2 {
        return arr
    }
    middle := length / 2
    left := arr[0:middle]
    right := arr[middle:]
    return merge(MergeSort(left), MergeSort(right))
}

func merge(left []int, right []int) []int {
    var result []int
    for len(left) != 0 && len(right) != 0 {
        if left[0] <= right[0] {
            result = append(result, left[0])
            left = left[1:]
        } else {
            result = append(result, right[0])
            right = right[1:]
        }
    }

    for len(left) != 0 {
        result = append(result, left[0])
        left = left[1:]
    }

    for len(right) != 0 {
        result = append(result, right[0])
        right = right[1:]
    }
    return result
}
```

# 选择排序(Selection Sort)

> 选择排序是一种简单直观的排序算法，无论什么数据进去都是 O(n²) 的时间复杂度。所以用到它的时候，数据规模越小越好。

## 算法步骤

+ 首先在未排序序列中找到最小（大）元素，存放到排序序列的起始位置。

+ 再从剩余未排序元素中继续寻找最小（大）元素，然后放到已排序序列的末尾。

+ 重复第二步，直到所有元素均排序完毕。

## 动态图

![SelectionSort](/images/Algorithm/SelectionSort.gif)


## 复杂度

|Avg|Best|Bad|Space|Mode|Stability
|:-:|:-:|:-:|:-:|:-:|:-:
O(n^2)|O(n^2)|O(n^2)|O(1)|In-Space|No

## 实现

```go
func SelectionSort(arr []int) []int {
    var minIdx int
    for i := 0; i < len(arr)-1; i++ {
        minIdx = i
        for j := i + 1; j < len(arr); j++ {
            if arr[j] < arr[minIdx] {
                minIdx = j
            }
        }
        if i == minIdx {
            continue
        }
        arr[i], arr[minIdx] = arr[minIdx], arr[i]
    }
    return arr
}
```

# 计数排序(Counting Sort)

> 计数排序的核心在于将输入的数据值转化为键存储在额外开辟的数组空间中。作为一种线性时间复杂度的排序，计数排序要求输入的数据必须是有确定范围的整数。

## 算法步骤

+ 找出待排序的数组中最大和最小的元素。

+ 统计数组中每个值为i的元素出现的次数，存入数组C的第i项。

+ 对所有的计数累加（从C中的第一个元素开始，每一项和前一项相加）

+ 反向填充目标数组：将每个元素i放在新数组的第C(i)项，每放一个元素就将C(i)减去1

## 动态图

![CountingSort](/images/Algorithm/CountingSort.gif)


## 复杂度

|Avg|Best|Bad|Space|Mode|Stability
|:-:|:-:|:-:|:-:|:-:|:-:
O(n+k)|O(n+k)|O(n+k)|O(k)|Out-Space|Yes

## 实现

> 优化： 补0偏移,当最小值不为0的时候会开辟额外的空间，增加遍历量，强制计算偏移，对齐0索引

```go
func countingsort(arr []int) []int {
    var minVal, maxVal int
    //找出最大最小值
    for _, v := range arr {
        if v > maxVal {
            maxVal = v
        } else if v < minVal {
            minVal = v
        }
    }
    //补0偏移 原创
    offset := 0 - minVal
    bucket := make([]int, maxVal+offset+1)
    for _, v := range arr {
        bucket[v+offset]++
    }
    idx := 0
    //key对应着数字，value则是出现的次数，0次表示不存在这个数
    for i, v := range bucket {
        for v != 0 {
            arr[idx] = i - offset
            idx++
            v--
        }
    }
    return arr
}
```
    


# 桶排序(Bucket Sort)

> 桶排序是计数排序的升级版。它利用了函数的映射关系，高效与否的关键就在于这个映射函数的确定。为了使桶排序更加高效，我们需要做到这两点：1.在额外空间充足的情况下，尽量增大桶的数量，2.使用的映射函数能够将输入的 N 个数据均匀的分配到 K 个桶中。同时，对于桶中元素的排序，选择何种比较排序算法对于性能的影响至关重要。

## 算法步骤

+ 找出待排序的数组中最大和最小的元素。

+ 按照桶的大小分配桶配元素

+ 再对桶里的元素进行其他方式排序

## 动态图

![CountingSort](/images/Algorithm/CountingSort.gif)


## 复杂度

|Avg|Best|Bad|Space|Mode|Stability
|:-:|:-:|:-:|:-:|:-:|:-:
O(n+k)|O(n+k)|O(n^2)|O(n+k)|Out-Space|Yes

## 实现

> 当桶的尺寸为1的时候，本质上就是计数排序了,属于非比较排序

```go
func Bucketsort(arr []int) []int {
    var minVal, maxVal int //找出最大最小值
    for _, v := range arr {
        if v < minVal {
            minVal = v
        } else if v > maxVal {
            maxVal = v
        }
    }
    bucketSize := 5                               //桶大小设为5，意为最多能装5个元素，也可以指定
    bucketCount := (maxVal-minVal)/bucketSize + 1 //需要创建桶的数量
    buckets := make([][]int, bucketCount)         //第一个桶装0~4 第二个装 5~9 ...

    for _, v := range arr {
        //计算这个元素该分配到哪个桶里
        bucketIdx := (v - minVal) / bucketSize
        buckets[bucketIdx] = append(buckets[bucketIdx], v)
    }
    
    var ret []int
    //然后对每个桶进行排序
    for _, v := range buckets {
        //这里使用冒泡排序
        val := BubbleSort(v)
        ret = append(ret, val...)
    }
    return ret
}
```


# 拓扑排序(Topology Sort)

> 待续

