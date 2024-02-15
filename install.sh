#!/bin/sh
set -euo pipefail
POT=$(which pot)
FLAVOURS=$(dirname ${POT})/../etc/pot/flavours
if [ ! -d ${FLAVOURS} ]; then
	echo "Can't locate pot install"
	exit 1
fi

if [ ! $(pot ls -b | grep -Eo ${FREEBSD_VERSION}) ]; then
	echo Creating base pot for ${FREEBSD_VERSION}
	mkdir -p /usr/local/share/freebsd/MANIFESTS/
	ARCH=$(curl -s \
		https://download.cheribsd.org/releases/arm64/aarch64c/ | \
		grep -Eo "\w{1,}\.\w{1,}" | sort -u)
	for RELEASE in $ARCH; do
		curl -C - "https://download.cheribsd.org/releases/arm64/aarch64c/$RELEASE/ftp/MANIFEST" > \
		/usr/local/share/freebsd/MANIFESTS/arm64-aarch64c-$RELEASE-RELEASE
	done

	pot create-base -r $FREEBSD_VERSION

fi
echo Installing flavours to $(realpath ${FLAVOURS})
install -m 644 flavours/github-act flavours/github-act-configured ${FLAVOURS}
install flavours/bootstrap ${FLAVOURS}
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
