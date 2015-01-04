#!/usr/bin/env bash

INSTALL="sudo aptitude install -y"
BASEDIR="$(dirname "$(readlink -f $0)")"

font_setup () {
	FONT_NAME="SourceCodePro"
	URL="https://github.com/adobe-fonts/source-code-pro/archive/1.017R.zip"

	mkdir /tmp/adodefont
	cd /tmp/adodefont
	wget ${URL} -O ${FONT_NAME}.zip
	unzip -o -j ${FONT_NAME}.zip
	mkdir -p ~/.fonts
	cp *.otf ~/.fonts
	fc-cache -f -v
	cd "$BASEDIR"
}

git_setup () {
	git config --global user.name "Bastian de Groot"
	git config --global user.email "git@de-groot.info"
	git config --global core.editor vim
}

easystroke_setup () {
	mkdir /tmp/easystroke
	git clone git://github.com/thjaeger/easystroke.git /tmp/easystroke
	cd /tmp/easystroke
	make -j2
	sudo make install
	cd "$BASEDIR"
	rm -rf /tmp/easystroke
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
	cp -vr "$HOME/dotfiles/.easystroke" "$HOME/"
}

mozilla_setup () {
	INSTALLDIR="/opt/"
	PUID="1000" #user who "owns" the software

	if [ ! -d "$INSTALLDIR/firefox" ] ; then
		DOWNLOADURL="http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/latest/linux-x86_64/de/"
		FIREFOXVERSION="$(wget -qO- $DOWNLOADURL | \
				grep -m1 \"firefox | \
				sed -e "s#.*href.*>\(.*\)</a>.*#\1#g" | \
				grep -v "\&")"

		mkdir /tmp/firefox
		cd /tmp/firefox
		wget "$DOWNLOADURL$FIREFOXVERSION"
		tar xvjf firefox*.tar.bz2
		sudo cp -vr firefox "$INSTALLDIR/firefox"

		sudo chown -R "$PUID":"$PUID" "$INSTALLDIR/firefox"
		sudo ln -s "$INSTALLDIR/firefox/firefox" /usr/bin/firefox
		cd "$BASEDIR"
		rm -rf /tmp/firefox
		sudo cp firefox.desktop "/usr/share/applications/firefox.desktop"
		sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/firefox 100
		sudo update-alternatives --set x-www-browser /usr/bin/firefox
	fi

	if [ ! -d "$INSTALLDIR/thunderbird" ] ; then
		DOWNLOADURL="http://ftp.mozilla.org/pub/mozilla.org/thunderbird/releases/latest/linux-x86_64/de/"
		THUNDERBIRDVERSION="$(wget -qO- $DOWNLOADURL | \
			grep -m1 \"thunderbird | \
			sed -e "s#.*href.*>\(.*\)</a>.*#\1#g" | \
			grep -v "\&")"

		mkdir -p /tmp/thunderbird
		cd /tmp/thunderbird
		wget "$DOWNLOADURL$THUNDERBIRDVERSION"
		tar xvjf thunderbird*.tar.bz2
		sudo cp -vr thunderbird "$INSTALLDIR/thunderbird"
		sudo chown -R "$PUID":"$PUID" "$INSTALLDIR/thunderbird"
		sudo ln -s "$INSTALLDIR/thunderbird/thunderbird" /usr/bin/thunderbird
		cd "$BASEDIR"
		rm -rf /tmp/thunderbird
		sudo cp thunderbird.desktop "/usr/share/applications/thunderbird.desktop"
	fi
}

sudo aptitude update
$INSTALL $(cat package.list | sed -e "s/\(.*\)#.*/\1/g" | tr "\\n" " ")
cd "$BASEDIR"

font_setup
git_setup
easystroke_setup
dotfile_setup
mozilla_setup
sudo update-alternatives --set x-session-manager /usr/bin/openbox-session

