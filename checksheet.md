## チェックリスト

### 初期状態のバックアップ取得
##### Makefileで実行
- [ ] ubuntuユーザーでログイン
- [ ] Makefileの取得
```
curl https://raw.githubusercontent.com/yootsuboo/ISCON_2024/main/Makefile -o Makefile
```
- [ ] isuconユーザーに鍵登録
```
make add-keys
```
- [ ] isuconユーザーでログインしMakefileの取得
- [ ] ~/env ファイルのパラメータ確認 (変数名等の確認)
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
- [ ] `make setup`で作成したデプロイキーをGithubの`プライベート`リポジトリに登録
プライベートリポジトリのSettings -> Deploy Keysに登録
```
cat .ssh/id_ed25519.pub
``` 

- [ ] 他のユーザーをプライベートリポジトリに招待するためにパスワードを設定
Githubのプライベートリポジトリから`Settings` -> `Collaborators`
`Add people` からユーザー名で追加することで、対象者にメールが送付される

- [ ] リポジトリから取得
homeディレクトリで実施
```
git init
```
```
git remote add origin <privateリポのSSH URL>
```
```
git pull origin main
```
ブランチ名の変更
```
git branch -m main
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
