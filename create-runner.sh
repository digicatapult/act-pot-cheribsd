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

if [ ${POT_MOUNT_BASE} ]; then
    SIBLING_DIR=${POT_MOUNT_BASE}/jails/sibling
else
    SIBLING_DIR=/opt/pot/jails/sibling
fi

if [ ! -d $SIBLING_DIR ]; then
    pot create -p sibling -b ${FREEBSD_VERSION} -t single -f bootstrap
    pot snap -p sibling
fi

pot clone -p ${POTNAME} -P sibling -f github-act ${EXTRA_FLAVOURS} -f github-act-configured

echo
echo Created pot:
echo ${POTNAME}
