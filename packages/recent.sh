#!/usr/bin/env bash
set -e
BASEDIR="$(dirname "$(readlink -f "$0")")"

cd "$BASEDIR"

rm -rf "$HOME/.kde/share/apps/RecentDocuments/"*
rm -f "$HOME/.local/share/recently-used.xbel"
echo "" >"$HOME/.local/share/recently-used.xbel"
rm -rf "$HOME/.local/share/kactivitymanagerd/resources/"*

cp -f "../files/gwenviewrc" "$HOME/.config/"
cp -f "../files/org.kde.gwenviewrc" "$HOME/.config/"

chmod -w "$HOME/.local/share/recently-used.xbel"
chmod -w "$HOME/.kde/share/apps/RecentDocuments/"
chmod -w "$HOME/.local/share/kactivitymanagerd/resources/"
chmod -w "$HOME/.config/gwenviewrc"
chmod -w "$HOME/.config/org.kde.gwenviewrc"
