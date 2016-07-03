#!/usr/bin/env bash

FONT_NAME="SourceCodePro"
URL="https://github.com/adobe-fonts/source-code-pro/archive/2.010R-ro/1.030R-it.zip"

mkdir "/tmp/adodefont"
cd "/tmp/adodefont"
wget "${URL}" -O "${FONT_NAME}.zip"
unzip -o -j "${FONT_NAME}.zip"
mkdir -p "$HOME/.fonts"
cp *.otf "$HOME/.fonts"
fc-cache -f -v

