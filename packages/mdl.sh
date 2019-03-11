#!/bin/bash
set -eu -o pipefail

sudo apt-get update
sudo apt-get install -y rubygems
sudo gem install mdl
sudo gem update mdl
