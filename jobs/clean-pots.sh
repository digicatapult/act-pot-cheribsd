#/bin/sh
set -euo pipefail

# Remove any misconfigured jails

pots=$(pot list 2>/dev/null | \
    grep -E 'pot name : [a-zA-Z0-9\-_]{1,}' | cut -d ' ' -f 4)

for pot in $pots; do
    dir=/opt/pot/jails/$pot
    err=$(pot info -p $pot | grep -o ' NO ')
    if [ $err ]; then
        rm -rdf $dir
        echo "[warning] $pot is missing its pot.conf; removing pot"
    fi
done
