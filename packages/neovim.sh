#!/usr/bin/env bash

BASEDIR="$(dirname "$(readlink -f "$0")")"
TMPDIR="$(mktemp -d)"
URL="$(curl -s "https://api.github.com/repos/neovim/neovim/releases/latest" | jq -r ".zipball_url")"

#################################################################################
# setup exit handler
#################################################################################
onexit() {
	cd "$BASEDIR"
	echo "Script is terminating -- cleaning up"
	rm -rf "$TMPDIR"
	exit
}

trap onexit EXIT
trap '' INT TERM # Ignore SigINT and SigTERM

sudo aptitude update
sudo aptitude install -y libtool libtool-bin autoconf automake cmake g++ pkg-config unzip python3-pip

cd "$TMPDIR"
curl -L -o neovim.zip "$URL"
unzip -o neovim.zip
cd neovim-neovim*
export LC_ALL=C
make -j4 CMAKE_BUILD_TYPE=Release
sudo make install
pip3 install --upgrade neovim

grep 'alias vim="nvim"' "$HOME/.bashrc.local" &> /dev/null

if [ "$?" != "0" ] ; then
	echo 'alias vim="nvim -u ~/.vimrc"' >> "$HOME/.bashrc.local"
	echo 'alias vi="vim"' >> "$HOME/.bashrc.local"
fi

if [ ! -e "$HOME/.config/nvim/" ] ; then
	cp -r "$HOME/.vim" "$HOME/.config/nvim"
	cp "$HOME/.vimrc" "$HOME/.config/nvim/init.vim"
fi

