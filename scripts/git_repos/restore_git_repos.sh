#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"
BACKUP_FILE="${SCRIPT_DIR}/git_repos.txt"

# early exit if no backup file is present
[[ -f "${BACKUP_FILE}" ]] || exit 0

# clone missing directories
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
            echo -e "Cloning \e[33m$URL\e[m in \e[32m$DIR\e[m (branch:\e[34m$BRANCH\e[m, email:\e[31m$EMAIL\e[m)"
            git clone "${URL}" "${DIR}"
            git -C "${DIR}" config user.email "${EMAIL}"
            git -C "${DIR}" checkout "${BRANCH}"
        fi
        COUNTER=0
        ;;
    *)
        echo -e "\e[31merror: INVALID COUNTER VALUE\e[m"
        exit 1
        ;;
    esac
done <"$BACKUP_FILE"

exit 0
