#!/bin/sh
set -e

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
    pot create -p sibling -b ${CHERIBSD_BUILD_ID} -t single -f bootstrap
    pot start -p sibling
    pot exec -p sibling cp -R /root/lib64 /usr
    pot exec -p sibling cp -R /root/lib64cb /usr
    pot exec -p sibling rm -rdf /root/lib64
    pot exec -p sibling rm -rdf /root/lib64cb
    pot exec -p sibling pkg64 install -y bash curl git node readline
    pot stop -p sibling
    pot snap -p sibling
fi

pot clone -p ${POTNAME} -P sibling -f github-act ${EXTRA_FLAVOURS} \
    -f github-act-configured

echo
echo Created pot:
echo ${POTNAME}
