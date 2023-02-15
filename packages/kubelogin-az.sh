#!/usr/bin/env bash
set -eu -o pipefail

INSTALL_DIR="${HOME}/bin"
RELEASE_URL="https://api.github.com/repos/Azure/kubelogin/releases/latest"
basedir="$(dirname "$(readlink -f "$0")")"
response="$(curl -s "$RELEASE_URL")"
download_url="$(jq -r '.assets[] | select(.browser_download_url | endswith("kubelogin-linux-amd64.zip")) | .browser_download_url' <<<"$response")"

versioncheck() {
  localversion="v$(kubelogin --version | sed -nre "s#git hash: v(.*)/.*#\1#p" 2>/dev/null || true)"
  remoteversion="$(jq -r ".tag_name" <<<"$response")"
  if [[ $localversion == "${remoteversion}" ]]; then
    echo "kubelogin is up to date ($localversion)"
    exit 0
  else
    echo "updating kubelogin from ${localversion} to ${remoteversion}"
  fi
}

versioncheck
tmpdir="$(mktemp -d)"
cd "$tmpdir"
curl -sSfL -o kubelogin.zip "$download_url"
unzip kubelogin.zip
mv bin/linux_amd64/kubelogin "$INSTALL_DIR"
cd -- "$basedir"
rm -rf "$tmpdir"
