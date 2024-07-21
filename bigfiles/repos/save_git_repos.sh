#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"
BACKUP_FILE="${SCRIPT_DIR}/git_repos.txt"

find /personal/repos/ -iname .git | while read -r dir; do
    echo -ne "$(dirname "$dir")\t --> \t"
    grep url "$dir"/config | awk '{printf $3}'
    echo
done >"${BACKUP_FILE}"
