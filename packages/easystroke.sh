#!/usr/bin/env bash

set -eu -o pipefail

BASEDIR="$(dirname "$(readlink -f "$0")")"
TMPDIR="$(mktemp -d)"
URL="https://github.com/thjaeger/easystroke.git"
if which easystroke &> /dev/null ; then
	echo "easystroke is already installed"
	exit 0
fi
sudo apt-get update

sudo apt-get install -y build-essential g++ libboost-serialization-dev libgtkmm-3.0-dev libxtst-dev libdbus-glib-1-dev intltool xserver-xorg-dev #build dependency easystroke
git clone "$URL" "$TMPDIR"
cp "$BASEDIR/../files/lambda.patch" "$TMPDIR"
cp "$BASEDIR/../files/abs.patch" "$TMPDIR"
cd "$TMPDIR"
patch < lambda.patch
patch < abs.patch
make -j4
sudo make install
cd "$BASEDIR"
rm -rf "$TMPDIR"

if [ -d "$HOME/dotfiles/.easystroke" ] ; then
	cp -vr "$HOME/dotfiles/.easystroke" "$HOME/"
else
	echo "dotfiles missing" 1>&2
fi

