#!/bin/sh
set -eo pipefail

# Ensure GITHUB_PAT and GITHUB_ORG environment variables are set
if [ -z "$GITHUB_PAT" ] || [ -z "$GITHUB_ORG" ]; then
    echo "Error: GITHUB_PAT and GITHUB_ORG environment variables must be set."
    exit 1
fi

# Generate a new GitHub Actions runner registration token for the organization
TOKEN=$(curl -s -X POST -H "Authorization: token $GITHUB_PAT" \
                  -H "Accept: application/vnd.github+json" \
                  "https://api.github.com/orgs/$GITHUB_ORG/actions/runners/registration-token" | jq -r .token)

if [ "$TOKEN" = "null" ]; then
    echo "Failed to generate token. Check if your GITHUB_PAT is correct and has the required permissions."
    exit 1
fi

echo "Generated Token: $TOKEN"

EXTRA_FLAVOURS=
if [ "${RUNNER_FLAVOURS}" ] ; then
    for F in $RUNNER_FLAVOURS ; do
        echo Adding flavour ${F} to the pot
        EXTRA_FLAVOURS="${EXTRA_FLAVOURS} -f ${F}"
    done
fi

mkdir -p ${RUNNER_CONFIG_DIRECTORY}
cd ${RUNNER_CONFIG_DIRECTORY}

pot create -p ${POTNAME} -b ${FREEBSD_VERSION} -t single -f github-act ${EXTRA_FLAVOURS} -f github-act-configured

# Save the token in a place where the github-act-configure.sh script can access it
echo $TOKEN > "${RUNNER_CONFIG_DIRECTORY}/${POTNAME}_token"

echo
echo Created pot:
echo ${POTNAME}
