#!/usr/bin/env bash
set -eu -o pipefail

INSTALLPATH="/usr/local/bin/"
URL="$(curl "https://api.github.com/repos/hadolint/hadolint/releases/latest" 2>/dev/null | jq -r '.assets[] | select(.browser_download_url | contains ("Linux-x86_64")) | .browser_download_url')"

versioncheck() {
  localversion="$( (hadolint --version | sed -r 's#Haskell Dockerfile Linter (v[0-9]+\.[0-9]+\.[0-9]*)-.*#\1#g') || true)"
  remoteversion="$(curl "https://api.github.com/repos/hadolint/hadolint/releases/latest" 2>/dev/null | jq -r ".name")"
  if [ "$localversion" = "$remoteversion" ]; then
    echo "hadolint is up to date ($localversion)"
    exit 0
  fi
}

versioncheck

sudo curl -L -o "${INSTALLPATH}/hadolint" "$URL"
sudo chmod +x "${INSTALLPATH}/hadolint"
