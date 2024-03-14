#!/bin/sh
set -eo pipefail

# Ensure GITHUB_PAT and GITHUB_ORG environment variables are set
if [ -z "$GITHUB_PAT" ] || [ -z "$GITHUB_ORG" ]; then
    echo "Error: GITHUB_PAT and GITHUB_ORG environment variables must be set."
    exit 1
fi

# Generate a new GitHub Actions runner registration token for the organisation
GITHUB_TOKEN=$(curl -s -X POST -H "Authorization: token $GITHUB_PAT" \
    -H "Accept: application/vnd.github+json" \
    "https://api.github.com/orgs/$GITHUB_ORG/actions/runners/registration-token" | grep "token" | cut -d '"' -f 4)

if [ "$GITHUB_TOKEN" = "null" ]; then
    echo "Failed to generate token. Check if your GITHUB_PAT is correct and has the required permissions."
    exit 1
fi

echo "Generated Token: $GITHUB_TOKEN"

# Export the token so that other scripts (e.g. config.sh) can access it
export $GITHUB_TOKEN
