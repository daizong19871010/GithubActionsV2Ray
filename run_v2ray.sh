#!/bin/bash

# 2025-04-09 11:52:00
# 得到的节点形如：
# vless://160f2a90-9f87-4452-b27a-e4c03341c138@43.135.118.188:5774?flow=&security=tls&encryption=none&type=ws&host=43.135.118.188&path=/articles&sni=43.135.118.188&fp=chrome&pbk=&sid=&serviceName=/articles&headerType=&mode=&seed=#new server

echo "whoami: $(whoami)"
ip=$(curl ipinfo.io/ip)
echo "ip: ${ip}"
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
# 修改frp映射端口
account_port_map="dahongni21 5774\n"\
"qinming19871010 5775\n"\
"shoguncao 5777"
export port=$(echo -e ${account_port_map} | grep ${GITHUB_REPOSITORY_OWNER} | awk '{print $2}')
perl -pi -e "s/(remotePort = )(.*)($)/\1\$ENV{port}\3/g" frpc.toml
# frp有点坑，不同起相同的任务名字，所以按时间生成一个名字，然后修改到frpc.toml中
export frp_name="github_actions_frp_xray_$(date +%s)"
echo "frp_name: ${frp_name}"
perl -pi -e "s/(name = \")(.*)(\")/\1\$ENV{frp_name}\3/g" frpc.toml
./frpc -c frpc.toml &
echo "cat frpc.toml"
cat frpc.toml
popd

echo "ps -ef | grep \"xray\""
ps -ef | grep "xray"

echo "lsof -i:5759"
lsof -i:5759

exit 0
