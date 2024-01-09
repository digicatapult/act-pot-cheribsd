#!/bin/sh
export PAGER=/bin/cat

# Update to the latest stable release
case $( . /etc/os-release; echo $NAME ) in
    FreeBSD)
    freebsd-update --not-running-from-cron fetch install
    ;&
    CheriBSD)
    echo skipped freebsd-update for CheriBSD
    done
    ;;
esac

# Install dependencies
pkg64 ins -y git node bash

# Install the runner
curl -LO https://github.com/ChristopherHX/github-act-runner/releases/download/v0.6.7/binary-freebsd-arm.tar.gz
tar -xvf binary-freebsd-arm.tar.gz github-act-runner
cp github-act-runner /usr/local/bin/github-act-runner

# Create the config directory
mkdir /root/runner

# Provide a wrapper script to run the action runner once.
cat <<EOF > /root/ci.sh
#!/bin/sh
cd /root/runner
github-act-runner run --once
EOF
chmod +x /root/ci.sh
