#!/bin/bash

function parse_params() {
    for VAR in $*
    do
        if [[ ${VAR} = "--token" ]]; then
            NEXT_VALUE_FOR_OPTION="token"
        elif [[ "${NEXT_VALUE_FOR_OPTION}" = "token" ]]; then
            token=${VAR}
            NEXT_VALUE_FOR_OPTION=""
        fi
    done
}

function my_log() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "[${timestamp}] $1"
}

parse_params $*
repo_name="GithubActionsV2Ray"

command="curl -X POST -H 'Authorization: token ${token}' -d '{\"name\":\"${repo_name}\", \"private\":false}' https://api.github.com/user/repos"
echo "command: ${command}"
eval "${command}"

exit 0
