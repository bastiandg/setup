#!/usr/bin/env bash
set -eu -o pipefail

response="$(curl -s "https://api.github.com/repos/mvdan/sh/releases/latest")"
download_url="$(jq -r '.assets[] | select(.browser_download_url | contains("linux_amd64")) | .browser_download_url' <<<"$response")"
#-linux_amd64

versioncheck() {
  localversion="$(shfmt --version 2>/dev/null || true)"
  remoteversion="$(jq -r ".tag_name" <<<"$response")"
  if [ "$localversion" = "$remoteversion" ]; then
    echo "shfmt is up to date ($localversion)"
    exit 0
  fi
}

versioncheck
sudo curl -L -o "/usr/local/bin/shfmt" "$download_url"
sudo chmod +x /usr/local/bin/shfmt
