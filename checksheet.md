## チェックリスト

### 初期状態のバックアップ取得
- rootユーザーで実行
```title:$
sudo su -
```
- ディレクトリの作成
```title:#
mkdir /work
```

- [ ] ~~tarで全部丸めてバックアップを取得する~~
```title:#
nohup tar czvfp /work/initial.tar.gz --exclude /var --exclude /proc --exclude /root --exclude /lib / &
```
- 上記うまく以下ないので
```
tar czvfp /work/initial_etc.tar.gz /etc
```
```
tar czvfp /work/initial_home.tar.gz /home
```
```
tar czvfp /work/initial_usr.tar.gz /usr
```


- ~~tarファイルの中身確認~~
```tilte:#
tar -ztfv /work/initial.tar.gz
```

- [ ] DBダンプファイルを作成する
- mysqlの場合
<!-- mysqldump -h 127.0.0.1 -u isuconp isuconp -pisuconp > /work/initial_mysql.dump -->
```title:#
mysqldump -h 127.0.0.1 -u <user name> <db name> -p > /work/initial_mysql.dump
```
- postgresqlの場合
```tilte:#
nohup pg_dumpall -h 127.0.0.1 -p 5432 <db name> > /work/initial_postgresql.dump &
```

##### もしもの時の復旧
- tarファイルの解凍
```title:#
nohup tar xzvfp /work/initial.tar.gz &
```
解凍後はcpコマンドなどで対象のファイルを持っていけばおそらく大丈夫

- ダンプファイルの反映
- mysqlの場合
```title:#
mysql -h 127.0.0.1 -u <user name> <db name> -p < /work/initial_mysql.dump
```

- postgresqlの場合
```title:#
pg_restore -h 127.0.0.1 -p 5432 -d <db name> /work/initial_postgresql.dump
```

### 
