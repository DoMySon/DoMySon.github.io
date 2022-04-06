---
title: Javascript
date: 2019-02-14
tags: [""]
categories: ["Javascript"]
description: 关于Js中的 Object 以及 this 指向。
img: https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=470008297,289328854&fm=58&bpow=1280&bpoh=720
toc: true
draft: false
---

> `JavaScript` 一种直译式脚本语言，是一种动态类型、弱类型、基于原型的语言，内置支持类型。它的解释器被称为JavaScript引擎，为浏览器的一部分，广泛用于客户端的脚本语言，最早是在HTML（标准通用标记语言下的一个应用）网页上使用，用来给HTML网页增加动态功能。后来拓展到了服务端 [Node.js](https://nodejs.org/en/) 以及App应用 [Electron](https://electronjs.org/)


# 基本类型
数据类型|描述
:-:|:-:
`null`     |定义未赋值表示空值(在条件表达式中为false)
`undefined`|未定义(在条件表达式中为false)
`boolean`  |true 和 false
`number`   |数字 `NaN` `Infinity`
`string`   |用单引号或双引号表示,多行 ``,模板字符串 '${arg1},${arg2}'
`object`   |一组由键-值组成的无序集合
`Symbol`   |唯一标记值 `ES6` 新增
`function` |函数

# 变量
1. 变量默认为 `null`  

2. 变量作用域  
    * 全局作用域
    * 局部作用域
    * 块级作用域
<!--more-->

## 原型链

[原型链详解](https://www.jianshu.com/p/826b485c5696)

`每个构造函数都有一个原型对象，原型对象都包含一个指向构造函数的指针，而实例都包含一个指向原型对象的内部指针。`

```js
//构造方法
function Student(name){
    this.name = name;
    this.say = function(){
        //TODO
    }
}

let a = new Student("a"); //使用了new关键字
//原型链是: a -> Student.prototype -> Object.prottype -> null
let b = new Student("b");
//原型链是: b -> Student.prototype -> Object.prottype -> null

/*
s1.say === s2.say 是不相等的，因为不是从同一个原型链上面继承过来
2018.12.21 node v10.14.原型链方法不能使用lambda，否则this不指向自身
*/
Student.prototype.say = function(){
    //TODO
}
//这么做是在Student的原型链上绑定了一个say方法，其所有Student对象和其继承对象都会继承这个方法
```

## 原型链继承

```js
//继承
function Sub(name,age){
    //这么做可以访问 Student 的属性，但无法继承 prototype 上的属性
    Student.call(this,name);
    this.age = age;
}

/*
将 Sub 的原型指向 Student 的实例
这是最常用的方法来模拟单继承，缺点是始终要保留Student的对象
*/
Sub.prototype = new Student();

/*
将 Sub 的原型指向 Student 的原型
当修改了Sub.prototype上的方法时会影响Student.prototype
*/
Sub.prototype = Student.prototype;
```

# class（ES6） 关键字

```js
class Student{
    //必须显示声明构造函数
    constructor(name){
        //普通字段应该在方法内声明
        this.name = name;
    }
    //类方法 不需要function关键字，以下划线开头约定为私有方法
    say(){
        //TODO
    }
    //静态方法 通过 Student.st() 调用
    static st(){

    }
    //get 属性 let A = st.f0
    get f0(){
        
    }
    //set 属性 st.f1 = A
    set f1(){

    }
}
//增加静态字段
Student.Max = 10; 

class Sub extends Student{
    constructor(name,age){
        //必须显式调用基类的构造方法
        super(name);
        this.age = age;
    }
    
    sleep(){
        //TODO
    }
}

let s0 = new Student("A");
//原型链是: s0 ->  Student.prototype -> Object.prototype -> null
let s1 = new Sub("B",20);
//原型链是: s1 -> Sub.prototype -> Student.prototype -> Object.prototype -> null

//此时 s0.say === s1.say 是相等的，因为是从同一个原型链上面继承过来
```

## `instanceof`,`typeof`

+ `instanceof` 运算符用来判断一个构造函数的 `prototype` 属性所指向的对象是否存在另外一个要检测对象的原型链上,所以也能检测是否继承了某个类型。

+ `typeof` 判断实例类型，一般只有 `number`,`string`,`boolean`,`object`,`function`,`undefined`,对于自定义类型只会返回 `object`


# Object

[Object详解](https://www.cnblogs.com/pingchuanxin/p/5773326.html)

+ 删除属性
    ```js
    let o =  {x:1,y:1};

    delete o.x;

    "x" in o;//false

    let arr = [1,2,3];

    delete arr[1];

    2 in arr // false arr.length === 3 undefined替换了2
    ```

+ 检测属性
    ```js
    let obj = { x: 10};

    x in obj; //true 是属于obj原型链或则自身的属性

    obj.hasOwnProperty("x"); //true 判断是否是自身的属性，继承过来的不算
    ```

+ 创建对象
    ```js
    let foo = {
        x:10,
        say:()=>{
            //TODO
        }
    }

    let f0 = Object.create(null); //此方式创建的对象实例不继承任何，包括Object
    /*
        f0 instanceof Object  => false
        console.log(f0); //=> {}
        console.log(f0.constructor); //=> undefined
        console.log(f0.toString); //=> undefined
        console.log(f0.hasOwnProperty); //=> undefined
    */

    let f2 = Object.create(foo);
    //此方式创建的对象实例是继承foo的
    // f2 instanceof foo
    ```


## 解构赋值（ES6标准）

1. [ES6解构赋值](https://www.cnblogs.com/koto/p/5865064.html)

2. 数组解构赋值

    ```js
    let [a,b,c] = [1,2,3];
    // a = 1,b = 2,c = 3
    //默认值
    let [foo = true] = [];
    // foo = true
    ```

3. 对象结构赋值

    ```js
    //如果不同名则会被设置为 undefined
    let {foo,bar} = {foo:"foo",bar:"bar"};
    // foo = "foo" bar = "bar"

    //等价于
    let {foo:foo,bar:bar} = {foo:"foo",bar:"bar"};
    //所以赋值的后者而非前者

    let{foo:bar} = {foo:"foo"};
    //foo = undefined
    //bar = "foo"

    //指定默认值 包括完全指定和不完全指定
    let{x,y = 2} = {x:1};
    // x = 1,y = 2

    //不完全解构
    let {name} = {
        name:"zs",
        age : 18,
    };
    // name = "zs" 只需要读取所需要的数据
    ```

4. 字符串解构赋值

    ```js
    let [a,b,c,d,e] = "hello";
    //原因是字符串是 ascii码的数组

    let {length:len} = "hello";
    // len = 5
    //数组对象都有 length 这个属性
    ```

5. 数值和布尔值解构赋值

    ```js
    let {toString} = 123;
    // toString === Number.prototype.toString() true

    let {toString:s} = true;
    // s === Boolen.prototype.toString() true
    ```

6. 函数参数解构赋值
  
    ```js
    //本质传入一个匿名对象
    function objArg0({name,age}){
        //TODO
    }
    //指定一个默认值
    function objArg({name,age} = {name:"cz"}){
        //TODO
    }
    //数组类似
    ```

---

## `this，call，apply，bind`

### this

    `本质上来说，在 js 里 this 是一个指向函数执行环境的指针。this 永远指向最后调用它的对象，并且在执行时才能获取值，定义是无法确认他的值。`

    1. 作为构造函数
        ```js
        let f = new foo("js",22);

        function foo(name,age){
            this.name = name; // this === f
            this.age = age; // this === f
        }
        ```

    2. 作为普通函数
        ```js
        function foo(){
            // this === global (node)   this === window (浏览器)
            console.log(this);
        }
        foo();
        ```

    3. 作为对象属性
        ```js
        let obj = {
            name:"A",
            say:function(){
                console.log(this.name); // this === obj
            }
        }
        ```

### `call,apply,bind`
    `call`、`apply`和`bind`是`Function`对象自带的三个方法，这三个方法的主要作用是改变函数中的`this`指向。

    ```js
    let o = {
        x: 1
    };

    let b = function (y, z) {
        console.log(this.x, y, z);

        return this.x+y+z;
    }

    //将函数b绑定到对象o身上，并立刻调用b函数，b中的this指向了o，并且马上调用了
    //等价于 o.b();
    let b1 = b.call(o, 1, 1); //1,1,1 b1 == 3

    //仅仅是参数的传入方式不同
    //等价于 o.b();
    let b2 = b.apply(o, [2, 3]); // 1,2,3 b2 == 6

    //也是将函数b绑定到对象o身上，并立刻调用b函数，b中的this指向了o，并返回了一个函数，调用时机由用户确定,等价于 c = o.b; 
    //如果bind后面指定了参数，那么 c(rest...)传入参数将不再起作用
    let c = b.bind(o);

    let c1 = c(5, 5555); //1,5,5555  c1 == 5561
    ```

    call，apply，bind 第一个参数都是 this 指向的对象，call 和 apply 如果第一个参数指向 null 或 undefined 时，那么 this 会指向 window 或 global 对象。call，apply 都是改变上下文中的 this，并且是立即执行。bind 方法只是绑定，具体执行之间由用户确定。


# 柯里化(`Currying`)
>柯里化（Currying）是把接受多个参数的函数变换成接受一个单一参数(最初函数的第一个参数)的函数，并且返回接受余下的参数且返回结果的函数的技术。


## 示例
```js
//普通函数求体积
function volume(l,w,h){
    return l*w*h;
}

let v0 = volume(10,20,30);
//若都高都为30，且长宽不定 那么：
let v1 = volume(10,20,30);
let v2 = volume(11,21,30);
let v3 = volume(10,22,30);
//...

//柯里化这个函数
function volume(h){
    return (l)=>{
        return (w)=>{
            return h*w*l;
        };
    };
}

//同求上一题
let tenHight = volume(10);
let v1 = tenHight(20)(30);
let v2 = tenHight(11)(21);
let v3 = tenHight(10)(22);
//若求高恒为40 那么:
let fthight = volume(40);
//若高长恒定则
let constHL = volume(10)(20);
```


# `Symbol`

## 它是什么？

> ES6加入的第七种基本类型，表示一个独一无二的值

```js
let s0 = Symbol("s0"); //传入字符串只是为了方便区别，以及控制台显示 

let s1 = Symbol(); //不能使用 new

let s2 = Symbol();

console.log(typeof(s1)) //Output:symbol

console.log(s1 === s2) //Output:false
```

## 其他

1. 不能是用 `new` 是因为一种原始类型，而非对象，所以也不能添加属性。

2. `Symbol` 作为对象属性时，放在 `[s]` 中只能通过 `obj[s]` 访问，其他的不变。

3. 可以作为全局唯一的定义。

4. `Symbol.for(string):string` 如果能找到便返回这个 `symbol`，否则就创建一个新的。

5. `Symbol.keyFor(symbol):string|undefined` 返回一个已登记的 Symbol 类型值的key。

6. 直接使用`Symbol()`创建的不会被登记，所以也就获取不到。


# `Promise`

> 所谓Promise，简单说就是一个容器，里面保存着某个未来才会结束的事件（通常是一个异步操作）的结果。

## 构造
```js
let p = new Promise((resolve,reject)=>{
    let value = Math.random()*2;
    if(value < 1){
        resolve("success");
    }else{
        reject("fail");
    }
});
/*
    带有 resolve 、reject两个参数的一个函数。这个函数在创建Promise对象的时候
    会立即得到执行（在Promise构造函数返回Promise对象之前就会被执行），并把成
    功回调函数（resolve）和失败回调函数（reject）作为参数传递进来。调用成功回
    调函数（resolve）和失败回调函数（reject）会分别触发promise的成功或失败。
    这个函数通常被用来执行一些异步操作，操作完成以后可以选择调用成功回调函数
    （resolve）来触发promise的成功状态，或者，在出现错误的时候调用失败回调函
    数（reject）来触发promise的失败
*/
p.then(result=>{
    //TODO
    //若执行成功将resolve的传入值作为参数
}).catch(reason =>{
    //TODO
    //若执行失败则将reject的传入值作为参数
});


new Promise((resolve,reject)=>{
    //TODO
}).then(value =>{
    return new Promise((resolve,reject)=>{
        //TODO
    };
}).then(value1 =>{
    //Promise 的连用
});

```
<!--more-->

>`Promise` 的状态
+ `pending`     初始状态
+ `fulfilled`   成功状态
+ `rejected`    失败状态


## 静态方法
+ `Promise.all`  
    ```js
    function asyncTask(num){
        return new Promise((resolve,reject)=>{
            setTimeout(()=>{
                resolve(num);
            },num);
        });
    }

    //同时进行多个Promise异步任务
    Promise.all([
        asyncTask(1);
        asyncTask(2);
        asyncTask(3);
        asyncTask(4);
    ]).then(values =>{
        // value是一个数组，其对应这任务传入顺序的值
    }).catch(reason =>{
        //只要有一个reject，那么后面的将不会再运行了
    });


    Promise.race([
        asyncTask(1);
        asyncTask(2);
        asyncTask(3);
        asyncTask(4);
    ]).then(value =>{
        //value是最先完成异步任务的resolve值，其他的将不会在继续执行
    }).catch(err =>{
        //如果最先完成的任务没有reject，那么就不会再reject了
    });
    

    //直接保证返回一个指定值，在下一次 EventLoop
    Promise.resolve("finished!");
    Promise.reject("error");
    ```

## `async/await`

1. `async` 是声明一个方法为异步，`await` 等待一个方法的返回值

2. `await` 必须写在 `async` 方法中，而 `await` 等待的不必是 `async` 方法

3. `async` 方法

    > `async` 函数（包含函数语句、函数表达式、Lambda表达式）会返回一个 `Promise` 对象，如果在函数中 `return` 一个直接量，`async` 会把这个直接量通过 `Promise.resolve()` 封装成 `Promise` 对象。

    ```js
    async function Async(){
        return 0;
    }
    Async().then((value) =>{
    //若Async函数没有返回值，则 value = undefined
    console.log(value);
    });
    console.log(Async());
    //Output:Promise{ 0 }
    ```

## `await` 的等待

> `await` 等待的是 `Promise` 的处理值和其他值

```js
async function Await(){
    let v1 = await (() =>{
        return 0;
    })();

    let v2 = await (async () =>{
        return 1;
    })();
    console.log(v1,v2);
}

Await();
console.log("done");
//Output: done -> 0,1
```

>当 `await` 等待返回值(普通函数的返回值或 `Promise` 的 `resolve` 的传入值), 其后面的代码将会阻塞(让出线程占用)，所以 `await` 必须在 `async` 里面

## `async/await` 的优势

> 处理 `then` 链,以及引用上一次的结果

```js
function takeLongTime(n) {
    return new Promise.resolve(() => {
        setTimeout(() => resolve(n + 200), n);
    });
}

function step1(n) {
    console.log(`step1 with ${n}`);
    return takeLongTime(n);
}

function step2(m, n) {
    console.log(`step2 with ${m} and ${n}`);
    return takeLongTime(m + n);
}

function step3(k, m, n) {
    console.log(`step3 with ${k}, ${m} and ${n}`);
    return takeLongTime(k + m + n);
}

//async/await 的实现
async function DoAsync(){
    let t0 = 1000;
    let time1 = await step1(t0);
    let time2 = await step2(t0,time1);
    let r = await step3(t0,time1,time2);
    console.log(`result:${r}`);
}

//Promise的实现
function DoPromise() {
    const t0 = 300;
    step1(t0).then(time2 => {
            return step2(t0, time2).then(time3 => [t0, time2, time3]);
        }).then(times => {
            const [t0, time2, time3] = times;
            return step3(t0, time2, time3);
        }).then(result => {
            console.log(`result is ${result}`);
            console.timeEnd("doIt");
        });
}
```

## `async/await` 处理异常
>`await` 命令后面的 `Promise` 对象，运行结果可能是 `rejected`,通过`try...catch` 抓取错误
```js
async function DoAsync(){
    try{
        let t0 = 1000;
        let time1 = await step1(t0);
        let time2 = await step2(t0,time1);
        let r = await step3(t0,time1,time2);
        console.log(`result:${r}`);
    }catch(err){
        //TODO
    }
}
```