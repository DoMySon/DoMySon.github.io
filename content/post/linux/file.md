



# Liunx 文件系统

> 对于 `drwxr-xr-x 4 root root 4096 Nov 28 00:00 hook`




## 文件类型

符号|描述
:-:|:-:
d|目录
l|符号链接
s|套接字文件
b|块设备文件
c|字符设备文件
p|命名管道文件
-|普通文件，不属于上述任意一种


## 权限更换

> `chmod [who] operator [permission] filename`


+ who

    符号|描述
    :-:|:-:
    u|文件属主权限
    g|同组用户权限
    o|其他用户权限
    a|所有用户

+ operator

    符号|描述
    :-:|:-:
    +|增加权限
    -|取消权限
    =|设定权限
    
+ permission

    符号|描述
    :-:|:-:
    r|读权限
    w|写权限
    x|执行权限