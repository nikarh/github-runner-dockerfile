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

sudo -i -u ubuntu ./config.sh --unattended --url https://github.com/${REPOSITORY} --token ${TOKEN}

cleanup() {
    sudo -i -u ubuntu ./config.sh remove --token ${TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 131' QUIT
trap 'cleanup; exit 132' KILL
trap 'cleanup; exit 133' ERR
trap 'cleanup; exit 143' TERM

# We need to run the docker daemon as root and in the background to support docker based actions.
dockerd &

sudo -i -u ubuntu ./run.sh &

# Wait for any background process to complete.
wait -n