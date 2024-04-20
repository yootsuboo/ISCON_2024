## チェックリスト

### ログインとベンチマーク実行
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
```
curl https://raw.githubusercontent.com/yootsuboo/ISCON_2024/main/Makefile -o Makefile
```
- [ ] 使用言語の切り替え
- [ ] ベンチマークを数回実行(点数の振れ幅を確認)
```
make exec-bench
```

#### git管理
- [ ] git初期設定と鍵ファイル作成
```
git-setups
```
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
git remote add origin git@github.com:yootsuboo/isucon_private.git
```
```
git pull origin main
```
- [ ] ブランチ名の変更
```
git branch -m main
```
サーバ毎に変更(s1, s2, s3)
```
make set-as-s1
```
```
make get-conf
```
- [ ] コードをpush
```
git add .
```
```
git commit -m "initial commit"
```
```
git push origin main
```

#### バックアップとインストール
- [ ] ~/env.sh ファイルのパラメータ確認 (変数名等の確認)
- [ ] backupの実行
```
make backup
```
- [ ] setupの実行
```
make setup
```
- [ ] nginxアクセスログフォーマット変更
```
vim s1/etc/nginx/nginx.conf
```
```
        log_format ltsv "time:$time_local"
                        "\thost:$remote_addr"
                        "\tforwardedfor:$http_x_forwarded_for"
                        "\treq:$request"
                        "\tstatus:$status"
                        "\tmethod:$request_method"
                        "\turi:$request_uri"
                        "\tsize:$body_bytes_sent"
                        "\treferer:$http_referer"
                        "\tua:$http_user_agent"
                        "\treqtime:$request_time"
                        "\tcache:$upstream_http_x_cache"
                        "\truntime:$upstream_http_x_runtime"
                        "\tapptime:$upstream_response_time"
                        "\tvhost:$host";

        access_log /var/log/nginx/access.log ltsv;
```
- [ ] スロークエリログ有効化
```
vim s1/etc/mysql/mysql.conf.d/mysqld.cnf
```
```
slow_query_log = 1
slow_query_log_file = /var/log/mysql/mysql-slow.log
long_query_time = 0
```
```
make deploy-conf
```
```
make restart
```
- [ ] check-ansibleの実行
```
make dryrun
```
- [ ] checkの結果`filed`がなければ、exec-ansibleの実行
```
make exec
```

#### マニュアルと構成確認
- [ ] マニュアルの確認
- [ ] 実行中のserviceの確認
```
sudo systemctl list-units --type=service
```
- [ ] DBのテーブル構成を確認
```
make access-db
```
```title: mysql>
SELECT * FROM INFORMATION_SCHEMA.SCHEMATA;
```
```title: mysql>
SHOW TABLES;
```
```title: mysql>
SHOW FULL COMUMNS FROM <table-name>;
```
- [ ] ソースコードの確認
```
webapp/go/main.go
```

#### 計測ツール関係
##### top または htop
プロセスごとのcpu使用率、メモリ使用率がリアルタイムで確認できる
```
top
```
```
htop
```

##### dstat
サーバのリソース使用具合をリアルタイムで確認
```
dstat
```

##### journalctl
systemdで動いているサービスのログを確認
```
make watch-service-log
```

##### alp
アクセスログを解析するツール
オプション指定で同種のリクエストを束ねることもできる
[alp help](https://github.com/tkuchiki/alp)
[alp command sample](https://zenn.dev/tkuchiki/articles/how-to-use-alp)
```
make alp
```

##### pt-query-digest
DBスロークエリログの解析に使用
```
make slow-query
```

#### デプロイ関係

---
---

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
