#!/bin/bash

# 2025-04-12 13:37:00
# 得到的节点形如：
# vless://160f2a90-9f87-4452-b27a-e4c03341c138@43.130.11.12:5774?flow=&security=tls&encryption=none&type=ws&host=43.130.11.12&path=/articles&sni=43.130.11.12&fp=chrome&pbk=&sid=&serviceName=/articles&headerType=&mode=&seed=#new server

pushd frp_0.61.0_linux_amd64
./frpc -c frpc.toml &
popd

mkdir -p xray
pushd xray
wget https://github.com/XTLS/Xray-core/releases/download/v24.12.31/Xray-linux-64.zip
unzip Xray-linux-64.zip
sudo openssl ecparam -genkey -name prime256v1 -out ca.key
sudo openssl req -new -x509 -days 36500 -key ca.key -out ca.crt  -subj "/CN=bing.com"
echo -n "{\"log\":{\"access\":\"/home/runner/work/GithubActionsV2Ray/GithubActionsV2Ray/xray/access.log\",\"error\":\"/home/runner/work/GithubActionsV2Ray/GithubActionsV2Ray/xray/error.log\",\"loglevel\":\"warning\"},\"inbounds\":[{\"port\":443,\"protocol\":\"vless\",\"settings\":{\"clients\":[{\"id\":\"160f2a90-9f87-4452-b27a-e4c03341c138\",\"level\":0,\"email\":\"love@example.com\"}],\"decryption\":\"none\",\"fallbacks\":[{\"dest\":\"/dev/shm/default.sock\",\"xver\":1},{\"alpn\":\"h2\",\"dest\":\"/dev/shm/h2c.sock\",\"xver\":1}]},\"streamSettings\":{\"network\":\"tcp\",\"security\":\"tls\",\"tlsSettings\":{\"alpn\":[\"h2\",\"http/1.1\"],\"certificates\":[{\"certificateFile\":\"/home/runner/work/GithubActionsV2Ray/GithubActionsV2Ray/xray/ca.crt\",\"keyFile\":\"/home/runner/work/GithubActionsV2Ray/GithubActionsV2Ray/xray/ca.key\"}]}}}],\"outbounds\":[{\"protocol\":\"freedom\"}]}" > config.json
cat config.json
echo "$HOME"
pwd
# ./xray run -config config.json 1>/dev/null 2>/dev/null &
./xray run -config config.json
popd

# sudo apt-get install -y nginx
# sudo rm -rf /etc/nginx/nginx.conf
# sudo cp nginx.conf /etc/nginx
# echo "exe nginx -V"
# nginx -V
# echo "cat /etc/nginx/nginx.conf"
# cat /etc/nginx/nginx.conf
# sudo systemctl restart nginx
# sudo systemctl status nginx

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
echo "cat access.log"
cat /home/runner/work/GithubActionsV2Ray/GithubActionsV2Ray/xray/access.log
echo "cat error.log"
cat /home/runner/work/GithubActionsV2Ray/GithubActionsV2Ray/xray/error.log
sleep 10
done

exit 0
