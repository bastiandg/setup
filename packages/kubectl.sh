#!/usr/bin/env bash
set -e
DESTINATION="/usr/local/bin/kubectl"
VERSION_URL="https://storage.googleapis.com/kubernetes-release/release/stable.txt"
VERSION="$(curl -s "$VERSION_URL")"
PACKAGE_URL="https://storage.googleapis.com/kubernetes-release/release/$VERSION/bin/linux/amd64/kubectl"

sudo curl -o "$DESTINATION" -LO "$PACKAGE_URL"
sudo chmod +x "$DESTINATION"
