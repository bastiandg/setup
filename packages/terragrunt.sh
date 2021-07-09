#!/usr/bin/env bash

set -eu -o pipefail

BASEDIR="$(dirname "$(readlink -f "$0")")"
RELEASE_URL="https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest"
RESPONSE="$(curl -sL "$RELEASE_URL")"
DOWNLOAD_URL="$(jq -r '.assets[] | select(.browser_download_url | contains ("linux_amd64")) | .browser_download_url' <<<"$RESPONSE")"

versioncheck() {
  localversion="$(terragrunt --version 2>/dev/null | sed -re 's#terragrunt version (v[a-z0-9.-]*)#\1#g' || true)"
  remoteversion="$(jq -r ".name" <<<"$RESPONSE")"
  if [ "$localversion" = "$remoteversion" ]; then
    echo "terragrunt is up to date"
    exit 0
  else
    echo "terragrunt will be updated from $localversion to $remoteversion"
  fi
}

versioncheck
TMPDIR="$(mktemp -d)"

cd "$TMPDIR"
curl -L -o "terragrunt" "${DOWNLOAD_URL}"
chmod +x "terragrunt"
sudo mv terragrunt /usr/bin/terragrunt

cd "$BASEDIR"
rm -rf "$TMPDIR"
