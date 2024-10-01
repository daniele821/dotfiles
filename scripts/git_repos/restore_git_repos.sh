#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"
BACKUP_FILE="${SCRIPT_DIR}/git_repos.txt"
TMP_FILE="$(mktemp /tmp/XXXXXXXXXXXXXXXXXX)"

# early exit if no backup file is present
! [[ -f "${BACKUP_FILE}" ]] && echo 'there is no backup file' && exit 1

touch "${TMP_FILE}"

# ask what repos to clone
COUNTER=0
while read -r line; do
    ((COUNTER += 1))
    case "$COUNTER" in
    1) DIR="${line}" ;;
    2) URL="${line}" ;;
    3) BRANCH="${line}" ;;
    4) EMAIL="${line}" ;;
    5)
        if ! [[ -d ${DIR} ]]; then
            echo -en "Do you want to clone \e[33m$URL\e[m in \e[32m$DIR\e[m (branch:\e[34m$BRANCH\e[m, email:\e[31m$EMAIL\e[m) [Y/n] ? "
            read -r answer </dev/tty
            if [[ ${answer,,} == 'y' ]]; then
                echo "${DIR} ${URL} ${BRANCH} ${EMAIL}" >>"${TMP_FILE}"
            fi
        fi
        COUNTER=0
        ;;
    *)
        echo -e "\e[31merror: INVALID COUNTER VALUE\e[m"
        exit 1
        ;;
    esac
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
