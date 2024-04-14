## チェックリスト

### 初期状態のバックアップ取得
##### Makefileで実行
- Makefileの取得
```
curl https://raw.githubusercontent.com/yootsuboo/ISCON_2024/main/Makefile -o Makefile
```
- Makefileの実行
```
make backup
```

- rootユーザーで実行
```title:$
sudo su -
```
- ディレクトリの作成
```title:#
mkdir /work
```

- [ ] tarで丸めてバックアップを取得する~~
```
tar czvfp /work/initial_etc.tar.gz /etc
```
```
tar czvfp /work/initial_home.tar.gz /home
```
```
tar czvfp /work/initial_usr.tar.gz /usr
```


- [ ] DBダンプファイルを作成する
- mysqlの場合
<!-- nohup mysqldump -h 127.0.0.1 -u isuconp -pisuconp isuconp > /work/initial_mysql.dump & -->
```title:#
mysqldump -h 127.0.0.1 -u <user name>  -p<password> <db name> > /work/initial_mysql.dump
```
- postgresqlの場合
```tilte:#
pg_dumpall -h 127.0.0.1 -p 5432 <db name> > /work/initial_postgresql.dump
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
