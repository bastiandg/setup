#!/usr/bin/env bash

set -eu -o pipefail

INSTALLDIR="/opt/firefox"
PUID="1000" #user who "owns" the software
BASEDIR="$(dirname "$(readlink -f "$0")")"
LANGUAGE="de" # Language code (examples nl, en-US, en-CA)
DOWNLOADURL="https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=${LANGUAGE}"

versioncheck () {
	set +eu
	localversion="$(firefox --version 2> /dev/null | grep -oP '(?<=Mozilla Firefox ).*(?=$)')"
	set -eu
	remoteversion="$(curl -s "$DOWNLOADURL" | grep -oP '(?<=releases/).*(?=.linux-x86_64)')"
	if [ "$localversion" = "$remoteversion" ] ; then
		echo "firefox is up to date"
		exit 0
	fi
}

versioncheck
if [ -n "$(dpkg-query -W -f='${Status}' firefox-esr | grep "\<installed\>" || true)" ] ; then
	sudo apt remove -y firefox-esr
fi

if [ -d "$INSTALLDIR" ] ; then
	sudo rm -r "$INSTALLDIR"
fi
TMPDIR="$(mktemp -d)"
cd "$TMPDIR"
wget "$DOWNLOADURL" -O firefox.tar.bz2
tar xvjf firefox.tar.bz2
sudo cp -vr firefox "$INSTALLDIR"
sudo chown -R "$PUID:$PUID" "$INSTALLDIR"
sudo ln -sf "$INSTALLDIR/firefox" /usr/bin/firefox
cd "$BASEDIR"
rm -rf "$TMPDIR"
sudo cp "$BASEDIR/../files/firefox.desktop" "/usr/share/applications/firefox.desktop"
