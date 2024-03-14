#!/bin/sh
# Assuming this script is called after create-runner.sh with the pot setup

# Source the configuration file if it exists
CONFIG_FILE="/root/github-config"
if [ -f "$CONFIG_FILE" ]; then
    . "$CONFIG_FILE"
    cat "$CONFIG_FILE"
fi

ARCH=$(ls /usr/local/share/freebsd/MANIFESTS | \
    grep -Eo "\w{1,}\.\w{1,}" | sort -u)
CHERIBSD_BUILD_ID=$(echo ${ARCH} | awk -F " " '{print $NF}')
# Configure the runner
cd /root/runner
GODEBUG="asyncpreemptoff=1" /usr/local64/bin/github-act-runner configure \
    --url "${GITHUB_URL}" \
    --token "${GITHUB_TOKEN}" \
    --name "${POTNAME}" \
    --labels cheribsd,"cheribsd-${CHERIBSD_BUILD_ID}" \
    --unattended

echo "GitHub Actions runner configured for ${POTNAME}"
