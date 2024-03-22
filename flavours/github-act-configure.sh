#!/bin/sh
# Assuming this script is called after create-runner.sh with the pot setup

# Source the configuration file if it exists
CONFIG_FILE="/root/github-config"
if [ -f "$CONFIG_FILE" ]; then
    . "$CONFIG_FILE"
    cat "$CONFIG_FILE"
fi

ARCH=$(curl -s \
    https://download.cheribsd.org/releases/arm64/aarch64c/ | \
    grep -Eo "\w{1,}\.\w{1,}" | sort -u)
CHERIBSD_BUILD_ID=$(echo ${ARCH} | awk -F " " '{print $NF}')
# Configure the runner
cd /root/runner || return 1
GODEBUG="asyncpreemptoff=1" /usr/local64/bin/github-act-runner configure \
    --url "${GITHUB_URL}" \
    --token "${GITHUB_TOKEN}" \
    --name "${RUNNER_NAME}" \
    --labels cheribsd,"cheribsd-${CHERIBSD_BUILD_ID}" \
    --unattended

echo "GitHub Actions runner configured for ${RUNNER_NAME}"
