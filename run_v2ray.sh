#!/bin/bash

# current_version: 2025-07-14 19:18:05
# 得到的节点形如：
# vless://160f2a90-9f87-4452-b27a-e4c03341c138@www.visa.com.sg:443?flow=&security=tls&encryption=none&type=ws&host=githubactions.keyso.uk&path=/githubactions&sni=githubactions.keyso.uk&fp=chrome&pbk=&sid=&serviceName=/githubactions&headerType=&mode=&seed=#xray_tunnel
# ssh登录方式
# ssh -i tmp -o "ProxyCommand=nc -x 127.0.0.1:1080 %h %p" -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" root@127.0.0.1
# ssh -i xray_ssh_github_key -o "ProxyCommand=ncat --proxy-type socks5 --proxy 127.0.0.1:9001 %h %p" -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" root@127.0.0.1

sudo apt-get update
sudo apt-get install openssh-server
sudo perl -pi -e "s/(^.*)(PubkeyAuthentication)(.*$)/PubkeyAuthentication yes/g" /etc/ssh/sshd_config
sudo perl -pi -e "s/(^.*)(AuthorizedKeysFile)(.*$)/AuthorizedKeysFile .ssh\/authorized_keys/g" /etc/ssh/sshd_config
sudo perl -pi -e "s/(^.*)(ClientAliveInterval)(.*$)/ClientAliveInterval 3600/g" /etc/ssh/sshd_config
sudo perl -pi -e "s/(^.*)(ClientAliveCountMax)(.*$)/ClientAliveCountMax 0/g" /etc/ssh/sshd_config
sudo perl -pi -e "s/(^.*)(TCPKeepAlive)(.*$)/TCPKeepAlive yes/g" /etc/ssh/sshd_config
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCXzkIENwv67cMTwIiMr+sMKpkuuWb5wYhdv79R5lqOhtBE71F92XN7Wt/59mJMve+agx82w9Til3bBwkhPOtf3pup+NvDdhXKtq4ljrmxq9T88QM0KBYvFnglIGQ8v+Y+Q4h4/pj6DyoOiUJEQK0b9PxP4SfyoTq6hp8RreGJ5TFOhwgyRt6E+TuTuLdCRd7DMnEpzJNyzAAdxAo4G9TROgycEJcZ5uX2Jex0fGTnJJ9pJtlOUrHr0W991sHS1Lm37uGQB8pqZXa2WftqZIt0bjFYAqS7EV5Nx4NJdCV3dC6Bu01I3iJyBkubxD1/tTe6Ueok4iAXR5tkb4zZ5V+WNv12/2wxXbYmElJD4Jrydv7qMuY4cgnNgAI58kuMcvBWBTA6QtEOyRiNUThz5BO9GvvzAQivlawaiuoYQC2OwwGQ+3WEso496nzNXlp7wO/NemNyZopzsYhQX7w4DYVk6lADdHUIZ+di1sU3mbQthyJ7RHHO8YmQFRqe/2DRqmAyDDH+SbzCtijFEoElEFgEA2PDRvmwJLdBzQf5uzMMIW09PfzkxQuCJAI8eSHepP22zSrq7BYqPqVEC68Pc5/uyuBEF0a4aQUaBSv/CcDkNHNQL3unbI4X7D6HkRRxLWdcYIgH6kgdxHTHUhSD+lVOqq6g1ISKrKxLP+kqF0uMJiQ== xray_ssh_github_key.gmail.com" | sudo tee -a /root/.ssh/authorized_keys
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
