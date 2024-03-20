#!bin/sh

rm /var/log/mysql/mysql-slow.log

mysqladmin flush-logs
