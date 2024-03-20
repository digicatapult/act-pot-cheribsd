#!/bin/sh
set -eu

# Perform consistency checks on ZFS pools

if [ "$(zpool status | grep -c ONLINE)" -gt 0 ]; then
    for pool in $(zpool list -o name | tail -n 1); do
        /sbin/zpool scrub $pool
    done
fi
