#/bin/sh
set -euo pipefail

# Restart the host's GitHub Actions service

poll=$(gh_actions_status | grep -o "not running")
if [ $poll ]; then
    echo "[debug] gh_actions has stopped; restarting now"
    service gh_actions_start
fi
