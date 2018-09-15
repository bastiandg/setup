#!/usr/bin/env bash

BASEDIR="$(dirname "$(readlink -f "$0")")"
TMPDIR="$(mktemp -d)"

set -eu -o pipefail

#################################################################################
# setup exit handler
#################################################################################
onexit() {
	cd "$BASEDIR"
	echo "Script is terminating -- cleaning up"
	sudo rm -rf "$TMPDIR"
	exit
}

trap onexit EXIT
trap '' INT TERM # Ignore SigINT and SigTERM

sudo apt update
sudo apt install -y jq curl libtool libtool-bin autoconf automake cmake g++ pkg-config unzip python3-pip

URL="$(curl -s "https://api.github.com/repos/neovim/neovim/releases/latest" | jq -r ".zipball_url")"

cd "$TMPDIR"
curl -L -o neovim.zip "$URL"
unzip -o neovim.zip
cd neovim-neovim*
export LC_ALL=C
make -j"$(nproc --all)" CMAKE_BUILD_TYPE=Release
sudo make install
pip3 install --upgrade neovim

set +e
grep 'alias vim="nvim"' "$HOME/.bashrc.local" &> /dev/null
set -e

if [ "$?" != "0" ] ; then
	echo 'alias vim="nvim -u ~/.vimrc"' >> "$HOME/.bashrc.local"
	echo 'alias vi="vim"' >> "$HOME/.bashrc.local"
fi

if [ ! -e "$HOME/.config/nvim/" ] ; then
	cp -r "$HOME/.vim" "$HOME/.config/nvim"
	cp "$HOME/.vimrc" "$HOME/.config/nvim/init.vim"
fi

