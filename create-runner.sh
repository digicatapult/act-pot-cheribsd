#!/bin/sh
set -eo pipefail
EXTRA_FLAVOURS=
if [ "${RUNNER_FLAVOURS}" ] ; then
	for F in $RUNNER_FLAVOURS ; do
		echo Adding flavour ${F} to the pot
		EXTRA_FLAVOURS="${EXTRA_FLAVOURS} -f ${F}"
	done
fi

DIR=
BASEDIR="${POT_MOUNT_BASE}"bases/"${FREEBSD_VERSION}"
if [ ! -e "${BASEDIR}" ]; then
	pot create-base -r $FREEBSD_VERSION

	echo Adding libraries to the $BASENAME pot
	for DIR in lib64 lib64cb; do
		cp -r /usr/"${DIR}" "${BASEDIR}"/usr/ 2>/dev/null
	done

	pot start -p $BASENAME

	for PKG in pkg64 pkg64c pkg64cb; do
		echo Bootstrapping $PKG
		pot exec -p $BASENAME $PKG bootstrap -fy && $PKG update -f
	done

	pot stop -p $BASENAME
fi

mkdir -p ${RUNNER_CONFIG_DIRECTORY}
cd ${RUNNER_CONFIG_DIRECTORY}

pot create -p ${POTNAME} -b ${FREEBSD_VERSION} -t single -f github-act ${EXTRA_FLAVOURS} -f github-act-configured

echo
echo Created pot:
echo ${POTNAME}
