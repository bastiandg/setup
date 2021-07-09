#!/usr/bin/env bash

set -e -o pipefail

versioncheck() {
  APT_SOURCE_LINE="$(grep "^deb.*docker" /etc/apt/sources.list || true)"
  if [ -n "$APT_SOURCE_LINE" ]; then
    echo "docker apt repo is already configured, unattended upgrades should take of updates."
    exit 0
  fi
}

versioncheck
if [ -n "$USER" ]; then
  DOCKERUSER="$USER"
else
  DOCKERUSER="$1"
fi

sudo apt-get update
sudo apt-get -y install \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg2 \
  software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/debian \
     $(lsb_release -cs) \
     stable"
sudo apt-get update

# The install might return a non zero return code because aufs is not initialized yet
sudo apt-get install -y docker-ce || true

if ! sudo systemctl --no-pager status docker.service >/dev/null; then
  sudo systemctl start docker.service
fi

if [ -n "$DOCKERUSER" ]; then
  sudo usermod -aG docker "$DOCKERUSER"
fi
