#!/usr/bin/env bash

set -eu -o pipefail

LOG="install.log"
exec &> >(tee "$LOG") 2>&1
BASEDIR="$(dirname "$(readlink -f "$0")")"

"$BASEDIR/packages/00packages.sh"
#"$BASEDIR/packages/emoji.sh"
"$BASEDIR/packages/firefox.sh"
"$BASEDIR/packages/font.sh"
"$BASEDIR/packages/gitconfig.sh"
"$BASEDIR/packages/golang.sh"
"$BASEDIR/packages/helm.sh"
"$BASEDIR/packages/kubectl.sh"
"$BASEDIR/packages/terraform.sh"
"$BASEDIR/packages/thunderbird.sh"

# IDE
"$BASEDIR/packages/neovim.sh"
"$BASEDIR/packages/delta.sh"
"$BASEDIR/packages/shfmt.sh"
"$BASEDIR/packages/fzf.sh"
"$BASEDIR/packages/mdl.sh"
"$BASEDIR/packages/hadolint.sh"
"$BASEDIR/packages/dotfiles.sh"
