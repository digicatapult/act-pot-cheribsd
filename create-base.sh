#!/bin/sh
set -eo pipefail
if [ ! "${CHERIBSD_BUILD_ID}" ]; then
    mkdir -p /usr/local/share/freebsd/MANIFESTS/
    ARCH=$(curl -s \
        https://download.cheribsd.org/releases/arm64/aarch64c/ | \
        grep -Eo "\w{1,}\.\w{1,}" | sort -u)
    for RELEASE in $ARCH; do
        curl -C - "https://download.cheribsd.org/releases/arm64/aarch64c/$RELEASE/ftp/MANIFEST" > \
        /usr/local/share/freebsd/MANIFESTS/arm64-aarch64c-$RELEASE-RELEASE
    done
    echo Finished downloading the most recent CheriBSD manifests

    CHERIBSD_BUILD_ID=$(echo $ARCH | awk -F " " '{print $NF}')
fi

if [ ! $(pot ls -b | grep -o ${CHERIBSD_BUILD_ID}) ]; then
    echo Creating base pot for $CHERIBSD_BUILD_ID

    pot create-base -r $CHERIBSD_BUILD_ID
else
    echo Found an existing base pot for CheriBSD $CHERIBSD_BUILD_ID
fi
