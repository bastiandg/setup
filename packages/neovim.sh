#!/usr/bin/env bash

set -eu -o pipefail

INSTALL_PATH="/opt/nvim"
BASEDIR="$(dirname "$(readlink -f "$0")")"
RELEASE_URL="https://api.github.com/repos/neovim/neovim/releases"
TAG_NAME="stable"
response="$(curl -s "$RELEASE_URL")"
download_url="$(jq -r '.[] | select(.tag_name | test("'"$TAG_NAME"'")) | .assets[] | select(.name | endswith("linux64.tar.gz")) | .browser_download_url' <<<"$response")"

versioncheck() {
  set +e
  localversion="$(nvim --version 2>/dev/null | grep -oP '(?<=NVIM ).*(?=$)' || true)"
  set -e
  remoteversion="$(jq -r '.[] | select(.tag_name | test("'"$TAG_NAME"'"))  | .name' <<<"$response" | grep -oP '(?<=NVIM ).*(?=$)' || true)"
  if [[ "$localversion" == "v$remoteversion" ||  "$localversion" == "$remoteversion" ]]; then
    echo "neovim is up to date (version $localversion)"
    exit 0
  else
    echo "updating neovim from $localversion to $remoteversion"
  fi
}
versioncheck

#################################################################################
# setup exit handler
#################################################################################
onexit() {
  cd "$BASEDIR"
  echo "Script is terminating -- cleaning up"
  if [[ -d "${TMPDIR:-}" ]]; then
    sudo rm -rf "$TMPDIR"
  fi
  exit
}

trap onexit EXIT
trap '' INT TERM # Ignore SigINT and SigTERM

tmpdir="$(mktemp -d)"

cd "$tmpdir"
curl -L -o neovim.tgz "$download_url"
tar zxf neovim.tgz
sudo rm -r "$INSTALL_PATH" || true
#sudo mkdir -p "$INSTALL_PATH"
sudo mv nvim-linux64 "$INSTALL_PATH"
sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
