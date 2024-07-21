#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"
BACKUP_FILE="${SCRIPT_DIR}/git_repos.txt"

find /personal/repos/ -iname .git | while read -r dir; do
    DIR="$(dirname "${dir}")"
    if git -C "${DIR}" remote get-url origin &>/dev/null; then
        URL="$(git -C "${DIR}" remote get-url origin)"
        echo -e "Saving DIR:\e[33m${DIR}\e[m, URL:\e[32m${URL}\e[m" >/dev/tty
        echo -e "${DIR}\t --> \t${URL}"
    fi
done >"${BACKUP_FILE}"
