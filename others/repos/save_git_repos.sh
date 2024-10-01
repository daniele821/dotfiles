#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"
BACKUP_FILE="${SCRIPT_DIR}/git_repos.txt"

TMP_FILE="$(mktemp /tmp/gitreposXXXXXXXXXXXXXXXXXXXXX.tmp)"

find /personal/repos/ -iname .git | sort | while read -r dir; do
    DIR="$(dirname "${dir}")"
    EMAIL="$(git -C "${DIR}" config user.email)"
    BRANCH="$(git -C "${DIR}" rev-parse --abbrev-ref HEAD)"
    URL="$(git -C "${DIR}" remote get-url "$(git -C "${DIR}" remote)" 2>/dev/null)"
    if [[ -d "${dir}" ]]; then # if .git is a file, then the directory is a worktree dir
        if [[ -n "${URL}" && "${BRANCH}" != "HEAD" ]]; then
            echo -e "Saving DIR:\e[33m${DIR}\e[m, URL:\e[32m${URL}\e[m, BRANCH:\e[34m${BRANCH}\e[m, EMAIL:\e[31m${EMAIL}\e[m" >/dev/tty
            echo -e "${DIR}\n${URL}\n${BRANCH}\n${EMAIL}"
            echo "---------------------------------------------------------------------"
        else
            if [[ "${BRANCH}" == "HEAD" ]]; then
                echo -e "\e[33;1mWARNING: ${DIR} couldn't be parsed: head is detacthed!\e[m"
            elif [[ -z "${URL}" ]]; then
                echo -e "\e[33;1mWARNING: ${DIR} couldn't be parsed: couldn't parse remote url\e[m"
            else
                echo -e "\e[33;1mWARNING: ${DIR} couldn't be parsed!\e[m"
            fi >>"${TMP_FILE}"
        fi
    else
        echo -e "\e[33;1mWARNING: ${DIR} is a worktree!\e[m" >>"${TMP_FILE}"
    fi
done >"${BACKUP_FILE}"

cat "${TMP_FILE}" 1>&2
rm "${TMP_FILE}"
