#!/usr/bin/env bash

CKBDIR="~/ckb"

sudo aptitude update
sudo aptitude install build-essential libudev-dev qt5-default zlib1g-dev libappindicator-dev

git clone https://github.com/ccMSC/ckb.git "$CKBDIR"
cd "$CKBDIR"

./quickinstall
