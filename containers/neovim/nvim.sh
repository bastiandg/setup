#!/bin/bash

set -eu -o pipefail

if [[ -n ${WORKDIR+x} ]]; then
  cd "$WORKDIR"
fi


UNAME="$(whoami)"

export XDG_CONFIG_HOME="/var/data/${UNAME}/config"
export XDG_DATA_HOME="/var/data/${UNAME}/data"
export XDG_STATE_HOME="/var/data/${UNAME}/state"
export XDG_CACHE_HOME="/var/data/${UNAME}/cache"

/usr/local/bin/nvim "$@"
