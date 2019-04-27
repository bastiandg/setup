#!/usr/bin/env bash

set -eu -o pipefail
basedir="$(dirname "$(readlink -f "$0")")"
INSTALL_PATH="/opt/appimage/nextcloud"
release="$(curl -sS "https://api.github.com/repos/nextcloud/desktop/releases/latest")"
download_url="$(echo "$release" | grep -oP '(?<=\[Linux\]\().*.AppImage(?=\)\ )')"

versioncheck () {
	localversion="v$("$INSTALL_PATH" --version 2> /dev/null | grep -oP '(?<=Nextcloud version )[0-9.]*(?=git)' || true)"
	remoteversion="$(echo "$release" | jq -r '.tag_name')"
	if [ "$localversion" = "$remoteversion" ] ; then
		echo "nextcloud is up to date $localversion"
		exit 0
	fi
}

versioncheck
TMPDIR="$(mktemp -d)"

cd "$TMPDIR"
curl -sSLf -o "nextcloud" "${download_url}"
chmod +x "nextcloud"

sudo mv "nextcloud" "$INSTALL_PATH"

cd "$basedir"
rm -rf "$TMPDIR"
