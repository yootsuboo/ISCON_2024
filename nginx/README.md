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
                                    '"body_bytes":"$body_bytes_sent,'
                                    '"referer":"$http_referer",'
                                    '"ua":"$http_user_agent",'
                                    '"request_time":"$request_time",'
                                    '"response_time":"$upstream_response_time"}';

        access_log /var/log/nginx/access.log json;
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

