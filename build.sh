# see https://zhuanlan.zhihu.com/p/105021100
rm -r ./docs

hugo -d docs

git add . 

git commit -m "update ${date}"

git push #origin master