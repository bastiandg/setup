#!/usr/bin/env bash

INSTALL="sudo apt install -y"
BASEDIR="$(dirname "$(readlink -f "$0")")"
PACKAGELIST="$BASEDIR/../files/package.list"

sudo apt update
$INSTALL $(grep -v "^#" "$PACKAGELIST" | sed -e "s/\(.*\)#.*/\1/g" | tr "\\n" " ")

