echo yes|git pull
cd /blog/hugo
nohup hugo_unix -w &
nohup hook & 
#service nginx start
nginx -c /blog/nginx/nginx.conf -g "daemon off;"
#fix to LF