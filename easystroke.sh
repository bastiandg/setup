#!/usr/bin/env bash

TMPDIR="/tmp/easystroke"
sudo aptitude update

sudo aptitude install -y build-essential g++ libboost-serialization-dev libgtkmm-3.0-dev libxtst-dev libdbus-glib-1-dev intltool xserver-xorg-dev #build dependency easystroke
git clone https://github.com/thjaeger/easystroke.git "$TMPDIR"
cp lambda.patch "$TMPDIR"
cd "$TMPDIR"
patch < lambda.patch
make -j4
sudo make install
cd "$BASEDIR"
rm -rf "$TMPDIR"

if [ -d "$HOME/dotfiles/.easystroke" ] ; then
	cp -vr "$HOME/dotfiles/.easystroke" "$HOME/"
else
	echo "dotfiles missing" 1>&2
fi

