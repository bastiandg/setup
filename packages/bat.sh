#!/usr/bin/env bash
set -eu -o pipefail
BASEDIR="$(dirname "$(readlink -f "$0")")"
RELEASES="$(curl -s "https://api.github.com/repos/sharkdp/bat/releases/latest")"
URL="$(echo "$RELEASES" | jq -r '.assets[] | select(.browser_download_url | test("bat_.*amd64.deb")) | .browser_download_url')"

versioncheck() {
  localversion="$(bat --version 2>/dev/null | cut -d " " -f2 || echo "NULL")"
  remoteversion="$(echo "$RELEASES" | jq -r ".name")"
  if [ "v$localversion" = "$remoteversion" ]; then
    echo "bat is up to date (version $localversion)"
    exit 0
  else
    echo "updating bat from $localversion to $remoteversion"
  fi
}

versioncheck

TMPDIR="$(mktemp -d)"
cd "$TMPDIR"
curl -Ls -o bat.deb "$URL"
sudo dpkg -i bat.deb
cd "$BASEDIR"
rm -rf "$TMPDIR"
