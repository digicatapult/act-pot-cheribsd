#!/bin/sh
export PAGER=/bin/cat

# Update to the latest stable release
case $( . /etc/os-release; echo $NAME ) in
    FreeBSD)
    freebsd-update --not-running-from-cron fetch install
    ;&
    CheriBSD)
    echo skipped freebsd-update for CheriBSD
    ;;
esac

# Install dependencies
cp -fR /root/lib64 /usr
rm -R /root/lib64
cp -fR /root/lib64cb /usr
rm -R /root/lib64cb

if [ $(which pkg64c) ]; then
    for pkg in pkg64 pkg64c pkg64cb; do
        $pkg -N || $pkg bootstrap -fy
    done
else
    echo "[err] failed to find pkg64c"
    exit
fi

pkg64 install -fy git node bash

# Install the runner
curl -LO https://github.com/ChristopherHX/github-act-runner/releases/download/v0.6.7/binary-freebsd-arm64.tar.gz
tar -xvf binary-freebsd-arm64.tar.gz github-act-runner
cp github-act-runner /usr/local64/bin/github-act-runner

# Create the config directory
mkdir /root/runner

# Provide a wrapper script to run the action runner once.
cat <<EOF > /root/ci.sh
#!/bin/sh
cd /root/runner
GODEBUG="asyncpreemptoff=1" github-act-runner run --once
EOF
chmod +x /root/ci.sh
