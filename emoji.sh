#!/usr/bin/env bash

FONT_NAME="emojione"
URL="https://github.com/eosrei/emojione-color-font/releases/download/v1.3/EmojiOneColor-SVGinOT-Linux-1.3.tar.gz"
TMPDIR="/tmp/emojione"

sudo aptitude update

sudo aptitude install -y ttf-bitstream-vera

mkdir "$TMPDIR"
cd "$TMPDIR"
wget "${URL}" -O "${FONT_NAME}.tar.gz"

# 2. Uncompress the file
tar zxf "${FONT_NAME}.tar.gz"

# 3. Run the installer
cd "EmojiOne"*/
./install.sh
cd "$HOME"
rm -rf "$TMPDIR"
