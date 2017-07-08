#!/usr/bin/env bash

BASEDIR="$(dirname "$(readlink -f "$0")")"
TMPDIR="$(mktemp -d)"
VERSION="$(curl "https://releases.hashicorp.com/vagrant/" 2> /dev/null | grep -m 1 'href="/vagrant' | sed -re "s#.*vagrant_([0-9.]*)</a>#\1#")"
echo "Installing vagrant $VERSION"
cd "$TMPDIR"
curl -o vagrant.deb "https://releases.hashicorp.com/vagrant/${VERSION}/vagrant_${VERSION}_x86_64.deb"
sudo dpkg -i vagrant.deb
cd "$BASEDIR"
rm -rf "$TMPDIR"
