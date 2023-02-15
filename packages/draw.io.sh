#!/usr/bin/env bash
set -eu -o pipefail

basedir="$(dirname "$(readlink -f "$0")")"
RELEASE_URL="https://api.github.com/repos/jgraph/drawio-desktop/releases/latest"
response="$(curl -s "$RELEASE_URL")"
download_url="$(jq -r '.assets[] | select(.browser_download_url | test("amd64.*deb")) | .browser_download_url' <<<"$response")"

versioncheck() {
  localversion="v$(drawio --version 2>/dev/null || true)"
  remoteversion="$(jq -r ".tag_name" <<<"$response")"
  if [[ $localversion == "${remoteversion}" ]]; then
    echo "draw.io is up to date ($localversion)"
    exit 0
  else
    echo "updating draw.io from ${localversion} to ${remoteversion}"
  fi
}

versioncheck
tmpdir="$(mktemp -d)"
cd "$tmpdir"
curl -sSfL -o draw.io.deb "$download_url"
sudo dpkg -i draw.io.deb
cd "$basedir"
rm -rf "$tmpdir"
