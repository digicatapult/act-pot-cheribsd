#!/bin/sh

for I in `pwd`/runners/*/act-config.sh ; do
	if [ -f "$I" ] ; then
		RUNNER_FLAVOURS=
		CHERIBSD_BUILD_ID=
		RUNNER_NAME=
		POTNAME=
		. $I
		echo Recreating ${RUNNER_NAME}
		export RUNNER_FLAVOURS
		export CHERIBSD_BUILD_ID
		export RUNNER_NAME
		export POTNAME
		./recreate-runner.sh
	fi
done
