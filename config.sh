#!/bin/sh
set -eo pipefail
SCRIPTDIR=$(realpath $(dirname $0))

if [ "$1" != '--url' -o "$3" != '--token' ] ; then
	echo usage ./config.sh --url https://github.com/{account}/{repo} --token {token}
	echo Copy this command from the GitHub actions runner setup page
	exit 1
fi

# Generate a random string for the runner name, if using config.sh without variables
export RANDOM=$(LC_ALL=C tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 8)
. ${SCRIPTDIR}/check-envs.sh

mkdir -p ${RUNNER_CONFIG_DIRECTORY}
cd ${RUNNER_CONFIG_DIRECTORY}

if [ -f github.conf ]; then
	echo github.conf exists, aborting.
	echo Please delete github.conf and retry
	exit 1
fi

# Provide the configuration that the configure flavour script needs
echo "GITHUB_URL=$2" > github.conf
echo "GITHUB_TOKEN=$4" >> github.conf
echo "RUNNER_NAME=${RUNNER_NAME}" >> github.conf

echo "RUNNER_FLAVOURS=${RUNNER_FLAVOURS}" > act-config.sh
echo "CHERIBSD_BUILD_ID=${CHERIBSD_BUILD_ID}" >> act-config.sh
echo "RUNNER_NAME=${RUNNER_NAME}" >> act-config.sh
echo "POTNAME=${POTNAME}" >> act-config.sh

# Add the flavour that will configure the runner before any user-provided ones.
RUNNER_FLAVOURS="github-act-configure ${RUNNER_FLAVOURS}"

. ${SCRIPTDIR}/create-runner.sh

# Copy the configuration out of the jail.
pot-copy-out -p "${POTNAME}" -s "/root/runner/*" -d "${RUNNER_CONFIG_DIRECTORY}"
