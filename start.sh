#!/bin/bash

set -Eeuo pipefail

if [ -r /run/secrets/github_pat ]; then
  PAT=$(cat /run/secrets/github_pat)
elif [ -n "${GITHUB_PAT}" ]; then
  PAT=${GITHUB_PAT}
else
  echo "Please set GITHUB_PAT or add the GitHub PAT to /run/secrets/github_pat"
  exit 1
fi

TOKEN=$(curl -sS -X POST -H "Authorization: token ${PAT}" -H "Accept: application/vnd.github+json" https://api.github.com/repos/${REPOSITORY}/actions/runners/registration-token | jq -r .token)

./config.sh --unattended --replace --url https://github.com/${REPOSITORY} --token ${TOKEN}

cleanup() {
  ./config.sh remove --token ${TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 131' QUIT
trap 'cleanup; exit 132' KILL
trap 'cleanup; exit 133' ERR
trap 'cleanup; exit 143' TERM

./run.sh &
wait