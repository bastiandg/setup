#!/usr/bin/env bash
set -e

BASEDIR="$(dirname "$(readlink -f "$0")")"

versioncheck () {
	localversion="$(go version | sed -re 's#go version go(.*) .*#\1#g')"
	remoteversion="$(curl "https://golang.org/dl/" 2> /dev/null | grep -oP '(?<=<a class="download downloadBox" href="https://dl.google.com/go/go).*(?=.linux-amd64.tar.gz">)')"
	if [ "$localversion" = "$remoteversion" ] ; then
		echo "Go is up to date"
		exit 0
	fi
}

versioncheck
TMPDIR="$(mktemp -d)"
URL="$(curl "https://golang.org/dl/" 2> /dev/null | grep -oP '(?<=<a class="download downloadBox" href=").*linux-amd64.tar.gz(?=">)')"

cd "$TMPDIR"
curl -L -o go.tgz "${URL}"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go.tgz
sudo ln -sf /usr/local/go/bin/go /usr/local/bin/go

cd "$BASEDIR"
rm -rf "$TMPDIR"
