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
        fi
    done
}

function my_log() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "[${timestamp}] $1"
}

parse_params $*

# 获取所有工作流运行（分页处理）
RUN_IDS=()
PAGE=1
while true; do
  echo "Fetching page $PAGE..."
  RESPONSE=$(curl -s -L -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $token" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "https://api.github.com/repos/${account_id}/${repo_name}/actions/runs?per_page=100&page=$PAGE")

  # 提取工作流ID
  IDS=$(echo "$RESPONSE" | jq -r '.workflow_runs[] | select(.status == "in_progress" or .status == "queued") | .id')
  if [ -z "$IDS" ]; then
    [ $PAGE -eq 1 ] && echo "No running workflows found" && exit 0
    break
  fi
  RUN_IDS+=($IDS)
  
  # 检查分页
  LINKS=$(echo "$RESPONSE" | grep -o '<https://api.github.com/.*>; rel="next"')
  if [ -z "$LINKS" ]; then
    break
  else
    PAGE=$((PAGE + 1))
  fi
done

# 取消所有找到的工作流
for RUN_ID in "${RUN_IDS[@]}"; do
  echo "Canceling workflow run $RUN_ID..."
  curl -X POST -L -H "Authorization: Bearer $token" \
    -H "X-GitHub-Api-Version: $API_VERSION" \
    -H "Accept: application/vnd.github+json" \
    "https://api.github.com/repos/${account_id}/${repo_name}/actions/runs/$RUN_ID/cancel"
done

exit 0

