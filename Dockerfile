FROM centos:7

#MAINTAINER Treasure
LABEL maintainer="Treasure"
COPY ./ /blog
COPY ./webhook/hook /usr/bin/
COPY ./webhook/hugo_unix /usr/bin/

ENV version=5.x CONF=/blog/webhook/hook.json

WORKDIR /blog

RUN yum update -y && \
    rpm -ivh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm && \
    yum install -y nginx && \
    yum install -y git && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

EXPOSE 80

CMD /blog/run.sh

## 基于系统构建一个新的镜像·