#!/usr/bin/env bash

LOG="install.log"
exec &> >(tee "$LOG") 2>&1
BASEDIR="$(dirname "$(readlink -f "$0")")"

"$BASEDIR/packages/package.sh"
"$BASEDIR/packages/gitconfig.sh"
"$BASEDIR/packages/dotfiles.sh"
"$BASEDIR/packages/font.sh"
"$BASEDIR/packages/easystroke.sh"
"$BASEDIR/packages/thunderbird.sh"

