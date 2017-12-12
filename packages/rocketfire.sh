#!/usr/bin/env bash
set -e

TMPDIR="$(mktemp -d)"
LOGOURL="https://github.com/RocketChat/Rocket.Chat.Artwork/raw/master/Logos/icon.svg"
BASEDIR="$(dirname "$(readlink -f "$0")")"

sudo cp "$BASEDIR/../files/rocket.desktop" "/usr/share/applications/rocket.desktop"
cd "$TMPDIR"
curl -L -o rocket.svg "$LOGOURL"
sudo cp rocket.svg /usr/share/icons/
cd "$BASEDIR"
rm -rf "$TMPDIR"
