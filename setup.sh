#!/usr/bin/env bash

LOG="install.log"
exec &> >(tee "$LOG") 2>&1

INSTALL="sudo aptitude install -y"
BASEDIR="$(dirname "$(readlink -f "$0")")"

font_setup () {
	"$BASEDIR/font.sh"
}

ckb_setup () {
	"$BASEDIR/ckb.sh"
}

easystroke_setup () {
	"$BASEDIR/easystroke.sh"
}

thunderbird_setup () {
	"$BASEDIR/thunderbird.sh"
}

git_setup () {
	git config --global user.name "Bastian de Groot"
	git config --global user.email "git@de-groot.info"
	git config --global core.editor vim
}


dotfile_setup () {
	if [ ! -d "$HOME/dotfiles" ] ; then
		git clone --recursive -j8 https://github.com/bastiandg/dotfiles.git "$HOME/dotfiles"
		cd "$HOME/dotfiles"
	fi
	cp -v "$HOME/dotfiles/.bashrc" "$HOME/.bashrc"
	rm -v -rf "$HOME/.vim/" "$HOME/.vimrc"
	cp -v "$HOME/dotfiles/.vimrc" "$HOME/.vimrc"
	cp -vr "$HOME/dotfiles/.vim" "$HOME/.vim"
	cp -v "$HOME/dotfiles/.conkyrc" "$HOME/.conkyrc"
	mkdir -p "$HOME/.config"
	cp -vr "$HOME/dotfiles/openbox" "$HOME/.config/"
	cp -vr "$HOME/dotfiles/tint2" "$HOME/.config/"
	mkdir -p "$HOME/.kde/share/config/"
	cp -v "$HOME/dotfiles/yakuakerc" "$HOME/.kde/share/config/"
}

cd "$BASEDIR"
sudo aptitude update
$INSTALL $(grep -v "^#" package.list | sed -e "s/\(.*\)#.*/\1/g" | tr "\\n" " ")

font_setup
git_setup
easystroke_setup
dotfile_setup
thunderbird_setup

