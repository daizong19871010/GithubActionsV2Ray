#!/bin/bash

# current_version: 2025-05-26 11:41:36
# 得到的节点形如：
# vless://160f2a90-9f87-4452-b27a-e4c03341c138@www.visa.com.sg:443?flow=&security=tls&encryption=none&type=ws&host=githubactions.keyso.uk&path=/githubactions&sni=githubactions.keyso.uk&fp=chrome&pbk=&sid=&serviceName=/githubactions&headerType=&mode=&seed=#xray_tunnel
# ssh登录方式
# ssh -i tmp -o "ProxyCommand=nc -x 127.0.0.1:1080 %h %p" -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" root@127.0.0.1

sudo apt-get update
sudo apt-get install openssh-server
sudo perl -pi -e "s/(^.*)(PubkeyAuthentication)(.*$)/PubkeyAuthentication yes/g" /etc/ssh/sshd_config
sudo perl -pi -e "s/(^.*)(AuthorizedKeysFile)(.*$)/AuthorizedKeysFile .ssh\/authorized_keys/g" /etc/ssh/sshd_config
sudo perl -pi -e "s/(^.*)(ClientAliveInterval)(.*$)/ClientAliveInterval 3600/g" /etc/ssh/sshd_config
sudo perl -pi -e "s/(^.*)(ClientAliveCountMax)(.*$)/ClientAliveCountMax 0/g" /etc/ssh/sshd_config
sudo perl -pi -e "s/(^.*)(TCPKeepAlive)(.*$)/TCPKeepAlive yes/g" /etc/ssh/sshd_config
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDi3F9f3tDNqI3OkXJVtB0GKHZeI65X0HQ5KeJ6Pq4FInyMmFoHEZrkGSG018CDVG/3SZcmknfL0VbaYSmh6vguioylw/p7nvRvZaS5AspwWON++WdvcOpq392W+QlTMC0zxHyB4whCGNNzp4koLYFgMe+JI33/ET/eD210668UgbXMbio4cNrxjgPiWU4nAskBuB6gmXci5VuiXMtYXNF2WOkMGT9AisYTTu68r9wp5+LVeopWN2qmk0B1/7pbsN2mHguoDzXZbPSid01mxLzMrJSt14IC+ICS7RI4mgMvKhT85KwHFEINF1b0/b8mOeKCKL+dsDO16YVf5PSdkoyCHuqCjKVoV5dTYDcBfbaVyh0EvCSsod5YAut+PnKmm+u6Y68JKbj/Or9MPE3NdGixYoz++5DijTYnspftbxbE4DqNR2sD++vzhzuT3f+hToTZz9eFiepp5lyMGxUGIBeOHVyIpAuFjr7yfaqoYbol+UJJ3Wv+Rolf9t428DvYpbeqKK4ro6oxOY5Zw1m//zQDieNHfboUL3TYPIeAn9z8QrEiRhhuLazfhorb2ryVDr7I5kEe+Kv5T9iodSxUQWihyI5THQB1PQ1z76TwUK98/1Yf7XSWnskmNWBrwnyFXahkUc5qvRJlXR7j/7fSiljxcG4UI6fLItYUvJAdhydrWQ== tmp" | sudo tee -a /root/.ssh/authorized_keys
sudo service ssh start

echo "cat /etc/ssh/sshd_config"
cat /etc/ssh/sshd_config

mkdir -p xray
pushd xray
wget https://github.com/XTLS/Xray-core/releases/download/v24.12.31/Xray-linux-64.zip
unzip Xray-linux-64.zip
sudo ./xray run -config ../xray.json > /dev/null
popd

exit 0
