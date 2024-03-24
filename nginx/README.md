# nginx player instance 初期設定

## ログフォーマットの変更

- ./nginx.conf のログフォーマットを対象のサーバに追加する
```bash
sudo nano /etc/nginx/nginx.conf
```

```nginx.conf
        log_format json escape=json '{"time":"$time_iso8601",'
                                    '"host":"$remote_addr",'
                                    '"port":"$remote_port",'
                                    '"method":"$request_method",'
                                    '"uri":"$request_uri",'
                                    '"status":"$status",'
                                    '"body_bytes":"$body_bytes_sent",'
                                    '"referer":"$http_referer",'
                                    '"ua":"$http_user_agent",'
                                    '"request_time":"$request_time",'
                                    '"response_time":"$upstream_response_time"}';

        access_log /var/log/nginx/access.log json;
```

- 設定が正しいことを確認 ※エラーとならないこと
```
sudo nginx -t
```

- nginxプロセスを再起動する
    - nginxプロセスのステータス確認
    ```bash
    systemctl status nginx
    ```
    - nginxプロセスの再起動
    ```bash
    sudo systemctl restart nginx
    ```
    - nginxプロセスのステータス確認
    ```bash
    systemctl status nginx
    ```

![nginx_response_time drawio](https://github.com/yootsuboo/ISCON_2024/assets/68502098/2d7e039d-79c0-4d4e-9e59-b62ed662c545)

## ログ基盤の構築

### install alp
- 以下のgithubから`linux_amd64`のバイナリファイルをダウンロード
    - https://github.com/tkuchiki/alp/releases
- ダウンロードしたファイルをplayerインスタンスに転送
    ```
    scp -i ~/.ssh/<key pair>.pem <file name> ubuntu@<public ipv4>:/home/ubuntu
    ```
- playerインスタンスでインストール
    - tarファイルの場合は解凍する
    ```
    tar -xvf <file name>.tar
    ```
    - インスールの実施
    ```
    sudo install <file name> /usr/local/bin/alp
    ```


## HTTPベンチマーカーのインストール
- Apache Bench のインストール
```
apt update
```
```
apt install apache2-utils
```

- アプリケーションの並列実行数変更
```
vim /home/isucon/private_isu/webapp/ruby/unicorn_config.rb
```
- CPUの倍の数に変更
```
worker_processes 4
```

