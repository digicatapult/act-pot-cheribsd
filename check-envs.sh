if [ ! "${CHERIBSD_BUILD_ID}" ] ; then
	ARCH=$(curl -s \
	https://download.cheribsd.org/releases/arm64/aarch64c/ | \
		grep -Eo "\w{1,}\.\w{1,}" | sort -u)
	CHERIBSD_BUILD_ID=$(echo ${ARCH} | awk -F " " '{print $NF}')
	echo CHERIBSD_BUILD_ID not set, using ${CHERIBSD_BUILD_ID}
fi
if [ ! "${RUNNER_NAME}" ] ; then
	RUNNER_NAME=CheriBSD-${CHERIBSD_BUILD_ID}-${RANDOM}
	echo RUNNER_NAME not set, using ${RUNNER_NAME}
fi
if [ ! "${POT_MOUNT_BASE}" ] ; then
	POT_MOUNT_BASE=/opt/pot/
	echo POT_MOUNT_BASE not set, using ${POT_MOUNT_BASE}
fi
if [ -z "$GITHUB_TOKEN" ] || [ -z "$GITHUB_ORG" ]; then
	echo "One or both environment variables are unset. Sourcing them from /root/.profile..."
	. /root/.profile
		# Re-check to confirm they are now set
		if [ -z "$GITHUB_TOKEN" ] || [ -z "$GITHUB_ORG" ]; then
			echo "Error: Environment variables could not be sourced from /root/.profile."
		fi
	else
		echo "Both environment variables are already set."
fi
# Set the pot name to use underscores in place of dots (the one character pot
# names are apparently not allowed).
# FIXME: We shouldn't be allowing anything that isn't allowed in a path
# component here either.
POTNAME=$(echo ${RUNNER_NAME} | sed 's/\./_/g')
RUNNER_CONFIG_DIRECTORY=`pwd`/runners/${POTNAME}
