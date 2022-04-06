---
title: Go标准命令
date: 2020-01-28
tags: [""]
categories: ["Go"]
description: go 内置命令
img: https://www.runoob.com/wp-content/uploads/2015/06/go128.png
toc: true
draft: false
---

Go源码文件包括：命令源码文件、库源码文件和测试源码文件。其中，命令源码文件总应该属于main代码包，且在其中有无参数声明、无结果声明的main函数。单个命令源码文件可以被单独编译，也可以被单独安装

<!--more-->

# go build


> 该命令会把带 `main` 包源码编译生成的文件放在该命令的执行目录下，否则视为库文件。如果同一个目录存在两个 `main` 文件，那么需要使用 `go build a.go b.go`

参数|描述
:-:|:-:
-o|指定生成文件的路径
-v|编译时显示被编译的包名
-a|强制重构
-x|打印编译期间所用到的命令
-race|开启竞态条件检测
-work|打印生成的临时目录，并保留它，默认是编译结束后删除

+ `-buildmode`：
    >指定编译模式

    + archive：将不包含 `main` 包的 `package` 生成 `.a` 文件
      
    + c-archive：将列出的主包以及它导入的所有包构建到一个C存档文件中。唯一可调用的符号将是那些使用 `export 注释` 导出的函数。需要列出一个主包。

    + shared：将所有列出的非主包合并到一个共享库中 `.so 或 .dll`，当使用`-linkshared` 选项构建时将使用该库。名为main的包将被忽略。`windows/amd64` 不支持，需要导入 `import "C"`
    
    + c-shared：同上，不同的是必须有一个 `main` 包。唯一可调用的符号将是那些使用 `export 注释` 导出的函数。需要列出一个主包。

    + default、exe：默认包含主包，生成一个可执行文件

    + plugin：作为插件的形式存在，只能被go调用，而且必须要有主包

+ `-ldflags`

    > 传给链接程序的标志

    + `-w`：去掉调试信息，不能gdb调试

    + `-s`：去掉符号表，stack trace 将没有任何文件名/行号信息，这个在`mac`平台下无效

    + `-X`：设置 `importPath package` 中变量的值。实际上应当跟代码中的导入路径一致 

    + `-H windowsgui`：在windows下隐藏黑框

    ```
    go build -ldflags "-w -s -X main.Verison=1.0.1 -X main.Name=treasure" -o xxx main.go
    ```


+ `-tags`

    > 此标记用于指定在实际编译期间需要受理的编译标签（也可被称为编译约束）的列表。

    ### 条件编译

    >条件编译解决的是一份代码在不同的编译平台以及不同的语言版本的兼容性问题。

    ### 编译标签
    Desc|Logic
    :-:|:-:
    空格 ' '|OR
    逗号 ','|AND
    感叹号 '!'|NOT
    换行|OR

    ```go
    // +build linux,amd64 darwin,!cgo,go1.13
    ```
    > 上述综合起来就是： `(linux AND amd64) OR (darwin AND (NOT cgo)) AND GO_Version>=1.13`

    ### 文件后缀的形式

    1. *_GOOS.go
    2. *_GOARCH.go
    3. *_GOOS_GOARCH.go


    ### 交叉编译

    > 交叉编译解决的是在不同 `OS` 和 `ARCH` 上运行程序

    ```
    [-CGO_ENABLED=0] GOOS=platform GOARCH=arch go [build|install] any.go
    ```

    > ~~CGO_ENABLED=0 表示不使用`CGO`编译器，1.9版本这个默认取消了，而且交叉编译不支持`CGO`。实际上如果在go当中使用了C的库，比如`import "C"`默认使用go build的时候就会启动CGO编译器。~~

    + GOOS:目标操作系统
    + GOARCH目标操作系统架构

    OS|ARCH|OS Version
    :-:|:-:|:-:
    linux|386/amd64/arm|>=linux2.6
    darwin|386/adm64|OS X
    windows|386/amd64|>=win2000`

    ```go
    // +build debug !int

    //只要不带 int 并且 tags 指定为 debug 都会被编译
    package main
    ```

    ```
    go build -tags "debug int"
    ```

+ `-gcflags`

    > 此标记用于指定在实际编译期间需要受理的编译标签（也可被称为编译约束）的列表。

    

# go install

> 当指定的代码包的依赖包还没有被编译和安装时，该命令会先去处理依赖包。`go install` 命令只比 `go build` 命令多做安装编译后的结果文件到指定目录。

+ `go install` 会依次查找所有 `GOPATH` 中的目录并寻找相关依赖包，然后将包名为 `main` 的包生成平台可执行文件放到 `GOBIN` 下，将非`main` 包编译成 `.a` 文件放在项目的 `pkg` 下。

+ `go install` 会自动检测代码更新，如果有变化则重新编译。可以加上 `-x` 会输出 `go install` 中实际执行的命令。

    > 但是对于其他文件夹下的其他依赖包，如果发现 `.a` 文件，则不会重新编译。


1. `-a` 参数强制编译所有包，包括依赖包。

2. `go install ./dirname/...` 强制编译 `dirname` 下所有包。

3. 删除对应 `.a` 文件。

> `go install` 只会检查“参数指定的包所在的 `GOPATH` 内的源码是否有更新，如果有则重新编译。对于依赖的其他 `GOPATH` 下的包，如果存在已经编译好的 `.a `文件，则不会再检查源码是否有更新，不会重新编译。


# go tool command

## go tool compile

> 包必须为 `src`,也必须存在 `pkg`，否则无法生成 `.a` 文件，`go build` 命令已经集成了 `编译、链接、运行` 几个步骤，如果需要手动指定 `.a` 文件那么需要手动执行前两个步骤。

1. `go tool compile -I your_path main.go`：-I选项指定了demo包的安装路径，供main.go导入使用，编译成功后会生成相应的目标文件main.o。

2. `go tool -o main.exe -L your_path main.o`：-L选项指定了静态库demo.a的路径，链接成功后会生成相应的可执行文件main.exe。

3. `go tool compile -S main.go：生成汇编文件。

# go list

>  作用是列出指定的代码包的信息

1. `-e`:

2. `-json`:

# go run

> 编译并执行，只能作用于命令源码文件，一般用于开发中快速测试。但也执行了编译操作，所以与 `go build` 共用参数。

# go clean

> 执行该命令会删除掉执行其它命令时产生的一些文件和目录

+ `go build` 产生的可执行文件

+ `go test` 附带 `-c` 参数产生的文件


# go test

>进行单元测试的工具，单元测试代码建议与被测试代码放在同一个代码包中，并以 `_test.go` 为后缀，测试函数建议以 `Test` 为名称前缀。该命令可以对代码包进行测试，也可以指定某个测试代码文件运行

[Go单元测试](/2019/08/Go单元测试)


# go get

> 以借助代码管理工具通过远程拉取或更新代码包及其依赖包，并自动完成编译和安装。如 `go get [-options] github.com/golang/go`

参数|描述
:-:|:-:
-v|显示执行命令
-u|强制更新包和其以来，默认只会下载本地不存在的依赖
-d|只下载不安装
-insecure|允许使用不安全的 `http` 方式下载，在内网有用
-f|仅在包含了 `-u` 参数才有效，对当前语言版本的不规范检查并修正，然后再下载依赖包，最后编译安装
-fix|让命令程序在下载代码包后先执行修正动作，而后再进行编译和安装
-t|让命令程序同时下载并安装指定的代码包中的测试源码文件中依赖的代码包

# go generate

> 当运行该命令时，它将扫描与当前包相关的源代码文件，找出所有包含//go:generate的特殊注释，提取并执行该特殊注释后面的命令。

+ 该特殊注释必须在 .go 源码文件中

+ 每个源码文件可以包含多个 generate 特殊注释

+ 运行go generate命令时，才会执行特殊注释后面的命令

+ 当go generate命令执行出错时，将终止程序的运行

+ 特殊注释必须以 `//go:generate` 开头，双斜线后面没有空格。


## 命令格式
> go generate [-run regexp] [-n] [-v] [-x] [command] [build flags] [file.go... |packages]

参数|描述
:-:|:-:
-x|显示并执行命令
-n|显示不执行命令
-v|显示处理的包和源文件
-run|仅运行正则匹配到的命令

```go
package main

//go:generate go run main.go
//go:generate go version
func main(){
}
```

# go doc


# go fmt

> 格式化`.go`脚本

# go fix


# go tool vet 

> 检查逻辑错误，而非编译错误，也可以自定义检查



