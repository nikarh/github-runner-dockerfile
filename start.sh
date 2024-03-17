#!/bin/bash

TOKEN=$(curl -X POST -H "Authorization: token $(cat /run/secrets/github_pat)" -H "Accept: application/vnd.github+json" https://api.github.com/repos/${REPOSITORY}/actions/runners/registration-token | jq -r .token)

./config.sh --unattended --url https://github.com/${REPOSITORY} --token ${TOKEN}

cleanup() {
    ./config.sh remove --token ${TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh &
wait $!