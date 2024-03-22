#!/bin/sh
set -eu

# Print health status

pots=$(pot ls -p -q | wc -l)
runners=$(sysrc gh_actions_pots | wc -l)
if [ "$(echo $pots)" -gt 0 ] || [ "$(echo $runners)" -gt 0 ]; then
    echo "Runner health check: $(date -R)
$pots pot(s) found
$runners runner(s) configured to start automatically"
fi
