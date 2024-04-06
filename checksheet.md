## チェックリスト

### 初期状態のバックアップ取得
- rootユーザーで実行
```title:$
sudo su -
```

- [ ] ~~tarで全部丸めてバックアップを取得する~~
```title:#
nohup tar czvfp /root/initial.tar.gz --exclude /var --exclude /proc --exclude /root --exclude /lib / &
```
- 上記うまく以下ないので
```
tar czvfp /root/initial_etc.tar.gz /etc
```
```
tar czvfp /root/initial_home.tar.gz /home
```

- ~~tarファイルの中身確認~~
```tilte:#
tar -ztfv /root/initial.tar.gz
```

- [ ] DBダンプファイルを作成する
- mysqlの場合
```title:#
mysqldump -u root -h 127.0.0.1 -p > /root/initial_mysql.dump
```
- postgresqlの場合
```tilte:#
nohup pg_dumpall -h 127.0.0.1 -p 5432 <db name> > /root/initial_postgresql.dump &
```

##### もしもの時の復旧
- tarファイルの解凍
```title:#
nohup tar xzvfp /root/initial.tar.gz &
```
解凍後はcpコマンドなどで対象のファイルを持っていけばおそらく大丈夫

- ダンプファイルの反映
- mysqlの場合
```title:#
mysql -u root -h 127.0.0.1 <db name> < /root/initial_mysql.dump
```

- postgresqlの場合
```title:#
pg_restore -h 127.0.0.1 -p 5432 -d <db name> /root/initial_postgresql.dump
```

### 
