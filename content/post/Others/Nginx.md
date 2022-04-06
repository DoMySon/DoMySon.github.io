---
title: Nginx
date: 2019-03-09
tags: ["Web","Proxy"]
categories: ["Nginx"]
description: 高性能web代理
img: https://www.runoob.com/wp-content/uploads/2015/06/go128.png
toc: true
draft: false
---

# 简介

> Nginx功能丰富，可作为HTTP服务器，也可作为反向代理服务器，邮件服务器。支持FastCGI、SSL、Virtual Host、URL Rewrite、Gzip等功能。并且支持很多第三方的模块扩展。

[Nginx下载](http://nginx.org/en/download.html)

# 常用功能

+ 负载均衡

+ 反向代理

+ 正向代理

+ 文件服务器

<!--more-->

# Nginx命令

+ `nginx -s [reload|start|stop|quit]` 向nginx发送一个信号

+ `nginx -c path` 指定nginx启动配置，`linux` 默认在 `/etc/nginx/nginx.conf` 下

+ `nginx -g "daemon off;"`  不以守护进程的方式启动，这点在 `docker` 中特别重要，默认是以守护进程的方式启动


# Nginx正向代理

```nginx
server {
    # 配置DNS解析IP地址，比如 Google Public DNS，以及超时时间（5秒）
    resolver 8.8.8.8;    # 必需
    resolver_timeout 5s;

    # 监听端口
    listen 8080;

    access_log  /home/reistlin/logs/proxy.access.log;
    error_log   /home/reistlin/logs/proxy.error.log;

    location / {
        # 配置正向代理参数
        proxy_pass $scheme://$host$request_uri;
        # 解决如果URL中带"."后Nginx 503错误
        proxy_set_header Host $http_host;

        # 配置缓存大小
        proxy_buffers 256 4k;
        # 关闭磁盘缓存读写减少I/O
        proxy_max_temp_file_size 0;
         # 代理连接超时时间
        proxy_connect_timeout 30;

        # 配置代理服务器HTTP状态缓存时间
        proxy_cache_valid 200 302 10m;
        proxy_cache_valid 301 1h;
        proxy_cache_valid any 1m;
    }
}
```

> 添加环境变量  **http_proxy=http://192.168.1.9:8080**  unix系统需要重新  `source /etc/profile` 来应用环境变量



# Nginx文件服务器

```nginx

#增加一个 server 模块

server{

    listen       8080;
    server_name  8.8.8.8;
    charset utf-8; #设置编码，防止乱码
    #root         /usr/share/nginx/html;
    root         /data/;
    location / {
        autoindex on;               #显示目录

        autoindex_exact_size on;    #显示文件大小

        autoindex_localtime on;     #显示文件时间

        auth_basic "treasure";     #密码提示短语

        auth_basic_user_file /blog/nginx/htpasswd; #认证密码访问路径
    }

    error_page 404 /40x.html;
    
    location = /40x.html {

    }
}
```

# nginx.conf

```nginx
#user  nobody;                          #运行用户，可不设置
worker_processes  1;                    #工作进程，一般为cpu荷属

#error_log  logs/error.log;             #日志文件路径，后面是日志等级
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;             #进程pid文件路径


events {
    use epoll;                          #epoll是多路I/O复用，可极大提高性能，select,poll,kqueue

    accept_mutex on;                    # 连接互斥，防止惊群现象

    multi-accept on;                    # 进程接收多个连接

    worker_connections  1024;           #单个worker最大的并发数
}


http {
    include       mime.types;           #文件拓展名映射表

    default_type  application/octet-stream; #默认文件类型

    log_format  format  '$remote_addr - $remote_user [$time_local] "$request" '
                     '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

                                        #日志格式

    #access_log  logs/access.log  format;

    sendfile        on;                     # 允许sendfile方式传输文件，默认为off，可以在http块，server块，location块
           
    sendfile_max_chunk 100k;                #每个进程每次调用传输数量不能大于设定的值，默认为0，即不设上限

    #tcp_nopush     on;                     # 默认关闭，关闭 nagle 算法，同 sendfile 一起使用

    #tcp_nodelay    on;                     # 与 tcp_nopush互斥

    keepalive_timeout  65;                  # 连接超时时间，单位s


    #----------------- gzip --------------------#

    #gzip  on;                                  #开启 gzip压缩功能

    #gzip_min_length 1k;                        #允许最小压缩字节数，建议大于1k

    #gzip_buffers 4 32k;                        #分配4块大小为32k的缓冲块

    #gzip_http_version 1.0;                     #gzip版本

    #gzip_comp_level 8;                         #压缩等级 0~9
    
    #gzip_types         text/plain application/x-javascropt text/css application/xml #使用gzip压缩的类型

    #gzip_vary on;

    error_page 404 http://xxxxx.yyy;             # http全局错误页

    upstream serverName{
        server 8.8.8.8:80 weight=1 max_fails=2 fail_timeout=30s;

        server 0.0.0.0:81 backup; #热备

        #若只有一个负载服务器，则不能设置权重，最大失败数为2，超过则认为主机不可用，
        #30s表示两次连接失败的超时时间间隔

        # ll+weight：轮询加权算法，默认
        
        # ip_hash: 哈希算法，可能使部分服务器负载变大

        # least_conn: 最少链接，优先分配

        # least_time: 相应最快的权重越大
    }
                                                      

    server {
        listen       80;                                #监听端口
        server_name  localhost;                         #监听地址或域名

        #root                                           #此server块全局资源路径
        #index index.html  index.htm                    #此server块全局索引界面,首页排序

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        #error_page 404 405 /40x.html
        #error_page 500 502 503 504 /50x.html           #server全局错误页面定向到location

        location / {
            root   html;
            index  index.html index.htm;
            error_page 404 405 /50x.html #错误页面定向到其他 location
        }

        location /proxy/ {
           proxy_pass http://1.1.1.1:80/proxy/;        #代理网址
           proxy_set_header Host $host;                #代理网站域名
           proxy_set_header X-Real-IP $remote_addr;    #远程地址
           proxy_set_header X-Forwarded-For $proxy_add-x_forwarder_for;
        #

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}

        #location ~.*\.(js|css)?$ {
            #expires 30d;                   #客户端缓存js,css 30天
            #access_log off;                #关闭日志
        #}

        #location /resources/ {
            #deny all;              #禁止所有ip访问
            #allow 4.4.4.4;
            #aloow 5.5.5.5;         #允许访问的ip
        #}
    }


    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}


    # HTTPS server
    #
    #server {
    #    listen       443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}
}
```

# 路径匹配规则

> 访问  `http://treasure.com/abc/index.html`

```nginx

location /abc/ {
    proxy_pass http://treasure.com/; # 有 / 后缀会被location 截断
    #将代理成 http://treasure.com/index.html
}


location /abc/ {
    proxy_pass http://treasure.com; # 无 / 后最会被完整转发
    #将代理成 http://treasure.com/abc/index.html
}

location / {
    #通用匹配 任何请求都会被捕获
}

location ^~ /res/ {
    # 匹配任何以 /res/ 开头的URL，并停止向下搜索，任何正则表达式不会被测试
}
```

# 防盗链

> http标准协议中有专门的字段记录 `referer`，他可以追溯到请求时从哪个网站链接过来的，来对于资源文件，可以跟踪到包含显示他的网页地址是什么。因此所有防盗链方法都是基于这个Referer字段，nginx防盗链是通过分析访问资源的源网站，即referer来自哪里

```nginx
location ~* \.(gif|jpg|png|bmp)$ {

    valid_referers none blocked a.b.c a1.b1.c1
    #如果浏览器直接打开img的url，这时候是没有referer的，如果容许这一类，那么配置valid_referers可以包括none

    #如果referer不为空，但是里面的内容被防火墙或者代理服务器删除了，也容许这一类的话，可以通过配置blocked来绕过。

    # 容许来自指定网站的请求
    if ($invalid_referer) {

        return 403;

        #rewrite ^/ http://www.any.com/403.jpg;
    }
}
```

# 高速缓存

> Nginx可以缓存一些文件（一般是静态文件），减少Nginx与后端服务器的IO，提高用户访问速度。而且当后端服务器宕机时，Nginx服务器能给出相应的缓存文件响应相关的用户请求。


# 第三方模块编译

待完善