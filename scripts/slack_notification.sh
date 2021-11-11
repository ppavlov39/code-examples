#!/bin/bash

set -euo pipefail

if [[ $# -lt 4 ]]; then
  echo "Not enough parameters found"
  exit 1
fi

ENVIRONMENT=$1
BACKEND_BRANCH=$2
FRONTEND_BRANCH=$3
GITLAB_USER_NAME="$4"
if [[ $# -lt 5 || $5 == "" ]]; then RELEASE_MESSAGE="Сообщение не указано"; else RELEASE_MESSAGE="${5}"; fi

SLACK_TOKEN="`cat /path/to/token`"

function send_slack_message() {

    is_test=0
    slack_msg_body="${RELEASE_MESSAGE}" 
    test_env_message="TEST ENV MESSAGE`"

    case "$ENVIRONMENT" in 
        test1)
            is_test=1
            slack_channel="#some_testing_chanel"
            slack_msg_body="${test_env_message}" ;;
        test2)
            is_test=1
            slack_channel="#some_testing_chanel"
            slack_msg_body="${test_env_message}" ;;
        production)
            slack_channel="#some_prod_chanel"
            prefix_message="Some prefix" ;;
        *)
            echo "Wrong environment"
            exit 1 ;;
    esac

    if [[ is_test == 0 ]]; then
    echo $is_test
        slack_username="Releas ${prefix_emessage} (${GITLAB_USER_NAME})"
    else
        slack_username="${GITLAB_USER_NAME}"
    fi

    curl -d "token=${SLACK_TOKEN}" \
	 -d "username=${slack_username}" \
	 -d "channel=${slack_channel}" \
	 -d "text=${slack_msg_body}" \
	 -d "icon_emoji=:rocket:" \
	 https://slack.com/api/chat.postMessage

}

send_slack_message
