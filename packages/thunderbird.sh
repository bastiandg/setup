#!/usr/bin/env bash

INSTALLDIR="/opt/"
PUID="1000" #user who "owns" the software
BASEDIR="$(dirname "$(readlink -f "$0")")"

if [ ! -d "$INSTALLDIR/thunderbird" ] ; then
	DOWNLOADURL="https://download.mozilla.org/?product=thunderbird-latest&os=linux64&lang=de"

	mkdir -p /tmp/thunderbird
	cd /tmp/thunderbird
	wget "$DOWNLOADURL" -O thunderbird.tar.bz2
	tar xvjf thunderbird.tar.bz2
	sudo cp -vr thunderbird "$INSTALLDIR/thunderbird"
	sudo chown -R "$PUID":"$PUID" "$INSTALLDIR/thunderbird"
	sudo ln -s "$INSTALLDIR/thunderbird/thunderbird" /usr/bin/thunderbird
	cd "$BASEDIR"
	rm -rf /tmp/thunderbird
	sudo cp "$BASEDIR/../files/thunderbird.desktop" "/usr/share/applications/thunderbird.desktop"
fi
