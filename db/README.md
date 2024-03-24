## mysql の設定など

## mysql スロークエリログの有効化
- mysql設定ファイルの変更
```
sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf
```
- 以下のコメントアウトの解除と設定変更
```
slow_query_log = 1
slow_query_log_file = /var/log/mysql/mysql-slow.log
long_query_tim = 0
```
- mysqlの再起動
```
sudo systemctl restart mysql
```
- mysqlへの接続 ※password は空
```
mysql -u root -t isuconp -p
```

- スロークエリの解析
```
mysqldumpslow /var/log/mysql/mysql-slow.log
```

- sqlにインデックスを貼る
EXPLAINをつけて実行したSQLでrows値が大きい場合、WHERE句のカラムに対してインデックスを追加する
```mysql
ALTER TABLE `comments` ADD INDEX `post_id_idx` (`post_id`);
```
EXPLAINの結果、Extraの値が`Using filesort`となっていると、負荷が大きいソート処理をすることになるのでソートに対するインデックスを追加する
ORDER BY句をのカラムを追加する。
```mysql
ALTER TABLE `comments` DROP INDEX `post_id_idx` ADD INDEX `post_id_idx` (`post_id`, `created_at`);
```
EXPLAINの結果、Extraの値が`Backward index scan`となっているとソートインデックスを逆向きに走査したことになる。
インデックスに`DESC`または`ASC`を追加する
```mysql
ALTER TABLE `comments` DROP INDEX `post_id_idx` ADD INDEX `post_id_idx` (`post_id`, `created_at` DESC);
```
EXPLAINの結果、Extraの値が`Null`になっていれば最適化されている

- covering Indexを作る
セカンダリインデックスに含まれる情報だけで、プライマリインデックスにアクセスしないことで負荷を減らせる
```mysql
ALTER TABLE `comments` ADD INDEX `idx_user_id` (`user_id`);
```
EXPLAINの結果、Extraの値が`Using index`となることでCovering Indexを使用していることがわかる


### スロークエリログの有効化(mysql)
- ログイン(パスワードは空)
```
mysql -u root -p
```

- スロークエリログの有効化(永続)※mysql 8.0以降
```
SET PERSIST GLOBAL slow_query_log = 1;
SET PERSIST GLOBAL slow_query_log_file = "/var/log/mysql/mysql-slow.log";
SET PERSIST GLOBAL long_query_time = 0;
```

### スロークエリログ分析パッケージのインストール
- pt-query-digest のインストール
```
sudo apt update
sudo apt install percona-toolkig
```
- バージョン確認
```
pt-query-digest --version
```

- 解析コマンド
```
pt-query-digest /var/log/mysql/mysql-slow.log
```

## query-digester を利用したプロファイリングの自動化
- query-digesterのインストール
```
git clone git@github.com:kazeburo/query-digester.git
cd query-digester
sudo install querydigester /usr/local/bin
```

