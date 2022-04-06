---
title: xLua
date: 2019-03-05
tags: ["Hotfix","Lua","C#","Unity"]
categories: ["Unity"]
description: xLua为Unity、 .Net、 Mono等C#环境增加Lua脚本编程的能力，借助xLua，这些Lua代码可以方便的和C#相互调用。
img: http://www.lua.org/images/luaa.gif
toc: true
draft: false
---

# XLua

+ [XLua下载](https://github.com/Tencent/xLua/releases)

+ [配置文档](https://github.com/Tencent/xLua/blob/master/Assets/XLua/Doc/hotfix.md)

+ [FAQ](https://github.com/Tencent/xLua/blob/master/Assets/XLua/Doc/faq.md)

<!--more-->

# 标签

## `[Hotfix]`

+ 开启 `HOTFIX_ENABLE` 宏

+ 通过热补丁的方式修复代码 [xlua.hotfix函数](#Lua侧)


## `[LuaCallCsharp]`

一个C#类型加了这个配置，xLua会生成这个类型的适配代码（包括构造该类型实例，访问其成员属性、方法，静态属性、方法），否则将会尝试用性能较低的反射方式来访问。

一个类型的扩展方法（Extension Methods）加了这配置，也会生成适配代码并追加到被扩展类型的成员方法上。

xLua只会生成加了该配置的类型，`不会自动生成其父类的适配代码` ，当访问子类对象的父类方法，如果该父类加了LuaCallCSharp配置，则执行父类的适配代码，否则会尝试用反射来访问。

反射访问除了性能不佳之外，在 `il2cpp` 下还有可能因为代码剪裁而导致无法访问，

+ `xLua` 属性标签 `[LuaCallCsharp]` 来指明哪些类需要生成代码。

    ```csharp
    [LuaCallCsharp]
    public class A{

    }
    ```

+ 也可以在一个静态列表中通过标签一起生成

    ```csharp
    [LuaCallCSharp]
    public static List<Type> generate = new List<Type>()
    {
        typeof(GameObject),
        typeof(Dictionary<string, int>),
    };
    ```

+ 动态列表

    ```csharp
    public static List<Type> dynamic {
        get{
            return ( 
            from type in Assembly.Load("Assmebly-CSharp").GetTypes() 
            where type.NameSpace == "XYZ"
            select type).ToList(); 
        }
    }
    ```

## `[ReflectionUse]`

一个C#类型类型加了这个配置，xLua会生成link.xml阻止il2cpp的代码剪裁。

对于扩展方法，必须加上LuaCallCSharp或者ReflectionUse才可以被访问到。

建议所有要在Lua访问的类型，要么加LuaCallCSharp，要么加上ReflectionUse，这才能够保证在各平台都能正常运行。

## `[CSharpCallLua]`

如果希望把一个lua函数适配到一个C# delegate（一类是C#侧各种回调：UI事件，delegate参数，比如List<T>:ForEach；另外一类场景是通过 LuaTable的Get函数 指明一个lua函数绑定到一个delegate）。或者把一个lua table适配到一个C# interface，该delegate或者interface需要加上该配置。


## `[GCOptimize]`

一个C#纯值类型（注：指的是一个只包含值类型的struct，可以嵌套其它只包含值类型的struct）或者C#枚举值加上了这个配置。xLua会为该类型生成gc优化代码，效果是该值类型在lua和c#间传递不产生（C#）gc alloc，该类型的数组访问也不产生gc。各种无GC的场景.

除枚举之外，包含无参构造函数的复杂类型，都会生成lua table到该类型，以及改类型的一维数组的转换代码，这将会优化这个转换的性能，包括更少的gc alloc。


## `[BlackList]`

如果你不要生成一个类型的一些成员的适配代码，你可以通过这个配置来实现。

# Lua侧

1. `xlua.hotfix(class, [method_name], fix)`

    * 描述 ： 注入lua补丁

    * class ： C#类，两种表示方法，CS.Namespace.TypeName或者字符串方式"Namespace.TypeName"，字符串格式和C#的Type.GetType要求一致，如果是内嵌类型（Nested Type）是非Public类型的话，只能用字符串方式表示"Namespace.TypeName+NestedTypeName"；

    * method_name ： 方法名，可选；

    * fix ： 如果传了method_name，fix将会是一个function，否则通过table提供一组函数。table的组织按key是method_name，value是function的方式。将模拟整个类，如果有个key对应的方法名的话

    + 需要在对应的类上增加属性 `[Hotfix]`

2. `base(csobj)`

    + 描述 ： 子类override函数通过base调用父类实现。

    + csobj ： 对象

    + 返回值 ： 新对象，可以通过该对象base上的方法

3. `xlua.cast(luatable,typeof(CS.Namespace.TypeName))`

    + 将Lua的表结构强转换为C#对应的类型。

4. 委托、事件

    ```csharp
    public class Bridge{
        public Action OnTrigger;

        public event Action OnEvent;
    }
    ```

    Lua侧调用

    ```lua
    --增加事件和委托
    bridge:OnTrigger('+',lua_cb)
    bridge:OnEvent('+',lua_cb)
    --删除事件和委托
    bridge:OnTrigger('-',lua_cb)
    bridge:OnEvent('-',lua_cb)
    ```


# C#侧 `API`

1. `LuaEnv.DoString(string)`

    + 执行一串满足Lua规范的代码

2. `LuaEnv.AddLoader(CustomLoader)`

    + 自定义加载，以后所有执行 `DoString()` 方法都会先执行Loader。

    + 其 `CustomLoader` 是一个 `Func<ref string,string>` 类型的委托。

3. `LuaEnv,LuaTable,LuaFunction`

    + `LuaEnv.Global.Get<string>("a")`, 获取全局 string 变量 a

4. 静态方法和普通方法访问方式不一样

    + 普通方法需要通过 `:` 来索引，而静态需要 `.` 来索引。


# Lua协程和CSharp协程

```csharp
void Start(){
    StartCoroutine(Co());
}

IEnumerator Co(){
    yield return new WaitForSeconds(3f);
    var www = new WWW("http://www.baidu.com");
    yield return www;
    if(www.error!=null)
    {

    }
    else{

    }
}
```

```lua
local util = require 'xlua.util'
local yield_return = (require 'cs_coroutine').yield_return

local co = coroutine.create(function()
    yield_return(CS.UnityEngine.WatiForSeconds(3))

    local www = CS.UnityEngine.WWW('http://www.baidu.com')
    yield_return(www)
    if not www.error then
         print(www.bytes)

    else
        print(‘error:’, www.error)

    end
end)

assert(coroutine.resume(co))
```


# 第三方库集成

待完善

