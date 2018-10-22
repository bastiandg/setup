#!/usr/bin/env bash

APT_WIRE_FILE="/etc/apt/sources.list.d/wire-desktop.list"
versioncheck () {
	if [ -f "$APT_WIRE_FILE" ] ; then
		echo "Wire apt repo is already configured, unattended upgrades should take care of updates."
		exit 0
	fi
}

versioncheck
sudo apt-get install apt-transport-https
wget -q https://wire-app.wire.com/linux/releases.key -O- | sudo apt-key add -
echo "deb https://wire-app.wire.com/linux/debian stable main" | sudo tee /etc/apt/sources.list.d/wire-desktop.list
sudo apt-get update
sudo apt-get install -y wire-desktop
