# see https://zhuanlan.zhihu.com/p/105021100
hugo -d docs

git add . 

git commit -m "update ${date}"

git push #origin master