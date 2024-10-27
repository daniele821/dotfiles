#!/bin/bash

# build autosaver binary file
SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"

cp "${SCRIPT_DIR}/autosaver" "${SCRIPT_DIR}/../../autosaver"

if [[ "$1" == "-y" ]]; then
    "${SCRIPT_DIR}/../../autosaver" commit
fi
