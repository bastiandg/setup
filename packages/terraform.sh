#!/usr/bin/env bash
set -eu -o pipefail

BASEDIR="$(dirname "$(readlink -f "$0")")"
RELEASE_URL="https://releases.hashicorp.com/terraform/"
RELEASE_PAGE="$(curl -s "$RELEASE_URL")"
VERSION="$(echo "$RELEASE_PAGE" | grep -v 'rc\|beta\|alpha' | grep -m 1 'href="/terraform' | sed -re "s#.*terraform_([0-9.]*)</a>#\1#")"

versioncheck () {
	set +eu
	localversion="$(terraform --version 2> /dev/null | grep -oP '(?<=Terraform v).*(?=$)')"
	set -eu
	remoteversion="$VERSION"
	if [ "$localversion" = "$remoteversion" ] ; then
		echo "terraform is up to date"
		exit 0
	fi
}

versioncheck
TMPDIR="$(mktemp -d)"
echo "Installing terraform $VERSION"
cd "$TMPDIR"
curl -o terraform.zip "${RELEASE_URL}${VERSION}/terraform_${VERSION}_linux_amd64.zip"
unzip terraform.zip
sudo mv terraform /usr/bin/
cd "$BASEDIR"
rm -rf "$TMPDIR"
