## Ansibleのインストール
- ubuntuへのインストール
```title:#
apt install ansible
```
- インストールの確認
```title:#
ansible --version
```

## git cloneを実施する
```title:$
git clone --filter=blob:none --sparse https://github.com/yootsuboo/ISCON_2024.git
```
```title:$
cd ISCON_2024
``` 
```tilte:$
git sparse-checkout set Ansible
```

## ansible playbook の実行
```title:$
ansible-playbook -i inventory/local.yml main.yml
```
