include /home/isucon/env.sh
# 変数定義 --------------------------------

# 問題により変更になる定義
USER:=isucon
BIN_NAME:=isu
BUILD_DIR:=/home/isucon/private_isu/go
SERVICE_NAME:=$(BIN_NAME)-go.service

DB_PATH:=/etc/mysql
NGINX_PATH:=/etc/nginx
SYSTEMD_PATH:=/etc/systemd/system

NGINX_LOG:=/var/log/nginx/access.log
DB_SLOW_LOG:=/var/log/mysql/mysql-slow.log

# バックアップの取得 ----------------------

.PHONY: backup
backup: backup-setup backup-etc backup-home backup-usr dump-mysql


# メインで使用するコマンド ----------------

# ツールインストール, gitまわりのセットアップ
.PHONY: setup
setup: install-tools git-setup

.PHONY: add-keys
add-keys:
	sudo mkdir -p /home/isucon/.ssh
	sudo chown isucon:isucon /home/isucon/.ssh
	sudo cp ~/.ssh/authorized_keys /home/isucon/.ssh/
	sudo chown isucon:isucon /home/isucon/.ssh/authorized_keys

.PHONY: dryrun
dryrun: clone check-ansible

.PHONY: exec
exec: exec-ansible mv-logs

# 設定ファイルの取得、git管理下にする
.PHONY: get-conf
get-conf: check-server-id get-db-conf get-nginx-conf get-service-file get-envsh

# リポジトリ内の設定ファイルをそれぞれ配置する
.PHONY: deploy-conf
deploy-conf: check-server-id deploy-db-conf deploy-nginx-conf deploy-service-file deploy-envsh

# ベンチマークを走らせる直前に実施する
.PHONY: bench
bench: check-server-id mv-logs build deploy-conf restart watch-service-log

# ベンチマークの実行
.PHONY: exec-bench
exec-bench: /home/isucon/private_isu/benchmarker/bin/benchmarker -u /home/isucon/private_isu/benchmarker/userdata -t http://localhost

# slow queryを確認する
.PHONY: slow-query
slow-query:
	sudo pt-query-digest $(DB_SLOW_LOG)

# alpでアクセスログを確認する
.PHONY: alp
alp:
	sudo alp ltsv --file=$(NGINX_LOG) --config=/home/isucon/tool-config/alp/config.yml

.PHONY: access-db
access-db:
	sudo mysql -h $(ISUCONP_DB_HOST) -u $(ISUCONP_DB_USER) -p$(ISUCONP_DB_PASSWORD) $(ISUCONP_DB_NAME)


# ----------------------------------------------------------

# バックアップ構成要素

# バックアップ用のフォルダ作成
.PHONY: backup-setup
backup-setup:
	sudo mkdir -p ${HOME}/backup

# /etc配下をフルバックアップ
.PHONY: backup-etc
backup-etc:
	sudo tar czvfp ${HOME}/backup/initial_etc.tar.gz /etc/

# /home配下をフルバックアップ
.PHONY: backup-home
backup-home:
	sudo tar --exclude "isucon/backup*" --exclude "isucon/ISCON_2024*" -czvfp ${HOME}/backup/initial_home.tar.gz /home/

# /usr配下をフルバックアップ
.PHONY: backup-usr
backup-usr:
	sudo tar czvfp ${HOME}/backup/initial_usr.tar.gz /usr/

# DBのダンプファイルを取得
.PHONY: dump-mysql
dump-mysql:
	sudo mysqldump --single-transaction -h $(ISUCONP_DB_HOST) -u $(ISUCONP_DB_USER) -p$(ISUCONP_DB_PASSWORD) $(ISUCONP_DB_NAME) > ${HOME}/backup/initial_mysql.dump


# メインコマンド構成要素

.PHONY: install-tools
install-tools:
	sudo apt update
	sudo apt upgrade
	sudo apt -y install software-properties-common
	sudo apt-add-repository ppa:ansible/ansible
	sudo apt -y install ansible tree dstat snapd graphviz git snapd

.PHONY: git-setup
git-setup:
	git config --global user.email "test@example.com"
	git config --global user.name "admin"
	
	# deploykeyの作成
	ssh-keygen -t ed25519

.PHONY: clone
clone:
	git clone https://github.com/yootsuboo/ISCON_2024.git

.PHONY: check-ansible
check-ansible: 
	cd ~/ISCON_2024/Ansible && ansible-playbook -i inventory/local.yml main.yml -v --check

.PHONY: exec-ansible
exec-ansible: 
	cd ~/ISCON_2024/Ansible && ansible-playbook -i inventory/local.yml main.yml -v
	. ~/.bashrc

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
	sudo chown $(USER) ~/$(SERVER_ID)/etc/systemd/system/$(SERVICE_NAME)

.PHONY: get-envsh
get-envsh:
	cp ~/env.sh ~/$(SERVER_ID)/home/isucon/env.sh

.PHONY: deploy-db-conf
deploy-db-conf:
	sudo cp -R ~/$(SERVER_ID)/etc/mysql/* $(DB_PATH)

.PHONY: deploy-nginx-conf
deploy-nginx-conf:
	sudo cp -R ~/$(SERVER_ID)/etc/nginx/* $(NGINX_PATH)

.PHONY: deploy-service-file
deploy-service-file:
	sudo cp ~/$(SERVER_ID)/etc/systemd/system/$(SERVICE_NAME) $(SYSTEMD_PATH)/$(SERVICE_NAME)

.PHONY: deploy-envsh
deploy-envsh:
	cp ~/$(SERVER_ID)/home/isucon/env.sh ~/env.sh


.PHONY: build
build:
	cd $(GUILD_DIR); \
		go build -o $(BIN_NAME)

.PHONY: restart
restart:
	sudo systemctl daemon-reload
	sudo systemctl restart $(SERVICE_NAME)
	sudo systemctl restart mysql
	sudo systemctl restart nginx

.PHONY: mv-logs
mv-logs:
	$(eval when := $(shell date "+%s"))
	mkdir -p ~/logs/nginx/$(when)
	mkdir -p ~/logs/mysql/$(when)
	sudo test -f $(NGINX_LOG) && \
		sudo mv -f $(NGINX_LOG) ~/logs/nginx/$(when)/ || echo ""
	sudo test -f $(DB_SLOW_LOG) && \
		sudo mv -f $(DB_SLOW_LOG) ~/logs/mysql/$(when)/ || echo ""

.PHONY: watch-service-log
watch-service-log:
	sudo journalctl -u $(SERVICE_NAME) -n10 -fx

