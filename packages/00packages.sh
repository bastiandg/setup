#!/usr/bin/env bash

INSTALL="sudo aptitude install -y"
BASEDIR="$(dirname "$(readlink -f "$0")")"
PACKAGELIST="$BASEDIR/../files/package.list"

sudo aptitude update
$INSTALL $(grep -v "^#" "$PACKAGELIST" | sed -e "s/\(.*\)#.*/\1/g" | tr "\\n" " ")

