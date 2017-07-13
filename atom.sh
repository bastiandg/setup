#!/usr/bin/env bash

BASEDIR="$(dirname "$(readlink -f "$0")")"
TMPDIR="$(mktemp -d)"
URL="https://atom.io/download/deb"
echo "Installing atom"
cd "$TMPDIR"
curl -L -o atom.deb "$URL"
sudo dpkg -i atom.deb
cd "$BASEDIR"
rm -rf "$TMPDIR"
