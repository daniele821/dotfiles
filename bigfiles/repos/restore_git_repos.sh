#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"
BACKUP_FILE="${SCRIPT_DIR}/git_repos.txt"

while read -r line; do
    DIR="$(echo "${line}" | awk '{print $1}')"
    URL="$(echo "${line}" | awk '{print $3}')"
    if ! [[ -d ${DIR} ]]; then
        echo -en "Do you want to clone \e[33m$URL\e[m in \e[32m$DIR\e[m [Y/n] ? "
        read -r answer </dev/tty
        if [[ ${answer,,} == 'y' ]]; then
            git clone "$URL" "$DIR"
        fi
    fi
done <"$BACKUP_FILE"
