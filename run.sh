#!/usr/bin/env bash
REALPATH=$(realpath "$0")
CURRENT_DIRECTORY=$(dirname "${REALPATH}")
mkdir -p "${CURRENT_DIRECTORY}/data"
sudo docker run -it -v "${CURRENT_DIRECTORY}/data:/data" getnative
