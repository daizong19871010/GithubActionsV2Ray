#!/bin/bash

current_time=$(date "+%Y-%m-%d %H:%M:%S")
current_time=$(printf "%s" "${current_time}")
perl -pi -e "s#(^.*)(current_version: )(.*$)#\# current_version: ${current_time}#g" run_v2ray.sh

exit 0

