#!/bin/bash

# current_version: 2025-06-21 10:39:04
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
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCktzXVX7PGSVm4bkY3FSJv4ov2Lm6JY4BQDpaxGeYH8DTCDJaDgj1pNDK995LM06C41Z5f3/CCPNGyg/6eK//8HvPV9Wb3jbe+uKypAFL2RvpIf6A3UCw5mH6TJYPC0cqBn1Bx+DLHvSyd0/dAx8rGHNx73bcg5LluPvxq8EzUFn8bRhtWIj602GUM0MKd3q68bmiSrQsmvdqwgNy5b8If6Rk0OWU9mXn8XkRxS9L4ciuLdBqn3fUclAj0ODED/uZkSisuStkW7IbArLIqCuvyNInxIzJt60wZG5igETZzQ1sXqVN8+Yh5TjO3kMY5Ma+/DcuWQIJXdt8j21nsvcHTKDXlGVa1q6JIkXj47Sj3uXqZOnREB+MJ6s6UqjeVUf4t7GM6x51ht7z4HZBFNh2gWLzVtrHD+frfPuXWFKd/TMKR9w4UrAZf33hg3/m0bF6zDKSBtvG+PSbSR6oh4icuMKuoCzyLhAoDHv2dgg4shXhM1OiKMB3KuNoDujfvu7LmKBeQuw0dBT2qyxViqKC5nJskCRZEydcHO7qaXhT9E7IPViUPpN9w/ca2aqE1x/opyo4X0c5immefPER3yEGsWaB7yRg36JQSmUUAb8TaEEOUahnWFULsgJ+zwFT3S/K8McPRlYiXms2Tlm5Zw5ExFm+h4EsRYm7PUrPOOxtkYQ== tmp.gmail.com" | sudo tee -a /root/.ssh/authorized_keys
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
