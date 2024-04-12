# nginx player instance 初期設定

## ログフォーマットの変更

- ./nginx.conf のログフォーマットを対象のサーバに追加する
```bash
sudo vim /etc/nginx/nginx.conf
```

```nginx.conf
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
- 以下のgithubから`linux_amd64`向けファイルをダウンロード
    ```
    curl -OL https://github.com/tkuchiki/alp/releases/download/v1.0.20/alp_linux_amd64.tar.gz -o /tmp/alp_linux_amd64.tar.gz
    ```
- playerインスタンスでインストール
    - tarファイルの場合は解凍する
    ```
    tar -zxvf /tmp/alp_linux_amd64.tar.gz
    ```
    - インスールの実施
    ```
    sudo install /tmp/alp /usr/local/bin/alp
    ```


## abコマンドのインストール (HTTPベンチマーカー)

- Apache Bench のインストール
```
sudo apt update
```
```
sudo apt install apache2-utils
```
- コマンド例 (URLに向けて1並列で合計10回のリクエスト)
```
ab -c 1 -n 10 http://localhost/
```

- アプリケーションの並列実行数変更
```
vim /home/isucon/private_isu/webapp/ruby/unicorn_config.rb
```
- CPUの倍の数に変更
```
worker_processes 4
```

