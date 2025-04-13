#!/bin/bash

# 2025-04-12 13:37:00
# 得到的节点形如：
# vless://160f2a90-9f87-4452-b27a-e4c03341c138@43.130.11.12:5774?flow=&security=tls&encryption=none&type=ws&host=43.130.11.12&path=/articles&sni=43.130.11.12&fp=chrome&pbk=&sid=&serviceName=/articles&headerType=&mode=&seed=#new server

pushd frp_0.61.0_linux_amd64
./frpc -c frpc.toml &
popd

sudo apt-get install -y nginx
# sudo rm -rf /etc/nginx/nginx.conf
# sudo cp nginx.conf /etc/nginx
# pushd /etc/nginx
# sudo openssl ecparam -genkey -name prime256v1 -out ca.key
# sudo openssl req -new -x509 -days 36500 -key ca.key -out ca.crt  -subj "/CN=bing.com"
# popd
echo "exe nginx -V"
nginx -V
echo "cat /etc/nginx/nginx.conf"
cat /etc/nginx/nginx.conf
sudo systemctl restart nginx
sudo systemctl status nginx

start_time=$(date +%s)
timeout=1800
while true; do
current_time=$(date +%s)
elapsed=$((current_time - start_time))
if [ "$elapsed" -ge "$timeout" ]; then
    echo "循环已执行${elapsed}秒，退出"
    break
fi
echo "运行中... 已过时间：${elapsed}秒"
echo "cat frp_0.61.0_linux_amd64/frpc.log"
cat frp_0.61.0_linux_amd64/frpc.log
echo "cat /var/log/nginx/access.log"
cat /var/log/nginx/access.log
echo "cat /etc/nginx/nginx.conf"
cat /etc/nginx/nginx.conf
sleep 10
done

exit 0
