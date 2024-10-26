#!/bin/bash

# build autosaver binary file
SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"

[[ "$1" == "-y" ]] && cp "${SCRIPT_DIR}/autosaver" "${SCRIPT_DIR}/../../autosaver"

:
