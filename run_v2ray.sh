#!/bin/bash

# 2025-04-14 00:24:00
# 得到的节点形如：
# vless://160f2a90-9f87-4452-b27a-e4c03341c138@www.visa.com.sg:443?flow=&security=tls&encryption=none&type=ws&host=monero.keyso.uk&path=/githubactions&sni=monero.keyso.uk&fp=chrome&pbk=&sid=&serviceName=/githubactions&headerType=&mode=&seed=#xray_tunnel

sudo apt-get update
sudo apt-get install openssh-server
sudo service ssh start

sleep 10
echo "ps -ef | grep ssh"
ps -ef | grep ssh
echo "lsof -i:22"
lsof -i:22
echo "sudo ss -ltnp | grep sshd"
sudo ss -ltnp | grep sshd
echo "cat /etc/ssh/sshd_config"
cat /etc/ssh/sshd_config

mkdir -p xray
pushd xray
wget https://github.com/XTLS/Xray-core/releases/download/v24.12.31/Xray-linux-64.zip
unzip Xray-linux-64.zip
sudo ./xray run -config ../xray.json
popd

exit 0
