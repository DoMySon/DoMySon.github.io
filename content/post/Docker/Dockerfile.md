---
title: Dockerfile
date: 2019-03-12
tags: ["Docker","Dockerfile"]
categories: ["Docker"]
description: Dockerfile是一个好东西
img: https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=3775172144,3501685571&fm=58&bpow=500&bpoh=416
toc: true
draft: false
---

# Dockerfile

> `Dockerfile` 是一个包含用于组合映像的命令的文本文档。可以使用在命令行中调用任何命令。 Docker通过读取Dockerfile中的指令自动生成映像。`docker build` 命令用于从 `Dockerfile`构建映像。命令中使用 `-f` 标志指向文件系统中任何位置的 `Dockerfile` 文件。

<!--more-->
## FROM

> 指定基础镜像
    
`FROM <image>:<tag>`

```dockerfile
FROM node:10.14.2
# tag为可选项，如果没有指定，默认为latest
# 指定基础，FROM必须作为第一个指令，若镜像不存在则会下载，如果不以任何镜像为基础，则写法为：FROM scratch，意味着接下来的指令作为第一层镜像的开始。
```

## MAINTAINER 

> 镜像作者 已过时，用  [Label](#LABEL) 代替

~~`MAINTAINER <name>`~~
   
```dockerfile
#MAINTAINER Treasure
LABEL maintainer=Treasure
```

## ADD、COPY

> ADD、COPY目标文件夹若不存在会自动创建。ADD指令包含类似tar的解压功能，而COPY只单纯复制文件，而且路径不能是url。ADD和COPY只能复制文件，若碰到文件夹只会复制其中的文件。`dst` 只能是目标容器的绝对位置。 所有拷贝到容器中的文件和文件夹权限为 `0755`，uid和gid为0；如果是一个目录，那么会将该目录下的所 有文件拷贝到目录下，不包括目录；如果是文件且中不使用斜杠结束，则会将视为文件，则内容会写入；如果是文件且中使用斜杠结束，则会文件拷贝到目录下。 

`ADD src ... dst` 

`COPY src ... dst`

```dockerfile
ADD ./* /data

COPY ./ /data
```

## WORKDIR

> 将会设置 RUN、CMD、ENTRYPOINT指定的工作目录,相当于切换目录至path

`WORKDIR path`

```dockerfile
WORKDIR /app    #工作目录为 /app

WORKDIR gateway #工作目录为 /app/gateway
```

## USER

> 指定运行容器的用户

```dockerfile
USER root
```

## LABEL

>为镜像指定标签，LABEL会继承基础镜像中的LABEL，如遇到key相同，则会被覆盖。

```dockerfile
LABEL <key>=<value> <key>=<value> ...

LABEL <key>=<value> \
    <key>=<value>
```

## ENV

> ENV指令用来定义镜像的环境变量，在Dockerfile中这些设置的环境变量也会影响到RUN指令，当运行生成的镜像时这些环境变量依然有效，如果需要在运行时更改这些环境变量可以在运行docker run时添加–e <key>=<value>参数来修改。可以通过 docker inspect 查看环境变量。其他命令通过 $EVNNAME 来引用,最好不要定义那些可能和系统预定义的环境变量冲突的名字，否则可能会产生意想不到的结果。

``` dockerfile
ENV HOST=0.0.0.0 PORT=8000 #可以设置多个,但`=`两侧不允许有空格

ENV A1=Treasure \
    A2=DoMySon

WORKDIR ${foo} #引用ENV设置的变量
```

## EXPOSE

> 功能为暴漏容器运行时的监听端口给外部（只允许能被连接的服务访问）,但是EXPOSE并不会使容器访问主机的端口,如果想使得容器与主机的端口有映射关系，必须在容器启动的时候加上 `-p` 参数

``` dockerfile
EXPOSE 8000 3306 

EXPOSE 80

EXPOSE 5433/tcp 5434/udp
```


## VOLUME

> 可实现挂载功能，可以将本地文件夹或者其他容器种得文件夹挂在到这个容器中，若目标文件夹或文件不存在则创建

```dockerfile
VOLUME ["path1","path2"] #主机上的挂点是随即生成的 

VOLUME /var/log /var/db #挂载多个
```


## RUN

> 在容器中构建时执行的命令，RUN指令创建的中间镜像会被缓存，并会在下次构建中使用。如果不想使用这些缓存镜像，可以在构建时指定--no-cache参数：`docker build --no-cache`

```dockerfile
RUN npm install                         #使用 shell 执行

RUN ["executable","param1","param2"]    #使用可执行程序执行 
```

## CMD

> 功能为容器启动时要运行的命令CMD指令中指定的命令会在镜像运行时执行，在Dockerfile中只能存在一个，如果使用了多个CMD指令，则只有最后一个CMD指令有效。当出现ENTRYPOINT指令时，CMD中定义的内容会作为ENTRYPOINT指令的默认参数，也就是说可以使用CMD指令给ENTRYPOINT传递参数。`RUN`和`CMD`都是执行命令，他们的差异在于`RUN`中定义的命令会在执行`docker build`命令创建镜像时执行，而`CMD`会在`docker run`时执行。

```dockerfile
CMD npm install                         #使用 shell 执行

CMD ["executable","param1","param2"]    #使用可执行程序执行 
```

## ENTRYPOINT

> 功能是启动时的默认命令，与 `CMD` 相似，如果有多条则最后一条生效。但ENTRYPOINT不会被command覆盖，而 CMD 则会被覆盖。

```dockerfile
ENTRYPOINT ["exec","param1","param2"]

ENTRYPOINT command
```

## USER

> 设置启动容器的用户，可以是用户名或UID,如果设置了容器以daemon用户去运行，那么 RUN, CMD 和 ENTRYPOINT 都会以这个用户去运行

```dockerfile
USER daemo

USER UID
```


## ARG

> 设置变量命令，ARG命令定义了一个变量，在 docker build 创建镜像的时候，使用 --build-arg <varname>=<value>来指定参数，如果用户在build镜像时指定了一个参数没有定义在Dockerfile中，那么将有一个 Warning

```dockerfile
ARG <name>[=<default_value>]

ARG user1=10 #默认值变量

ARG build #不带默认值变量
```

## ONBUILD

> 这是一个特殊的指令，它后面跟的是其它指令，比如 RUN , COPY等，而这些指令， 在当前镜像构建时并不会被执行。只有当以当前镜像为基础镜像，去构建下一级镜像的时候才会被执行。
