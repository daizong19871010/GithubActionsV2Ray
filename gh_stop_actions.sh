#!/bin/bash

function parse_params() {
    for VAR in $*
    do
        if [[ ${VAR} = "--token" ]]; then
            NEXT_VALUE_FOR_OPTION="token"
        elif [[ "${NEXT_VALUE_FOR_OPTION}" = "token" ]]; then
            token=${VAR}
            NEXT_VALUE_FOR_OPTION=""
        elif [[ ${VAR} = "--account_id" ]]; then
            NEXT_VALUE_FOR_OPTION="account_id"
        elif [[ "${NEXT_VALUE_FOR_OPTION}" = "account_id" ]]; then
            account_id=${VAR}
            NEXT_VALUE_FOR_OPTION=""
        elif [[ ${VAR} = "--repo_name" ]]; then
            NEXT_VALUE_FOR_OPTION="repo_name"
        elif [[ "${NEXT_VALUE_FOR_OPTION}" = "repo_name" ]]; then
            repo_name=${VAR}
            NEXT_VALUE_FOR_OPTION=""
        elif [[ ${VAR} = "--actions_id" ]]; then
            NEXT_VALUE_FOR_OPTION="actions_id"
        elif [[ "${NEXT_VALUE_FOR_OPTION}" = "actions_id" ]]; then
            actions_id=${VAR}
            NEXT_VALUE_FOR_OPTION=""
        fi
    done
}

function my_log() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "[${timestamp}] $1"
}

parse_params $*

command="curl -X POST -H 'Authorization: Bearer ${token}' -H 'Accept: application/vnd.github+json' -H 'X-GitHub-Api-Version: 2022-11-28' 'https://api.github.com/repos/${account_id}/${repo_name}/actions/runs/${actions_id}/force-cancel'"
echo "command: ${command}"
eval "${command}"

exit 0
