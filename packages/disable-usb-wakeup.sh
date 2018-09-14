#!/usr/bin/env bash
set -e

BASEDIR="$(dirname "$(readlink -f "$0")")"
cd "$BASEDIR/.."

sudo cp files/disable-usb-wakeup.service /etc/systemd/system/
sudo cp files/disable-usb-wakeup /usr/local/bin/disable-usb-wakeup

sudo chmod +x /usr/local/bin/disable-usb-wakeup

sudo systemctl daemon-reload
sudo systemctl enable disable-usb-wakeup.service
sudo systemctl start disable-usb-wakeup.service
