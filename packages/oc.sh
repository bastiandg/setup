#!/usr/bin/env bash
set -eu -o pipefail

RELEASE_URL="https://api.github.com/repos/openshift/origin/releases/latest"
response="$(curl -s "$RELEASE_URL")"
download_url="$(jq -r '.assets[] | select(.browser_download_url | test("client.*linux-64bit")) | .browser_download_url' <<<"$response")"

versioncheck() {
  localversion="$(oc version 2>/dev/null | head -1 | sed -re 's#oc (v[0-9.]+)\+.*#\1#g' || true)"
  remoteversion="$(jq -r ".tag_name" <<<"$response")"
  if [[ $localversion == "${remoteversion}" ]]; then
    echo "oc is up to date ($localversion)"
    exit 0
  fi
}

versioncheck
tmpdir="$(mktemp -d)"
cd "$tmpdir"
curl -sSfL -o oc.tgz "$download_url"
tar xzf oc.tgz
sudo mv openshift-origin-client*/oc /usr/local/bin
