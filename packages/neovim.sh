#!/usr/bin/env bash

set -eu -o pipefail

BASEDIR="$(dirname "$(readlink -f "$0")")"
RELEASE_URL="https://api.github.com/repos/neovim/neovim/releases/latest"

versioncheck () {
	set +eu
	localversion="$(nvim --version 2> /dev/null | grep -oP '(?<=NVIM ).*(?=$)')"
	set -eu
	remoteversion="$(curl -s "$RELEASE_URL" | jq -r ".name"| grep -oP '(?<=NVIM ).*(?=$)')"
	if [ "$localversion" = "v$remoteversion" ] ; then
		echo "neovim is up to date (version $localversion)"
		exit 0
	else
		echo "updating neovim from $localversion to $remoteversion"
	fi
}
versioncheck

#################################################################################
# setup exit handler
#################################################################################
onexit() {
	cd "$BASEDIR"
	echo "Script is terminating -- cleaning up"
	if [ -d "$TMPDIR" ] ; then
		sudo rm -rf "$TMPDIR"
	fi
	exit
}

trap onexit EXIT
trap '' INT TERM # Ignore SigINT and SigTERM

sudo apt-get update -y
sudo apt-get install -y jq curl libtool libtool-bin autoconf automake cmake g++ pkg-config unzip python3-pip

TMPDIR="$(mktemp -d)"
URL="$(curl -s "$RELEASE_URL" | jq -r ".zipball_url")"

cd "$TMPDIR"
curl -L -o neovim.zip "$URL"
unzip -o neovim.zip
cd neovim-neovim*
export LC_ALL=C
make -j"$(nproc --all)" CMAKE_BUILD_TYPE=Release
sudo make install
pip3 install --upgrade neovim

if [ ! -e "$HOME/.config/nvim/" ] ; then
	cp -r "$HOME/.vim" "$HOME/.config/nvim"
	cp "$HOME/.vimrc" "$HOME/.config/nvim/init.vim"
fi
