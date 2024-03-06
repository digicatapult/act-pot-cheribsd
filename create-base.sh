#!/bin/sh
set -eo pipefail
if [ ! "${FREEBSD_VERSION}" ]; then
    mkdir -p /usr/local/share/freebsd/MANIFESTS/
    ARCH=$(curl -s \
        https://download.cheribsd.org/releases/arm64/aarch64c/ | \
        grep -Eo "\w{1,}\.\w{1,}" | sort -u)
    for RELEASE in $ARCH; do
        curl -C - "https://download.cheribsd.org/releases/arm64/aarch64c/$RELEASE/ftp/MANIFEST" > \
        /usr/local/share/freebsd/MANIFESTS/arm64-aarch64c-$RELEASE-RELEASE
    done
    echo Finished downloading the most recent CheriBSD manifests

    FREEBSD_VERSION=$(echo $ARCH | awk -F " " '{print $NF}')
fi

if [ ! $(pot ls -b | grep -o ${FREEBSD_VERSION}) ]; then
    echo Creating base pot for $FREEBSD_VERSION

    pot create-base -r $FREEBSD_VERSION
else
    echo Found an existing base pot for CheriBSD $FREEBSD_VERSION
fi
