#!/usr/bin/env bash

set -eu -o pipefail

BASEDIR="$(dirname "$(readlink -f "$0")")"
version="$(curl "https://golang.org/dl/" 2>/dev/null | grep -oP '(?<=<a class="download downloadBox" href="/dl/go).*(?=.linux-amd64.tar.gz">)')"
download_url="https://golang.org/dl/go${version}.linux-amd64.tar.gz"

versioncheck() {
  localversion="$(go version | sed -re 's#go version go(.*) .*#\1#g')"
  remoteversion="$version"
  if [[ "$localversion" = "$remoteversion" ]]; then
    echo "Go is up to date ($version)"
    exit 0
  fi
}

versioncheck
TMPDIR="$(mktemp -d)"

cd "$TMPDIR"
curl -L -o go.tgz "$download_url"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go.tgz
sudo ln -sf /usr/local/go/bin/go /usr/local/bin/go

cd "$BASEDIR"
rm -rf "$TMPDIR"
