#/bin/sh
# Source the configuration file.
. /root/github-config
cat /root/github-config

VERSION=$(freebsd-version -u | sed -r 's/-.*//')
# Configure the runner
cd /root/runner
GODEBUG="asyncpreemptoff=1" /usr/local64/bin/github-act-runner configure \
	--url ${GITHUB_URL} \
	--token ${GITHUB_TOKEN} \
	--name ${RUNNER_NAME} \
	--labels cheribsd,"cheribsd-${FREEBSD_VERSION}",freebsd,"freebsd-${VERSION}"

