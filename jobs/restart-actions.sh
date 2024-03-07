#!/bin/sh
set -euo pipefail

# Where necessary, clear the old set of runners and replace them

old_set=$(sysrc -n -q gh_actions_pots)
new_set=$(pot ls -p -q)
if [ ! "$(echo $old_set)" == "$(echo $new_set)" ]; then
    echo "Adding new runners to rc.conf:" $new_set
    sysrc -q -x gh_actions_pots
    echo gh_actions_pots=\"$new_set\" >> /etc/rc.conf
fi

# Restart the host's GitHub Actions service

if [ "$(sysrc -n gh_actions_enable)" == "YES" ]; then
    echo "Starting all available runners"
    service gh_actions start
fi
