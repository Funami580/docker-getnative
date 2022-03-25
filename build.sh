#!/usr/bin/env bash
set -eu
REALPATH=$(realpath "$0")
CURRENT_DIRECTORY=$(dirname "${REALPATH}")
sudo docker build --no-cache -t getnative "${CURRENT_DIRECTORY}"
mkdir -p "${CURRENT_DIRECTORY}/data"
