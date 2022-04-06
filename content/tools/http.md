---
title: Http
date: 2019-08-27
tags: ["Http"]
categories: ["Tools"]
description: Docker是一个好东西
img: https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=3775172144,3501685571&fm=58&bpow=500&bpoh=416
toc: true
draft: false
---


> `Http` 中一些常用 `Header` , [Content-Type](#Content-Type) 和 [StatusCode](#Status_Code)

<!--more-->

# Header

## Common Header

Name|Work|Example
:-:|:-:|:-:
`Cache-Control` |控制缓存行为|Cache-Control:no-cache
`Connection` |浏览器想使用的连接类型| `keep-alive`
`Date` |创建报文时间|Date: Tue, 25 Nov 2018 08:12:31 GMT
`Pragma` |报文指令|
`Via` |代理服务器相关|
`Transfer-Encoding` |传输编码|
`Upgrade` |要求协议升级到一个高级版本| Upgrade:HTTP/2.0
`Warning` |内容存在错误而发生警告|

## Request Header

Request|说明|示例
:-:|:-:|:-:
`Accept`|可接受响应类型|Accept:text/plain,text/plain
`Accept-Charset`|可接受字符类型|Accept-Charset:utf-8
`Accept-Encoding`|可接受响应内容编码方式|Accept-Encoding:gizp,default
`Accept-Language`|可接受的语言|
`Authorization`|资源认证信息|Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==
`Connection`|客户端想使用的连接联系|Connection:keep-alive、Connection:Upgrade
`Cookie`|服务器发送的Cookie|略
`Content-Length`|以8进制表示Body长度|Connect-Length:555
`Content-Type`|请求体`MIME`类型，用于`Post`和`Put`中|[参考 Content-Type](#Content-Type)
`Expect`|请求的特定的服务器行为|Expect: 100-continue
`User-Agent`|身份标识符|略
`Refer`|浏览器前一个页面|
`Range`|某个内容的一部分|
`Proxy-Authorization`|向代理服务器发送的验证信息|
`Max-Forwards`|限制可被代理及网关的转发次数|


## Response Header

Response|说明|示例
:-:|:-:|:-:
`Allow`|对某网络资源的有效的请求行为，不允许则返回405|Allow: GET, POST
`Content-Language`|响应体的语言|Content-Language: en,zh
`Content-Location`|请求资源可替代的备用的另一地址|Content-Location: /index.htm
`Content-MD5`|返回资源的MD5校验值|Content-MD5: Q2hlY2sgSW50ZWdyaXR5IQ==
`Content-Length`|响应体的长度|Connect-Length:555
`Content-Encoding`|web服务器支持的返回内容压缩编码类型。|Content-Encoding: gzip
`Content-Type`|请求体`MIME`类型，用于`Post`和`Put`中|[参考 Content-Type](#Content-Type)
`Expires`|响应过期的日期和时间|Expires: Thu, 01 Dec 2010 16:00:00 GMT
`Last-Modified`|请求资源的最后修改时间|Last-Modified: Tue, 15 Nov 2010 12:45:26 GMT
`Set-Cookie`|设置Http Cookie|Set-Cookie: UserID=JohnDoe; Max-Age=3600; Version=1
`Transfer-Encoding`|文件传输编码|Transfer-Encoding:chunked
`Location`|重新定向到某个URL|

# Content-Type

|Type|描述|
|:-:|:-:|
|multipart/form-data|需要在表单中进行文件上传时，就需要使用该格式|
|text/plain|纯文本格式|
|application/octet-stream|二进制流数据（如常见的文件下载）|
|image/png|png图片格式|
|application/pdf|pdf格式|
|image/jpeg|jpg图片格式|
|image/gif|gif图片格式|
|application/x-www-form-urlencoded|form表单数据被编码为key/value格式发送到服务器（表单默认的提交数据的格式）|
|text/xml|XML格式|
|application/xml|XML数据格式|
|application/xhtml+xml|XHTML格式|
|application/msword|Word文档格式|
|application/json|JSON数据格式|
|text/html;charset=utf8|HTML格式|
|application/atom+xml|Atom XML聚合格式|

# Status_Code

Code|描述
:-:|:-:
200|`OK` 从客户端发来的请求在服务器端被正确处理
204|`No Content` 请求成功，但响应报文不含实体的主体部分
205|`Reset Content` 请求成功，但响应报文不含实体的主体部分，但是与 204 响应不同在于要求请求方重置内容
206|`Partial Content` 进行范围请求
301|`Moved Permanently` 永久性重定向，资源已被分配了新的 URL
302|`Found` 临时性重定向，资源临时被分配了新的 URL
303|`See Other` 资源存在着另一个 URL，应使用 GET 方法获取资源
304|`Not Modified` 服务器允许访问资源，但因发生请求未满足条件的情况
307|`Temporary Redirect` 临时重定向，和302含义类似，但是期望客户端保持请求方法不变向新的地址发出请求
400|`Bad Request` 原因在于客户端参数不正确
401|`Unauthorized` 送的请求需要有通过 HTTP 认证的认证信息
403|`Forbidden` 服务器拒绝此次请求
404|`Not Found` 服务器上没有找到请求的资源
405|`Method Not Allowed` 请求方法不允许
408|`Request Timeout` 请求超时
411|`Length Required` 由于客户端没添加 `Content-Length`，服务器拒绝
423|`Locked` 资源被锁定
426|`Upgrade Required` 服务器返回提示客户端切换到 TLS/SSL 传输协议
429|`Too Many Requests` 同一时间同一用户发送了过多的请求
431|`Request Header Fields Too Large`  由于 `Header` 过大，服务器拒绝请求
444|`No Response` 服务接收但不回应
500|`Internal Server Error` 服务器端在执行请求时发生了错误
501|`Not Implemented` 服务器不支持当前请求所需要的某个功能
502|`Bad Gateway` 代理服务器不能从上游服务器获取数据时
503|`Service Unavailable` 服务器暂时处于超负载或正在停机维护，无法处理请求
504|`Gateway timeout` 代理服务器未能及时从上游服务器获取回应