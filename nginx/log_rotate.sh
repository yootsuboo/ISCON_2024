#!bin/sh

# nginx access.log ローテーション
mv /var/log/nginx/access.log /var/log/nginx/access.log.`date +%Y%m%d-%H%M%S`

nginx -s reopen

# mysql mysql-slow.log ローテーション
rm /var/log/mysql/mysql-slow.log

mysqladmin flush-logs

