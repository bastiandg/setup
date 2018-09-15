#!/usr/bin/env bash
set -e
BASEDIR="$(dirname "$(readlink -f "$0")")"
INSTALLDIR="/opt/diff-so-fancy"
URL="https://github.com/so-fancy/diff-so-fancy"

versioncheck () {
	localversion="$( (cd "$INSTALLDIR" 2> /dev/null && git rev-parse HEAD) || true)"
	remoteversion="$(git ls-remote -q "https://github.com/so-fancy/diff-so-fancy" "refs/heads/master" | cut -f1)"
	if [ "$localversion" = "$remoteversion" ] ; then
		echo "diff-so-fancy is up to date"
		exit 0
	fi
}

versioncheck
TMPDIR="$(mktemp -d)"
git clone "$URL" "$TMPDIR"
sudo rm -rf "$INSTALLDIR"
sudo cp -r "$TMPDIR" "$INSTALLDIR"
sudo chmod 555 "$INSTALLDIR"
rm -rf "$TMPDIR"
