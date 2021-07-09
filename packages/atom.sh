#!/usr/bin/env bash

BASEDIR="$(dirname "$(readlink -f "$0")")"
URL="https://atom.io/download/deb"

versioncheck() {
  localversion="$(atom --version | grep "Atom" | sed -re 's/Atom\s+:\s+(1.*)/\1/g')"
  remoteversion="$(curl "https://api.github.com/repos/atom/atom/releases/latest" 2>/dev/null | jq -r ".name")"
  if [ "$localversion" = "$remoteversion" ]; then
    echo "Atom is up to date"
    exit 0
  fi
}

versioncheck
TMPDIR="$(mktemp -d)"
echo "Installing atom"
cd "$TMPDIR"
curl -L -o atom.deb "$URL"
sudo dpkg -i atom.deb
cd "$BASEDIR"
rm -rf "$TMPDIR"
