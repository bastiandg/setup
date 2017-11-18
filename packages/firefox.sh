#!/usr/bin/env bash

INSTALLDIR="/opt/"
PUID="1000" #user who "owns" the software
BASEDIR="$(dirname "$(readlink -f "$0")")"

if [ ! -d "$INSTALLDIR/firefox" ] ; then
	DOWNLOADURL="https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=de"

	mkdir -p /tmp/firefox
	cd /tmp/firefox
	wget "$DOWNLOADURL" -O firefox.tar.bz2
	tar xvjf firefox.tar.bz2
	sudo cp -vr firefox "$INSTALLDIR/firefox"
	sudo chown -R "$PUID":"$PUID" "$INSTALLDIR/firefox"
	sudo ln -s "$INSTALLDIR/firefox/firefox" /usr/bin/firefox
	cd "$BASEDIR"
	rm -rf /tmp/firefox
	sudo cp "$BASEDIR/../files/firefox.desktop" "/usr/share/applications/firefox.desktop"
fi
