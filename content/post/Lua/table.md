---
title: lua's table
date: 2019-03-18
tags: ["table"]
categories: ["Lua"]
description: Go是一个好东西
img: http://www.lua.org/images/luaa.gif
toc: true
draft: true
top: true
---


# 元表(`metatable`)

``` lua
--设置 t0 的元表为 t1，若t0已经设置过，__metatable键存在则会失败
setmetatable(t0,t1)

--获取 t0 的元表，存在返回一个table，否则返回nil
getmetatable(t0)
```
>`rawget` 、 `rawset` 将不会触发任何元表操作。

<!--more-->
## 元方法
* `__index` 索引元表时
    ``` lua
    --若__index指向一个table
    setmetatable(t0,{__index = t1})
    --同样的效果
    setmetatable(t0,t1)
    t1.__index = t1
    --访问t0不存在的元素会重新定向到t1中去搜索
    t0.a --1

    --若__index指向一个function,会将 t0 与 a 传入方法中
    setmetatable(t0,{__index = function(t,key) end})
    ```

* `__newindex` 对元表更新时
    ``` lua
    --若__newindex指向一个table
    setmetatable(t0,{__newindex = t1})
    --同样的效果
    setmetatable(t0,t1)
    t1.__newindex = t1
    --设置t0中不存在的元素，会影响到t1
    t0.a = 20
    t1.a -- 20
    --若__newindex指向一个function,会将 t0 与 a 以及新的值传入方法中
    setmetatable(t0,{__newindex = function(t,key,value) end})
    ```

* `__metatable` 元表属性
    ``` lua
    t0.__metatable = t2
    ```

* `__tostring` 元表输出
    ``` lua
    --__tostring只能指向含一个参数和字符串返回的函数，x是table自身
    t1.__tostring = function(x)
        return "t1" 
    end
    setmetatable(t0,t1)
    print(t0) -- t1
    ```

* `__call` 将元表以函数的形式调用
    ``` lua
    setmetatable(t0,{__call = function(t,...)
    -- t 是 t0
    -- ...是args，一个可变参数
    end})
    t0(args)
    ```

* 算数元方法: `__add` (加),`__sub` (减),`__mul` (乘),`__div` (除),`__unm` (相反),`__mod` (取模),`__pow` (幂乘),`__concant` (连接),`__lt` (小于),`__le` (小于等于),`__eq` (等于)
    ``` lua
    --参数时 table0，table1
    local function add(t1,t2)
        local sum = 0
        sum = t1.c+t2.a
        return sum
    end
    -- 同时指向一个方法
    setmetatable(t0,{__add = add})

    setmetatable(t1,{__add = add})

    print(t0+t1) -- 11
    -- 其他的类似
    ```
---
# 通过 `metatable` 构建 `class`
## class

```lua
--内建类型，过滤掉
local buildin_class = {
    "string",
    "number",
    "function",
    "table",
    "bool",
    "nil",
    "class",
    "thread",
    "userdata",
}

--虚类引用表
local virtual_class = {}

--检查类名
local function isbuildin(cn)
    for k, v in pairs(buildin_class) do
        if v == cn then
            return true
        end
    end
    return false
end

--生成一个类 类名以及基类
function class(name, super)
    assert(type(name) == "string" and #name > 0 and not isbuildin(name), "create class err!")
    --定义一个class
    local cls = cls or {}
    --构造函数
    cls.constructor = function(self,...) end
    --析构函数
    cls.destructor = function(self) end
    --类名
    cls.name = name
    --基类
    cls.super = super
    --生成 区别于csharp
    cls.new = function(...)
        --这里才是类的实例
        local inst = inst or {}
        inst.type = cls
        --设置元表索引
        setmetatable(
            inst,
            {
                __index = virtual_class[cls]
            }
        )

        do
            local create
            create = function(cs, ...)
                --构造的时候先从基类开始构造
                if cs.super then
                    create(cs.super, ...)
                end
                if cs.construct then
                    cs:construct(...)
                end
            end
            create(cls,...)
        end

        --gc
        cls.drop = function(self)
            --当前是否存在基类
            local cs = self.type.super
            while cs do
                if cs.deconstruct then
                    cs:deconstruct()
                end
                cs = cs.super
            end
        end

        return cls
    end

    --检查虚表引用
    assert(virtual_class[cls] == nil, "repeated class : ", name)
    local vtbl = {}
    virtual_class[cls] = vtbl

    setmetatable(
        cls,
        {
            --如果对类增加属性，那么应当增加到基类中
            __newindex = function(t, k, v)
                vtbl[k] = v
            end,
            --索引
            __index = vtbl
        }
    )

    if super then
        --如果这个类存在基类，交此类的虚类属性索引定向到super
        setmetatable(
            vtbl,
            {
                __index = function(t, k)
                    return virtual_class[super][k]
                end
            }
        )
    end

    return cls
end

```

## 元方法
``` lua
--预定 t0 t1
local t0 = {c = 10}
local t1 = {a = 1,b = 2}
```
* `__index` 索引元表时
    ``` lua
    --若__index指向一个table
    setmetatable(t0,{__index = t1})
    --同样的效果
    setmetatable(t0,t1)
    t1.__index = t1
    --访问t0不存在的元素会重新定向到t1中去搜索
    t0.a --1

    --若__index指向一个function,会将 t0 与 a 传入方法中
    setmetatable(t0,{__index = function(t,key) end})
    ```

* `__newindex` 对元表更新时
    ``` lua
    --若__newindex指向一个table
    setmetatable(t0,{__newindex = t1})
    --同样的效果
    setmetatable(t0,t1)
    t1.__newindex = t1
    --设置t0中不存在的元素，会影响到t1
    t0.a = 20
    t1.a -- 20
    --若__newindex指向一个function,会将 t0 与 a 以及新的值传入方法中
    setmetatable(t0,{__newindex = function(t,key,value) end})
    ```

* `__metatable` 元表属性
    ``` lua
    t0.__metatable = t2
    ```

* `__tostring` 元表输出
    ``` lua
    --__tostring只能指向含一个参数和字符串返回的函数，x是table自身
    t1.__tostring = function(x)
        return "t1" 
    end
    setmetatable(t0,t1)
    print(t0) -- t1
    ```

* `__call` 将元表以函数的形式调用
    ``` lua
    setmetatable(t0,{__call = function(t,...)
    -- t 是 t0
    -- ...是args，一个可变参数
    end})
    t0(args)
    ```

* 算数元方法: `__add` (加),`__sub` (减),`__mul` (乘),`__div` (除),`__unm` (相反),`__mod` (取模),`__pow` (幂乘),`__concant` (连接),`__lt` (小于),`__le` (小于等于),`__eq` (等于)
    ``` lua
    --参数时 table0，table1
    local function add(t1,t2)
        local sum = 0
        sum = t1.c+t2.a
        return sum
    end
    -- 同时指向一个方法
    setmetatable(t0,{__add = add})

    setmetatable(t1,{__add = add})

    print(t0+t1) -- 11
    -- 其他类似
    ```



## 方法重写、继承  
本质是不去索引 `__index` 元方法，重写需要命名为自身类的同名方法，继承直接通过实例调用即可。