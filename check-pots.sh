#!/bin/sh
set -eu

# Debug any running pots by performing a basic healthcheck

check_tree() {
    if [ -e $1 ]; then
        if [ "$(ls $1 | wc -l)" -eq 0 ]; then
            echo "[debug] $1 for $pot is empty"
        fi
    else
        echo "[warning] $1 for $pot was not found"
    fi
}

check_pot() {
    # Are needed rcvars enabled for the pot?
    rcvar=$(pot exec -p $pot sysrc sshd_enable)
    if [ "$(echo $rcvar | grep -o NO )" ]; then
        echo "[warning] sshd is disabled on $pot"
    fi

    # Is the pot configured to use pkg?
    for pkg in pkg64 pkg64c pk64cb; do
        if [ -z "$(pot exec -p $pot which $pkg)" ]; then
            echo "[warning] $pkg on $pot was not found"
        fi

        # Does the pot have mounted package caches?
        dir=/opt/pot/jails/$pot/m/var/cache/$pkg
        check_tree $dir
    done

    # Does the pot have mounted libraries?
    for lib in lib64 lib64c lib64cb; do
        dir=/opt/pot/jails/$pot/m/usr/$lib
        check_tree $dir
    done
}

echo "[debug] attempting healthchecks on all pots currently active"
pots=$(pot ps | grep -v '===' | wc -l)
if [ "$(echo $pots)" -gt 0 ]; then
    for pot in $pots; do
        echo "[debug] checking $pot"
        check_pot
    done
else
    echo "[debug] no active pots found"
fi

echo "[debug] healthchecks complete"
