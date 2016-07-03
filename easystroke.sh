#!/usr/bin/env bash

mkdir /tmp/easystroke
git clone git://github.com/thjaeger/easystroke.git /tmp/easystroke
cd /tmp/easystroke
make -j2
sudo make install
cd "$BASEDIR"
rm -rf /tmp/easystroke

if [ -f "$HOME/dotfiles/.easystroke" ] ; then
	cp -vr "$HOME/dotfiles/.easystroke" "$HOME/"
else
	echo "dotfiles missing" 1>&2
fi

