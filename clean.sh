#!/usr/bin/env bash
set -u
REALPATH=$(realpath "$0")
CURRENT_DIRECTORY=$(dirname "${REALPATH}")
sudo docker ps -a | awk '$2 == "getnative" { print $1 }' | xargs -I% sudo docker rm %
sudo docker rmi -f getnative
sudo rm -rf "${CURRENT_DIRECTORY}/data"
