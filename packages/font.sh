#!/usr/bin/env bash

FONT_NAME="SourceCodePro"
BASEDIR="$(dirname "$(readlink -f "$0")")"
TMPDIR="$(mktemp -d)"
URL="$(curl "https://api.github.com/repos/adobe-fonts/source-code-pro/releases/latest" 2> /dev/null | jq -r ".zipball_url")"

cd "$TMPDIR"
curl -L -o "${FONT_NAME}.zip" "${URL}"
unzip -o -j "${FONT_NAME}.zip"
mkdir -p "$HOME/.fonts"
cp -- *.otf "$HOME/.fonts"
fc-cache -f -v

cd "$BASEDIR"
rm -rf "$TMPDIR"

