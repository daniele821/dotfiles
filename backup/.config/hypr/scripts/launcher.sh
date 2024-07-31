#!/bin/bash

# this script takes care of launching of scripts needed by hyprland
# in hyprland config, just exec-once this script!

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"

"${SCRIPT_DIR}"/events.sh
