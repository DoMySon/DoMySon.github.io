---
title: Rsa
date: 2020-02-10
tags: ["Secret"]
categories: ["Algorithm"]
description: Hash算法
img: https://www.runoob.com/wp-content/uploads/2015/06/go128.png
toc: true
draft: true
---

# Rsa 

## 加密

密文 = 明文^E mod N

公钥 = (E,N)

## 解密

明文 = 密文^D mod N

私钥 = (D,N)

# Public Key

+ Head

-----BEGIN PUBLIC KEY-----

+ Body

base64.encode(public_key_string)

+ Tail

-----END PUBLIC KEY-----
