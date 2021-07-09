#!/usr/bin/env bash
set -eu -o pipefail

RELEASE_URL="https://api.github.com/repos/mattn/efm-langserver/releases/latest"
response="$(curl -s "$RELEASE_URL")"
download_url="$(jq -r '.assets[] | select(.browser_download_url | contains("linux_amd64")) | .browser_download_url' <<<"$response")"
#-linux_amd64

versioncheck() {
  localversion="$(efm-langserver -v 2>/dev/null | awk '{print $2}' || true)"
  remoteversion="$(jq -r ".tag_name" <<<"$response")"
  if [[ "v${localversion}" == "${remoteversion}" ]]; then
    echo "terraform-ls is up to date ($localversion)"
    exit 0
  fi
}

versioncheck
tmpdir="$(mktemp -d)"
cd "$tmpdir"
curl -sSfL -o efm.tgz "$download_url"
tar xzf efm.tgz
sudo mv efm-langserver*/efm-langserver /usr/local/bin
