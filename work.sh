#!/usr/bin/env bash

LOG="install.log"
exec &> >(tee "$LOG") 2>&1
BASEDIR="$(dirname "$(readlink -f "$0")")"

"$BASEDIR/packages/00packages.sh"
"$BASEDIR/packages/diff-so-fancy.sh"
"$BASEDIR/packages/easystroke.sh"
"$BASEDIR/packages/emoji.sh"
"$BASEDIR/packages/firefox.sh"
"$BASEDIR/packages/font.sh"
"$BASEDIR/packages/gitconfig.sh"
"$BASEDIR/packages/golang.sh"
"$BASEDIR/packages/kubectl.sh"
"$BASEDIR/packages/rocket.sh"
"$BASEDIR/packages/terraform.sh"
"$BASEDIR/packages/thunderbird.sh"

# IDE
"$BASEDIR/packages/dotfiles.sh"
"$BASEDIR/packages/neovim.sh"
"$BASEDIR/packages/fzf.sh"
"$BASEDIR/packages/mdl.sh"
"$BASEDIR/packages/hadolint.sh"
