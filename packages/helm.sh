#!/usr/bin/env bash

set -eu -o pipefail

BASEDIR="$(dirname "$(readlink -f "$0")")"
RELEASE_URL="https://api.github.com/repos/helm/helm/releases/latest"
RESPONSE="$(curl -sL "$RELEASE_URL")"
VERSION="$(jq -r '.tag_name' <<<"$RESPONSE")"
DOWNLOAD_URL="https://get.helm.sh/helm-${VERSION}-linux-amd64.tar.gz"

versioncheck() {
  localversion="$(helm version --short 2>/dev/null | sed -re "s/(.*)\+.*/\1/g" || true)"
  remoteversion="$(jq -r ".tag_name" <<<"$RESPONSE")"
  if [[ "$localversion" == "$remoteversion" ]]; then
    echo "helm is up to date ($localversion)"
    exit 0
  else
    echo "helm will be updated from '$localversion' to '$remoteversion'"
  fi
}

versioncheck
TMPDIR="$(mktemp -d)"

cd "$TMPDIR"
curl -L -o "helm.tar.gz" "${DOWNLOAD_URL}"
tar zxf helm.tar.gz linux-amd64/helm -C .
sudo mv linux-amd64/helm /usr/bin/helm

cd "$BASEDIR"
rm -rf "$TMPDIR"
