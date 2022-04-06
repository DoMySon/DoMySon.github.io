---
title: DockerNetwork
date: 2020-01-02
tags: ["Docker","Network"]
categories: ["Docker"]
description: Dockerfile是一个好东西
img: https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=3775172144,3501685571&fm=58&bpow=500&bpoh=416
toc: true
draft: false
---

# Docker Network

> `Docker` 在安装时候，默认创建三个网络 `bridge（默认）`,`none`,`host`。

> `docker network create --driver [bridge|host|none|container] networkname`

+ `bridge`：默认模式，容器使用独立 network Namespace，并连接到`docker0`虚拟网卡（默认模式）。通过该网桥以及Iptables nat表配置与宿主机通信，此模式会为每一个容器分配Network Namespace、设置IP等，并将一个主机上的容器连接到同一个网桥 `docker0` 中。

+ `host`：与宿主机共享网络，此时容器没有使用网络的namespace，`-p` 将不会起任何作用。

+ `container`：新创建的容器和已经存在的一个容器共享一个Network Namespace,新创建的容器不会创建自己的网卡，配置自己的IP，而是和一个指定的容器共享IP、端口范围等。同样，两个容器除了网络方面，其他的如文件系统、进程列表等还是隔离的。两个容器的进程可以通过lo网卡设备通信。

+ `none`：该模式将容器放置在它自己的网络栈中，但是并不进行任何配置。实际上，该模式关闭了容器的网络功能，在以下两种情况下是有用的：容器并不需要网络（例如只需要写磁盘卷的批处理任务）。

+ `container`：与指定的容器共享网络，如果有的话。

<!--more-->

# 容器连接

1. 通过 `docker network ls` 查看网络信息。

2. 运行容器时通过 `--network=[networkname]` 指定连接的网络（未测试是否可以同时连接多个）。若不指定则默认连接到 `bridge` 网络。 也可以同过 `--net=[networkmode]` 指定网络的模式。同时通过 ``。

    + --net=host
    
    + --net=none

    + --net=bridge

    + --net=container




# Docket 跨主机通讯

## 自己yy

两个宿主机的容器映射到宿主机的端口，然后通讯。

## overlay