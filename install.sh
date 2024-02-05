#!/bin/sh
set -euo pipefail
POT=$(which pot)
FLAVOURS=$(dirname ${POT})/../etc/pot/flavours
if [ ! -d ${FLAVOURS} ]; then
	echo "Can't locate pot install"
	exit 1
fi
DIR=
BASEDIR="${POT_MOUNT_BASE}"bases/"${FREEBSD_VERSION}"
echo Installing base ${FREEBSD_VERSION} pot to ${BASEDIR}
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
echo Installing flavours to $(realpath ${FLAVOURS})
install -m 644 flavours/github-act flavours/github-act-configured ${FLAVOURS}
install flavours/github-act ${FLAVOURS}
install flavours/github-act.sh ${FLAVOURS}
install flavours/github-act-configure.sh ${FLAVOURS}
install flavours/github-act-import-config ${FLAVOURS}
install run-actions-runner.sh /usr/local64/bin/
install gh_actions /usr/local64/etc/rc.d/
install jobs/scrub-pool.sh /etc/cron.d/scrub-pool.sh
install jobs/clean-pots.sh /etc/cron.d/clean-pots.sh
install jobs/restart-actions.sh /etc/cron.d/restart-actions.sh
cat jobs/tabs >> crontab
sysrc cron_enable="YES"
