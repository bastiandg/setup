#!/usr/bin/env bash
set -e

BASEDIR="$(dirname "$(readlink -f "$0")")"
TMPDIR="$(mktemp -d)"
VERSION="$(curl "https://releases.hashicorp.com/vault/" 2>/dev/null | grep -v 'rc\|beta' | grep -m 1 'href="/vault' | sed -re "s#.*vault_([0-9.]*)</a>#\1#")"
echo "Installing vault $VERSION"
cd "$TMPDIR"
curl -o vault.zip "https://releases.hashicorp.com/vault/${VERSION}/vault_${VERSION}_linux_amd64.zip"
unzip vault.zip
sudo mv vault /usr/bin/
cd "$BASEDIR"
rm -rf "$TMPDIR"
