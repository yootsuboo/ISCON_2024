## Ansibleのインストール
**isuconユーザーで実行**

- ubuntuへのインストール
```title:$
sudo apt update
```
```title:$
sudo apt install ansible
```
- インストールの確認
```title:$
ansible --version
```

## git cloneを実施する
```title:$
git clone https://github.com/yootsuboo/ISCON_2024.git
```
```title:$
cd ISCON_2024
``` 

## ansible playbook の実行
```title:$
cd Ansible
```
- 確認コマンド
```title:$
ansible-playbook -i inventory/local.yml main.yml -v --check
```

- 実行コマンド
```title:$
ansible-playbook -i inventory/local.yml main.yml -v
```
