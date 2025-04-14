#!/bin/bash

function parse_params() {
    for VAR in $*
    do
        if [[ ${VAR} = "--token" ]]; then
            NEXT_VALUE_FOR_OPTION="token"
        elif [[ "${NEXT_VALUE_FOR_OPTION}" = "token" ]]; then
            token=${VAR}
            NEXT_VALUE_FOR_OPTION=""
        elif [[ ${VAR} = "--repo_name" ]]; then
            NEXT_VALUE_FOR_OPTION="repo_name"
        elif [[ "${NEXT_VALUE_FOR_OPTION}" = "repo_name" ]]; then
            repo_name=${VAR}
            NEXT_VALUE_FOR_OPTION=""
        elif [[ ${VAR} = "--private" ]]; then
            NEXT_VALUE_FOR_OPTION="private"
        elif [[ "${NEXT_VALUE_FOR_OPTION}" = "private" ]]; then
            private=${VAR}
            NEXT_VALUE_FOR_OPTION=""
        fi
    done
}

function my_log() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "[${timestamp}] $1"
}

parse_params $*

command="curl -X POST -H 'Authorization: token ${token}' -d '{\"name\":\"${repo_name}\", \"private\":${private}}' https://api.github.com/user/repos"
echo "command: ${command}"
eval "${command}"

exit 0
