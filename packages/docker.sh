#!/usr/bin/env bash

set -eu -o pipefail

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

if ! sudo systemctl --no-pager status docker.service > /dev/null ; then
    sudo systemctl start docker.service
fi
