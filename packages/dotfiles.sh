#!/usr/bin/env bash

if [ ! -d "$HOME/dotfiles" ]; then
  git clone --recursive -j8 https://github.com/bastiandg/dotfiles.git "$HOME/dotfiles"
fi

source "$HOME/dotfiles/bash/functions/99_update_dotfiles.sh"
update_dotfiles
