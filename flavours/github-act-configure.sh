#!/bin/sh
# Assuming this script is called after create-runner.sh with the pot setup

# Source the configuration file if it exists
CONFIG_FILE="/root/github-config"
if [ -f "$CONFIG_FILE" ]; then
    . "$CONFIG_FILE"
    cat "$CONFIG_FILE"
fi

# Load the token from the file saved by create-runner.sh
TOKEN_FILE="${RUNNER_CONFIG_DIRECTORY}/${POTNAME}_token"
if [ ! -f "$TOKEN_FILE" ]; then
    echo "Runner token file not found."
    exit 1
fi
GITHUB_TOKEN=$(cat "$TOKEN_FILE")

# Configure the runner
cd /root/runner
VERSION=$(freebsd-version -u | sed -r 's/-.*//')
GODEBUG="asyncpreemptoff=1" /usr/local64/bin/github-act-runner configure \
    --url "https://github.com/${GITHUB_ORG}" \
    --token "${GITHUB_TOKEN}" \
    --name "${POTNAME}" \
    --labels cheribsd,"cheribsd-${CHERIBSD_BUILD_ID}",freebsd,"freebsd-${VERSION}" \
    --unattended

echo "GitHub Actions runner configured for ${POTNAME}"
