#!/usr/bin/env bash
set -e
DESTINATION="/usr/local/bin/kubectl"
VERSION_URL="https://storage.googleapis.com/kubernetes-release/release/stable.txt"
REMOTE_VERSION="$(curl -s "$VERSION_URL")"
PACKAGE_URL="https://storage.googleapis.com/kubernetes-release/release/$REMOTE_VERSION/bin/linux/amd64/kubectl"

versioncheck () {
	set +eu
	LOCAL_VERSION="$(kubectl version --short --client 2> /dev/null | sed -e "s#Client Version: ##g")"
	set -eu
	if [ "$LOCAL_VERSION" == "$REMOTE_VERSION" ] ; then
		echo "kubectl is up to date"
		exit 0
	fi
}

versioncheck
sudo curl -o "$DESTINATION" -LO "$PACKAGE_URL"
sudo chmod +x "$DESTINATION"
