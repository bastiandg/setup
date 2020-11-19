#!/usr/bin/env bash

set -eu -o pipefail

BASEDIR="$(dirname "$(readlink -f "$0")")"
TMPDIR="$(mktemp -d)"
URL="$(curl "https://api.github.com/repos/adobe-fonts/source-code-pro/releases/latest" 2>/dev/null | jq -r '.assets[] | select(.name | startswith("OTF-")) | .browser_download_url')"

cd "$TMPDIR"
curl -L -o "sc-pro.zip" "${URL}"
unzip "sc-pro.zip"
cp -- OTF/*.otf "$HOME/.fonts"
mkdir -p "$HOME/.fonts"
fc-cache -f -v

cd "$BASEDIR"
rm -rf "$TMPDIR"
