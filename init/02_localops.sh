#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"

"${SCRIPT_DIR}"/autosaver.sh restore

sudo mkdir /personal
sudo chown "$USER":"$USER" /personal
mkdir /personal/repos

cd ~/.local/share/fonts/FiraCode && unzip FiraCode.zip
