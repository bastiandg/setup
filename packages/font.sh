#!/usr/bin/env bash

FONT_NAME="SourceCodePro"
BASEDIR="$(dirname "$(readlink -f "$0")")"
TMPDIR="$(mktemp -d)"
URL="$(curl "https://api.github.com/repos/adobe-fonts/source-code-pro/releases/latest" 2> /dev/null | jq -r '.assets[] | select(.name | contains("Variable-Roman.otf")) | .browser_download_url')"

cd "$TMPDIR"
curl -L -o "${FONT_NAME}.otf" "${URL}"
mkdir -p "$HOME/.fonts"
cp -- *.otf "$HOME/.fonts"
fc-cache -f -v

cd "$BASEDIR"
rm -rf "$TMPDIR"

