#!/usr/bin/env bash

BASEDIR="$(dirname "$(readlink -f "$0")")"
FONT_NAME="emojione"
URL="$(curl "https://api.github.com/repos/eosrei/emojione-color-font/releases/latest" 2> /dev/null | jq -r '.assets[] | select(.browser_download_url | contains ("Linux")) | .browser_download_url')"
TMPDIR="$(mktemp -d)"

sudo aptitude update

sudo aptitude install -y ttf-bitstream-vera

cd "$TMPDIR"
curl -L -o "${FONT_NAME}.tar.gz" "${URL}"

# 2. Uncompress the file
tar zxf "${FONT_NAME}.tar.gz"

# 3. Run the installer
cd "EmojiOne"*/
./install.sh
cd "$BASEDIR"
rm -rf "$TMPDIR"
