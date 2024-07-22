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
    BRANCH="$(echo "${line}" | awk '{print $5}')"
    EMAIL="$(echo "${line}" | awk '{print $7}')"
    if ! [[ -d ${DIR} ]]; then
        echo -en "Do you want to clone \e[33m$URL\e[m in \e[32m$DIR\e[m (branch:\e[34m$BRANCH\e[m, email:\e[31m$EMAIL\e[m) [Y/n] ? "
        read -r answer </dev/tty
        if [[ ${answer,,} == 'y' ]]; then
            echo "${DIR} ${URL} ${BRANCH} ${EMAIL}" >>"${TMP_FILE}"
        fi
    fi
done <"$BACKUP_FILE"

# clone all repos agreed by user
while read -r line; do
    DIR="$(echo "${line}" | awk '{print $1}')"
    URL="$(echo "${line}" | awk '{print $2}')"
    BRANCH="$(echo "${line}" | awk '{print $3}')"
    EMAIL="$(echo "${line}" | awk '{print $4}')"
    echo -e "Cloning \e[33m$URL\e[m in \e[32m$DIR\e[m (branch:\e[34m$BRANCH\e[m, email:\e[31m$EMAIL\e[m)"
    git clone "${URL}" "${DIR}"
    git -C "${DIR}" config user.email "${EMAIL}"
    git -C "${DIR}" checkout "${BRANCH}"
done <"$TMP_FILE"

rm "${TMP_FILE}"
