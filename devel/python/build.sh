#!/bin/bash

# build autosaver binary file
SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"

changes="$(git -C "${SCRIPT_DIR}/../.." status -su | wc -l)"
if [[ "${changes}" == "0" ]]; then
    echo -n 'no changes were made, Do you really want to continue anyway? '
    read -r answer
    [[ "${answer,,}" != "y" ]] && exit 0
fi

cp "${SCRIPT_DIR}/autosaver" "${SCRIPT_DIR}/../../autosaver"

if [[ "$1" == "-y" ]]; then
    "${SCRIPT_DIR}/../../autosaver" commit
fi
