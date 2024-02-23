#!/bin/sh
set -euo pipefail
POT=$(which pot)
FLAVOURS=$(dirname ${POT})/../etc/pot/flavours
if [ ! -d ${FLAVOURS} ]; then
	echo "Can't locate pot install"
	exit 1
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
