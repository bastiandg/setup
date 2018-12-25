#!/usr/bin/env bash
set -eu -o pipefail
BASEDIR="$(dirname "$(readlink -f "$0")")"
RELEASES="$(curl -s "https://api.github.com/repos/junegunn/fzf-bin/releases/latest")"
URL="$(echo "$RELEASES" | jq -r '.assets[] | select(.browser_download_url | contains ("linux_amd64.tgz")) | .browser_download_url')"
TARGETPATH="/usr/local/bin"


versioncheck () {
	localversion="$("$TARGETPATH/fzf" --version 2> /dev/null | cut -d " " -f1 || echo "NULL")"
	remoteversion="$(echo "$RELEASES" | jq -r ".name")"
	if [ "$localversion" = "$remoteversion" ] ; then
		echo "fzf is up to date (version $localversion)"
		exit 0
	else
		echo "updating fzf from $localversion to $remoteversion"
	fi
}

versioncheck

TMPDIR="$(mktemp -d)"
cd "$TMPDIR"
curl -Ls -o fzf.tgz "$URL"
tar xzf fzf.tgz
sudo mv fzf "$TARGETPATH/fzf"
cd "$BASEDIR"
rm -rf "$TMPDIR"
