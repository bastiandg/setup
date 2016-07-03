#!/usr/bin/env bash

LOG="install.log"
exec &> >(tee "$LOG") 2>&1

INSTALL="sudo aptitude install -y"
BASEDIR="$(dirname "$(readlink -f $0)")"

font_setup () {
	"$BASEDIR/font.sh"
}

ckb_setup () {
	"$BASEDIR/ckb.sh"
}

easystroke_setup () {
	"$BASEDIR/easystroke.sh"
}

git_setup () {
	git config --global user.name "Bastian de Groot"
	git config --global user.email "git@de-groot.info"
	git config --global core.editor vim
}


dotfile_setup () {
	if [ ! -d "$HOME/dotfiles" ] ; then
		git clone https://github.com/bastiandg/dotfiles.git "$HOME/dotfiles"
		cd "$HOME/dotfiles"
		git submodule init
		git submodule update
	fi
	cp -vr "$HOME/dotfiles/.bashrc" "$HOME/.bashrc"
	rm -v -rf "$HOME/.vim/" "$HOME/.vimrc"
	cp -vr "$HOME/dotfiles/.vimrc" "$HOME/.vimrc"
	cp -vr "$HOME/dotfiles/.vim" "$HOME/.vim"
	cp -vr "$HOME/dotfiles/.conkyrc" "$HOME/.conkyrc"
	mkdir -p "$HOME/.config"
	cp -vr "$HOME/dotfiles/openbox" "$HOME/.config/"
	cp -vr "$HOME/dotfiles/tint2" "$HOME/.config/"
}

cd "$BASEDIR"
sudo aptitude update
$INSTALL $(cat package.list | sed -e "s/\(.*\)#.*/\1/g" | tr "\\n" " ")

font_setup
git_setup
easystroke_setup
dotfile_setup
sudo update-alternatives --set x-session-manager /usr/bin/openbox-session

