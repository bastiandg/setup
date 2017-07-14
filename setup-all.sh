#!/usr/bin/env bash

LOG="install.log"
exec &> >(tee "$LOG") 2>&1
BASEDIR="$(dirname "$(readlink -f "$0")")"

for installscript in "$BASEDIR/packages/"*.sh ; do
	"$installscript"
done
