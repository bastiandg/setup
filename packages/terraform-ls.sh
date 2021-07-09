#!/usr/bin/env bash
set -eu -o pipefail

RELEASE_URL="https://api.github.com/repos/hashicorp/terraform-ls/releases/latest"
response="$(curl -s "$RELEASE_URL")"
download_url="$(jq -r '.assets[] | select(.browser_download_url | contains("linux_amd64")) | .browser_download_url' <<< "$response")"
#-linux_amd64

versioncheck () {
	localversion="$(terraform-ls version 2> /dev/null | head -1 || true)"
	remoteversion="$(jq -r ".tag_name" <<< "$response")"
	if [[ "v${localversion}" = "${remoteversion}" ]] ; then
		echo "terraform-ls is up to date ($localversion)"
		exit 0
	fi
}

versioncheck
tmpdir="$(mktemp -d)"
cd "$tmpdir"
curl -sSfL -o tls.zip "$download_url"
unzip tls.zip
sudo mv terraform-ls /usr/local/bin
