#!/bin/bash

echo "whoami: $(whoami)"
sudo apt-get update

# 安装xray
sudo bash -c "$(curl -L github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u root
sudo rm -rf /usr/local/etc/xray/config.json
sudo cp xray.json /usr/local/etc/xray/config.json
echo "cat /usr/local/etc/xray/config.json"
cat /usr/local/etc/xray/config.json
sudo systemctl restart xray
sudo systemctl status xray

# 安装nginx
sudo apt-get install -y nginx
sudo rm -rf /etc/nginx/nginx.conf
sudo cp nginx.conf /etc/nginx
pushd /etc/nginx
sudo openssl ecparam -genkey -name prime256v1 -out ca.key
sudo openssl req -new -x509 -days 36500 -key ca.key -out ca.crt  -subj "/CN=bing.com"
popd
echo "exe nginx -V"
nginx -V
echo "cat /etc/nginx/nginx.conf"
cat /etc/nginx/nginx.conf
sudo systemctl restart nginx
sudo systemctl status nginx

# 启动frp
pushd frp_0.61.0_linux_amd64
frp_name="github_actions_frp_xray_$(date +%s)"
# frp有点坑，不同起相同的任务名字，所以按时间生成一个名字，然后修改到frpc.toml中
perl -pi -e "s/(name = \")(.*)(\")/\1\$ENV{frp_name}\3/g" frpc.toml
./frpc -c frpc.toml &
popd

echo "ps -ef | grep \"xray\""
ps -ef | grep "xray"

echo "lsof -i:5759"
lsof -i:5759

# 打印日志
while true; do
    echo "cat /var/log/nginx/access.log"
    cat /var/log/nginx/access.log

    echo "/var/log/xray/access.log"
    sudo cat /var/log/xray/access.log

    echo "/var/log/xray/error.log"
    sudo cat /var/log/xray/error.log

    sleep 20
done
