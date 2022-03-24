#!/usr/bin/env bash
REALPATH=$(realpath "$0")
CURRENT_DIRECTORY=$(dirname "${REALPATH}")
sudo docker build --no-cache -t getnative "${CURRENT_DIRECTORY}"
