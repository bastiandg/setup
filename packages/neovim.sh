#!/usr/bin/env bash

set -eu -o pipefail

INSTALL_PATH="/opt/nvim"
BASEDIR="$(dirname "$(readlink -f "$0")")"
RELEASE_URL="https://api.github.com/repos/neovim/neovim/releases/latest"
response="$(curl -s "$RELEASE_URL")"
download_url="$(jq -r '.assets[] | select(.name | endswith("linux64.tar.gz")) | .browser_download_url' <<<"$response")"

versioncheck() {
  set +e
  localversion="$(nvim --version 2>/dev/null | grep -oP '(?<=NVIM ).*(?=$)')"
  set -e
  remoteversion="$(jq -r ".name" <<<"$response" | grep -oP '(?<=NVIM ).*(?=$)')"
  if [ "$localversion" = "v$remoteversion" ]; then
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
sudo mv nvim-linux64 "$INSTALL_PATH"
sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
