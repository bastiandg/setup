#!/usr/bin/env bash
set -eu -o pipefail

BASEDIR="$(dirname "$(readlink -f "$0")")"
URL="$(curl "https://api.github.com/repos/VSCodium/vscodium/releases/latest" 2> /dev/null | jq -r '.assets[] | select(.browser_download_url | endswith("amd64.deb")) | .browser_download_url')"

echo "$URL"

versioncheck () {
	localversion="$( (vscodium --version | head -1) || true)"
	remoteversion="$(curl "https://api.github.com/repos/VSCodium/vscodium/releases/latest" 2> /dev/null | jq -r ".name")"
	if [ "$localversion" = "$remoteversion" ] ; then
		echo "vscodium is up to date ($localversion)"
		exit 0
	fi
}

versioncheck
TMPDIR="$(mktemp -d)"

cd "$TMPDIR"
curl -L -o "vscodium.deb" "${URL}"
sudo dpkg -i "vscodium.deb"

cd "$BASEDIR"
rm -rf "$TMPDIR"
