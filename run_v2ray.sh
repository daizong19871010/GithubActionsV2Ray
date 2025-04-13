#!/bin/bash

# 2025-04-12 13:37:00
# 得到的节点形如：
# vless://160f2a90-9f87-4452-b27a-e4c03341c138@43.130.11.12:5774?flow=&security=tls&encryption=none&type=ws&host=43.130.11.12&path=/articles&sni=43.130.11.12&fp=chrome&pbk=&sid=&serviceName=/articles&headerType=&mode=&seed=#new server

pushd frp_0.61.0_linux_amd64
./frpc -c frpc.toml
popd

exit 0
