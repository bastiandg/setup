#!/usr/bin/env bash

BASEDIR="$(dirname "$(readlink -f "$0")")"
GITDIR="$(mktemp -d)"
GITURL="https://github.com/neovim/neovim.git"

#################################################################################
# setup exit handler
#################################################################################
onexit() {
	cd "$BASEDIR"
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

if [ ! -e "$HOME/.config/nvim/" ] ; then
	cp -r "$HOME/.vim" "$HOME/.config/nvim"
	cp "$HOME/.vimrc" "$HOME/.config/nvim/init.vim"
fi

