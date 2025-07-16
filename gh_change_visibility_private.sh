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

function get_account_id {
    command="curl ${CURL_PROXY} -L -H \"Accept: application/vnd.github+json\" -H \"Authorization: Bearer ${token}\" -H \"X-GitHub-Api-Version: 2022-11-28\" https://api.github.com/user"
    my_log "command: ${command}"
    account_id=$(eval "${command}" | jq -r '.login')
}

parse_params $*
repo_name="GithubActionsV2Ray"
get_account_id

command="curl -X PATCH -H 'Authorization: Bearer ${token}' -H 'Accept: application/vnd.github+json' -H 'X-GitHub-Api-Version: 2022-11-28' 'https://api.github.com/repos/${account_id}/${repo_name}' -d '{\"private\": true}'"
echo "command: ${command}"
eval "${command}" > /dev/null

exit 0
