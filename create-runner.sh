#!/bin/sh
set -eo pipefail
EXTRA_FLAVOURS=
if [ "${RUNNER_FLAVOURS}" ] ; then
	for F in $RUNNER_FLAVOURS ; do
		echo Adding flavour ${F} to the pot
		EXTRA_FLAVOURS="${EXTRA_FLAVOURS} -f ${F}"
	done
fi

mkdir -p ${RUNNER_CONFIG_DIRECTORY}
cd ${RUNNER_CONFIG_DIRECTORY}

pot create -p ${POTNAME} -b ${FREEBSD_VERSION} -t single \
	-f github-act ${EXTRA_FLAVOURS} -f github-act-configured \
	-N private-bridge -B bridge-${FREEBSD_VERSION} -i auto -S ipv4

potnet etc-hosts -b bridge-${FREEBSD_VERSION} >> /etc/hosts

echo
echo Created pot:
echo ${POTNAME}
