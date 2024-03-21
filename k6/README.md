### install k6
- abコマンドより高機能な負荷試験ツールとして使用する
- [インストール方法](https://k6.io/docs/get-started/installation/)
- バージョン確認
```
k6 version
```

### テストの実行
- 複合テスト
```
k6 run integrated.js
```

- 単体でのテスト
    - <> のファイル名は適宣変更
    - vus: 並列実行数
```
k6 run -vus 1 <comment.js>
```


### alpでのアクセスログ確認（複合テスト)
```
alp json \
 --sort sum -r \
 -m "/posts/[0-9]+,/@\w+" \
 -o count,method,uri,avg,max,sum \
 < /var/log/nginx/access.log
```

- --sort sum -r : レスポンスの合計が大きいURLから降順で表示
- -m "/posts/[0-9]+,/@\w+"
    - URLの/posts/{投稿ID} を /posts/[0-9]+ に集約
    - URLの/@{アカウント名} を/@\w+ に集約
- -o count,method,uri,avg,max,sum : URLの統計をテーブル化

