## チェックリスト

### 初期状態のバックアップ取得
##### Makefileで実行
- [ ] Makefileの取得
```
curl https://raw.githubusercontent.com/yootsuboo/ISCON_2024/main/Makefile -o Makefile
```
- [ ] backupの実行
```
make backup
```
- [ ] setupの実行
```
make setup
```
- [ ] check-ansibleの実行
```
make check
```
- [ ] checkの結果`filed`がなければ、exec-ansibleの実行
```
make exec
```

##### git管理
`make setup`で作成したデプロイキーをGithubの`プライベート`リポジトリに登録
プライベートリポジトリのSettings -> Deploy Keysに登録
```
cat .ssh/id_ed25519.pub
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
