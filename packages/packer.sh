#!/usr/bin/env bash
set -eu -o pipefail

BASEDIR="$(dirname "$(readlink -f "$0")")"
RELEASE_URL="https://releases.hashicorp.com/packer/"
RELEASE_PAGE="$(curl -s "$RELEASE_URL")"
VERSION="$(echo "$RELEASE_PAGE" | grep -v 'rc\|beta\|alpha' | grep -m 1 'href="/packer' | sed -re 's#.*packer_([0-9.]*)</a>#\1#')"

versioncheck () {
	set +eu
	localversion="$(packer --version 2> /dev/null)"
	set -eu
	remoteversion="$VERSION"
	if [ "$localversion" = "$remoteversion" ] ; then
		echo "packer is up to date ($localversion)"
		exit 0
	fi
}

versioncheck
TMPDIR="$(mktemp -d)"
echo "Installing packer $VERSION"
cd "$TMPDIR"
curl -o packer.zip "${RELEASE_URL}${VERSION}/packer_${VERSION}_linux_amd64.zip"
unzip packer.zip
sudo mv packer /usr/bin/
cd "$BASEDIR"
rm -rf "$TMPDIR"
