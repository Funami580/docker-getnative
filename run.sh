#!/usr/bin/env bash
set -eu
REALPATH=$(realpath "$0")
CURRENT_DIRECTORY=$(dirname "${REALPATH}")
mkdir -p "${CURRENT_DIRECTORY}/data"
sudo docker run -it -v "${CURRENT_DIRECTORY}/data:/data" getnative "$@"
