#!/usr/bin/env bash
set -eu -o pipefail

BASEDIR="$(dirname "$(readlink -f "$0")")"
response="$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest")"
download_url="$(jq -r '.assets[] | select(.browser_download_url | test("git-delta_[0-9.]+_amd64.deb")) | .browser_download_url' <<<"$response")"

versioncheck() {
  localversion="$( (delta --version | awk '{print $2}') 2>/dev/null || true)"
  remoteversion="$(jq -r ".name" <<<"$response")"
  if [ "$localversion" = "$remoteversion" ]; then
    echo "delta is up to date ($localversion)"
    exit 0
  fi
}

versioncheck
TMPDIR="$(mktemp -d)"

cd "$TMPDIR"
curl -L -o "delta.deb" "$download_url"
sudo dpkg -i "delta.deb"

cd "$BASEDIR"
rm -rf "$TMPDIR"
