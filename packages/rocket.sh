#!/usr/bin/env bash

BASEDIR="$(dirname "$(readlink -f "$0")")"
URL="$(curl "https://api.github.com/repos/RocketChat/Rocket.Chat.Electron/releases/latest" 2> /dev/null | jq -r '.assets[] | select(.browser_download_url | contains ("amd64.deb")) | .browser_download_url')"



versioncheck () {
	localversion="$(dpkg-query --showformat='${Version}' --show rocketchat | sed -re "s#-[0-9]+##g")"
	remoteversion="$(curl "https://api.github.com/repos/RocketChat/Rocket.Chat.Electron/releases/latest" 2> /dev/null | jq -r ".name")"
	if [ "$localversion" = "$remoteversion" ] ; then
		echo "rocketchat is up to date"
		exit 0
	fi
}

versioncheck
TMPDIR="$(mktemp -d)"

cd "$TMPDIR"
curl -L -o "rocket.deb" "${URL}"

sudo aptitude remove -y rocketchat-desktop
sudo dpkg -i "rocket.deb"

cd "$BASEDIR"
rm -rf "$TMPDIR"
