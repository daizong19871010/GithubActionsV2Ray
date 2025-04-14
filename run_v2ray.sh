#!/bin/bash

# 2025-04-14 00:24:00
# 得到的节点形如：
# vless://160f2a90-9f87-4452-b27a-e4c03341c138@www.visa.com.sg:443?flow=&security=tls&encryption=none&type=ws&host=monero.keyso.uk&path=/githubactions&sni=monero.keyso.uk&fp=chrome&pbk=&sid=&serviceName=/githubactions&headerType=&mode=&seed=#xray_tunnel

sudo apt update
sudo apt install openssh-server

echo "cat /etc/ssh/sshd_config"
cat /etc/ssh/sshd_config

echo "pwd: $(pwd)"
sudo mkdir -p /root/.ssh
sudo -i
cd /root/.ssh
sudo ssh-keygen -t rsa -b 4096 -C "tmp" -f tmp -P ""
sudo chmod 600 tmp
sudo echo "tmp: $(sudo cat tmp)"
sudo echo "tmp.pub: $(sudo cat tmp.pub)"
sudo cat tmp.pub >> authorized_keys
sudo echo "cat authorized_keys"
sudo cat authorized_keys

cd /home/runner/work/GithubActionsV2Ray/GithubActionsV2Ray

sudo systemctl start ssh
echo "lsof -i:22"
lsof -i:22
echo "ps -ef | grep ssh"
ps -ef | grep ssh

mkdir -p xray
pushd xray
wget https://github.com/XTLS/Xray-core/releases/download/v24.12.31/Xray-linux-64.zip
unzip Xray-linux-64.zip
sudo ./xray run -config ../xray.json
popd

exit 0
