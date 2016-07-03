#!/usr/bin/env bash

sudo aptitude update

sudo aptitude install -y build-essential g++ libboost-serialization-dev libgtkmm-3.0-dev libxtst-dev libdbus-glib-1-dev intltool xserver-xorg-dev #build dependency easystroke
mkdir /tmp/easystroke
git clone https://github.com/thjaeger/easystroke.git /tmp/easystroke
cd /tmp/easystroke
make -j4
sudo make install
cd "$BASEDIR"
rm -rf /tmp/easystroke

if [ -d "$HOME/dotfiles/.easystroke" ] ; then
	cp -vr "$HOME/dotfiles/.easystroke" "$HOME/"
else
	echo "dotfiles missing" 1>&2
fi

