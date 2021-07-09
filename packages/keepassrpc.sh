#!/usr/bin/env bash
set -eu -o pipefail

response="$(curl -s "https://api.github.com/repos/kee-org/keepassrpc/releases/latest")"
download_url="$(jq -r '.assets[] | select(.browser_download_url | endswith("plgx")) | .browser_download_url' <<<"$response")"
filename="$(basename "$download_url")"

sudo curl -L -o "/usr/lib/keepass2/${filename}" "$download_url"
