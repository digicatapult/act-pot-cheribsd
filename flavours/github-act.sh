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
cp -fR /root/lib64cb /usr
rm -R /root/lib64
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

# Define the repository
REPO_OWNER="ChristopherHX"
REPO_NAME="github-act-runner"

# Fetch all tags from GitHub
TAGS=$(curl -s "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/tags" | grep '"name":' | cut -d '"' -f 4)

# Filter and sort versions, assuming they're in the form of 'vX.Y.Z' or 'X.Y.Z'
HIGHEST_VERSION=$(echo "$TAGS" | sed 's/^v//' | sort -V | tail -n 1)

# Construct the download URL
DOWNLOAD_URL="https://github.com/$REPO_OWNER/$REPO_NAME/releases/download/v$HIGHEST_VERSION/binary-freebsd-arm64.tar.gz"

# Download the highest version release
curl -LO "$DOWNLOAD_URL"

# Extract the downloaded tarball
tar -xvf "binary-freebsd-arm64.tar.gz" github-act-runner

# Move the binary to the desired location
cp github-act-runner /usr/local64/bin/github-act-runner

# Optional: Cleanup downloaded and extracted files
rm "binary-freebsd-arm64.tar.gz"
rm -r github-act-runner

echo "Installation of github-act-runner version $HIGHEST_VERSION completed."

# Create the config directory
mkdir /root/runner

# Provide a wrapper script to run the action runner once.
cat <<EOF > /root/ci.sh
#!/bin/sh
cd /root/runner
GODEBUG="asyncpreemptoff=1" github-act-runner run --once
EOF
chmod +x /root/ci.sh
