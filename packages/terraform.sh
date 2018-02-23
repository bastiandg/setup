#!/usr/bin/env bash
set -e

BASEDIR="$(dirname "$(readlink -f "$0")")"
TMPDIR="$(mktemp -d)"
VERSION="$(curl "https://releases.hashicorp.com/terraform/" 2> /dev/null | grep -v 'rc\|beta' | grep -m 1 'href="/terraform' | sed -re "s#.*terraform_([0-9.]*)</a>#\1#")"
echo "Installing terraform $VERSION"
cd "$TMPDIR"
curl -o terraform.zip "https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip"
unzip terraform.zip
sudo mv terraform /usr/bin/
cd "$BASEDIR"
rm -rf "$TMPDIR"
