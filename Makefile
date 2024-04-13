include ~/env.sh
# 変数定義 --------------------------------

# 問題により変更になる定義
USER:=isucon
BIN_NAME:=isucondition
BUILD_DIR:=/home/isucon/webapp/go
SERVICE_NAME:=$(BIN_NAME).go.service

DB_PATH:=/etc/mysql
NGINX_PATH:=/etc/nginx
SYSTEMD_PATH:=/etc/systemd/system

NGINX_LOG:=/var/log/nginx/access.log
DB_SLOW_LOG:=/var/log/mysql/mariadb-slow.log

# バックアップの取得

.PHONY: backup
backup: backup-etc backup-home backup-usr dump-mysql


# メインで使用するコマンド ----------------

# ツールインストール, gitまわりのセットアップ
.PHONY: setup
setup: install-tools git-setup

.PHONY: exec-ansible
exec-ansible: 
	cd ~/ISUCON_2024
	ansible-playbook -i inventory/local.yml main.yml -v

# 設定ファイルの取得、git管理下にする
.PHONY: get-conf
get-conf: check-server-id get-db-conf deploy-nginx-conf deploy-service-file deploy-envsh

# ベンチマークを走らせる直前に実施する
.PHONY: bench
bench: check-server-id mv-logs build deploy-conf restart watch-service-log

# slow queryを確認する
.PHONY: slow-query
slow-query:
	sudo pt-query-digest $(DB_SLOW_LOG)

# alpでアクセスログを確認する
.PHONY: alp
alp:
	sudo alp ltsv --file=$(NGINX_LOG) #--config=/home/isucon/tool-config/alp/config.yml

.PHONY: access-db
access-db:
	mysql -h $(MYSQL_HOST) -P $(MYSQL_PORT) -u $(MYSQL_USER) -p$(MYSQL_PASS) $(MYSQL_DBNAME)


# バックアップ構成要素

.PHONY: backup-etc
backup-etc:
	sudo su -
	mkdir /work
	tar czvfp /work/initial_etc.tar.gz /etc

.PHONY: backup-home
backup-home:
	sudo su -
	mkdir /work
	tar czvfp /work/initial_home.tar.gz /home

.PHONY: backup-usr
backup-usr:
	sudo su -
	mkdir /work
	tar czvfp /work/initial_usr.tar.gz /usr


.PHONY: dump-mysql
dump-mysql:
	mysqldump -h $(MYSQL_HOST) -u $(MYSQL_USER) -p$(MYSQL_PASS) $(MYSQL_DBNAME) > /work/initial_mysql.dump


# メインコマンド構成要素

.PHONY: install-tools
install-tools:
	sudo apt update
	sudo apt upgrade
	sudo apt install ansible tree dstat snapd graphviz git

.PHONY: git-setup
git-setup:
	git config --global user.email "test@example.com"
	git config --global user.name "admin"
	
	# deploykeyの作成
	ssh-keygen -t ed25519

.PHONY: check-server-id
check-server-id:
ifdef SERVER_ID
	@echo "SERVER_ID=$(SERVER_ID)"
else
	@echo "SERVER_ID is unset"
	@exit 1
endif

.PHONY: set-as-s1
set-as-s1:
	echo "SERVER_ID=s1" >> env.sh

.PHONY: set-as-s2
set-as-s2:
	echo "SERVER_ID=s2" >> env.sh

.PHONY: set-as-s3
set-as-d3:
	echo "SERVER_ID=s3" >> env.sh

.PHONY: get-db-conf
get-db-conf:
	sudo cp -R $(DB_PATH)/* ~/$(SERVER_ID)/etc/mysql
	sudo chown $(USER) -R ~/$(SERVER_ID)/etc/mysql

.PHONY: get-nginx-conf
get-nginx-conf:
	sudo cp -R $(NGINX_PATH)/* ~/$(SERVER_ID)/etc/nginx
	sudo chown $(USER) -R ~/$(SERVER_ID)/etc/nginx

.PHONY: get-service-file
get-service-file:
	sudo cp $(SYSTEMD_PATH)/$(SERVICE_NAME) ~/$(SERVER_ID)/etc/systemd/system/$(SERVICE_NAME)
	sudo chwon $(USER) ~/$(SERVER_ID)/etc/systemd/system/$(SERVICE_NAME)

.PHONY: get-envsh
get-envsh:
	cp ~/env.sh ~/$(SERVER_ID)/home/isucon/env.sh

.PHONY: deploy-db-conf
deploy-db-conf:
	sudo cp -R ~/$(SERVER_ID)/etc/mysql/* $(DB_PATH)


.PHONY: build
build:
	cd $(GUILD_DIR); \
		go build -o $(BIN_NAME)

.PHONY: restart
restart:
	sudo systemctl daemon-reload
	sudo systemctl restart $(SERVICE_NAME)
	sudo systemctl restart mysql
	sudo systemctl restar nginx

.PHONY: mv-logs
mv-logs:
	$(eval when := $(shell data "+%s"))
	mkdir -p ~/logs/$(when)
	sudo test -f $(NGINX_LOG) && \
		sudo mv -f $(NGINX_LOG) ~/logs/nginx/$(when)/ || echo ""
	sudo test -f $(DB_SLOW_LOG) && \
		sudo mv -f $(DB_SLOW_LOG) ~/logs/mysql/$(when)/ || echo ""

.PHONY: watch-service-log
watch-service-log:
	sudo journalctl -u $(SERVICE_NAME) -n10 -f

