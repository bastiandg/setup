#!/usr/bin/env bash
set -e

BASEDIR="$(dirname "$(readlink -f "$0")")"
TMPDIR="$(mktemp -d)"
VERSION="go1.10"
URL="https://dl.google.com/go/$VERSION.linux-amd64.tar.gz"

cd "$TMPDIR"
curl -L -o go.tgz "${URL}"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go.tgz
sudo ln -sf /usr/local/go/bin/go /usr/local/bin/go

cd "$BASEDIR"
rm -rf "$TMPDIR"
