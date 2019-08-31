#!/usr/bin/env bash

GITDIR="$(mktemp -d)"
GITURL="https://github.com/vim/vim"

#################################################################################
# setup exit handler
#################################################################################
onexit() {
	echo "Script is terminating -- cleaning up"
	rm -rf "$GITDIR"
	exit
}

trap onexit EXIT
trap '' INT TERM # Ignore SigINT and SigTERM

sudo apt-get update
sudo apt-get install -y liblua5.1-0-dev luajit libluajit-5.1-dev build-essential

git clone "$GITURL" "$GITDIR"
cd "$GITDIR"

export LC_ALL=C
export LANG=C
./configure --with-features=huge --enable-rubyinterp --enable-luainterp --with-luajit
make -j4
sudo make install
cd "$HOME"
rm -rf "$GITDIR"
