#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"
BACKUP_FILE="${SCRIPT_DIR}/git_repos.txt"
TMP_FILE="$(mktemp /tmp/XXXXXXXXXXXXXXXXXX)"

touch "${TMP_FILE}"

# ask what repos to clone
while read -r line; do
    DIR="$(echo "${line}" | awk '{print $1}')"
    URL="$(echo "${line}" | awk '{print $3}')"
    EMAIL="$(echo "${line}" | awk '{print $5}')"
    if ! [[ -d ${DIR} ]]; then
        echo -en "Do you want to clone \e[33m$URL\e[m in \e[32m$DIR\e[m (email:\e[31m$EMAIL\e[m) [Y/n] ? "
        read -r answer </dev/tty
        if [[ ${answer,,} == 'y' ]]; then
            echo "${DIR} ${URL} ${EMAIL}" >>"${TMP_FILE}"
        fi
    fi
done <"$BACKUP_FILE"

# clone all repos agreed by user
while read -r line; do
    DIR="$(echo "${line}" | awk '{print $1}')"
    URL="$(echo "${line}" | awk '{print $2}')"
    EMAIL="$(echo "${line}" | awk '{print $3}')"
    echo -e "Cloning \e[33m$URL\e[m in \e[32m$DIR\e[m"
    git clone "${URL}" "${DIR}"
    git -C "${DIR}" config user.email "${EMAIL}"
done <"$TMP_FILE"

rm "${TMP_FILE}"
