---
title: Docker-Compose
date: 2019-11-25
tags: ["Docker","DockerCompose"]
categories: ["Docker"]
description: Dockerfile是一个好东西
img: https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=3775172144,3501685571&fm=58&bpow=500&bpoh=416
toc: true
draft: false
---

> `Docker-Compose` （docker编排）是 docker 提供的一个命令行工具，用来定义和运行由多个容器组成的应用。可以通过 docker-compose.yml 文件声明式的定义应用程序的各个服务，并由单个命令完成应用的创建和启动。

> [官方文档](https://docs.docker.com/compose/)


`Docker-Compose`将所管理的容器分为三层，分别是工程（project），服务（service）以及容器（container）。Docker-Compose运行目录下的所有文件（docker-compose.yml，extends文件或环境变量文件等）组成一个工程，若无特殊指定工程名即为当前目录名。一个工程当中可包含多个服务，每个服务中定义了容器运行的镜像，参数，依赖。一个服务当中可包括多个容器实例，Docker-Compose并没有解决负载均衡的问题，因此需要借助其它工具实现服务发现及负载均衡。

<!--more-->

# docker-compose 命令

## docker-compse up [opthions] [--scale SERVICE=NUM] [SERVICE...]

> 容器启动命令

+ `-d`：在后台运行

+ `–no-color` 不使用颜色来区分不同的服务的控制输出

+ `–no-deps` 不启动服务所链接的容器

+ `–force-recreate` 强制重新创建容器，不能与`–no-recreate`同时使用

+ `–no-recreate` 如果容器已经存在，则不重新创建，不能与`–force-recreate`同时使用

+ `–no-build` 不自动构建缺失的服务镜像

+ `–build`：在启动容器前构建服务镜像，或rebuild

+ `–abort-on-container-exit`：停止所有容器，如果任何一个容器被停止，不能与 `-d` 同时使用

+ `–scale SERVICE=NUM ...` 设置服务运行容器的个数，将覆盖在compose中通过scale指定的参数

## docker-compose ps [SERVICE...]

> 查看 `docker-compose` 中列出的容器

## docker-compose [start|stop|restart]

> [开始|停止|重启]项目中运行的容器

# docker-compose 文件结构

>Docker-Compose标准模板文件应该包含version、services、networks 三大部分，最关键的是services和networks两个部分。

```yaml
version: "3.5"                  #docker-compose 版本,不同的版本配置有所不同
service:
  nats:                         #标识,如果设置了网络，这个也是他在网络中的别名，也可以指定alias
    image: nats:latest          #如果本地不存在就会在dockerhub上拉取
    container_name: "nats0"     #运行时的容器名
    ports:                      #端口与宿主机映射规则
      - "4222:4222"
      - "6222:6222"
      - "8222:8222"
    expose:                     #暴露容器端口，仅仅是声明，不会起实际作用，参考 Dockerfile
      - "4222"
      - "8222"
      - "6222"
    networks:                   #链接的网络，不存在会自动创建，必须在services同级的networks中指定
      - net1                    #指定连接的网络名
      - net2                    


  gate:
    image: gateway
    build: "./gateway"          #如果此镜像是自定义镜像，需要指定dockerfile文件的目录，将不会拉取远程镜像
    container_name: "gateway"
    command: sh run.sh          #覆盖容器的默认执行命令
    depends_on:                 #指定依赖的启动项，即先启动 nats 再启动此镜像
      - nats
      - login
    ports:
      - "5433:5433"
    expose:
      - "5433"
    networks:
      net1:
        ipv4_address: 172.18.0.31 #指定容器的固定ipv4地址

  login:
    image: login
    build: "./login"
    container_name: "login"
    ports:
      - "5434:5434"
    expose:
      - 5433
    networks:
      - net1
  db:
    image: db
    build: "./db"
    container_name: "db"
    networks:
      - net1
    volumes:
      - /var/etc/:/var/etc/     #容器卷映射


networks:
  net1:
    name: xNet                  #虚拟网卡名 version >=3.5
    driver: bridge              #支持三种模式 host bridge(默认) none
  net2:
    name: yNet
    driver: host
```