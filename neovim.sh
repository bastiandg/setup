#!/usr/bin/env bash

GITDIR="$(mktemp -d)"
GITURL="https://github.com/neovim/neovim.git"

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

sudo aptitude update
sudo aptitude install -y libtool libtool-bin autoconf automake cmake g++ pkg-config unzip

git clone "$GITURL" "$GITDIR"
cd "$GITDIR"

export LC_ALL=C
make -j4 CMAKE_BUILD_TYPE=Release
sudo make install

grep 'alias vim="nvim"' "$HOME/.bashrc.local" &> /dev/null

if [ "$?" != "0" ] ; then
	echo 'alias vim="nvim"' >> "$HOME/.bashrc.local"
	echo 'alias vi="nvim"' >> "$HOME/.bashrc.local"
fi

