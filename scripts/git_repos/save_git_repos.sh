#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
CONFIG_DIR="$(dirname "$(dirname "$(dirname "${SCRIPT_PWD}")")")/others/scripts/git_repos"
BACKUP_FILE="${CONFIG_DIR}/git_repos.txt"
CONFIG_FILE="${CONFIG_DIR}/config.txt"

! [[ -f "${CONFIG_FILE}" ]] && mkdir -p "${CONFIG_DIR}" && touch "${CONFIG_FILE}" && FILE_MISSING=
[[ -f "${BACKUP_FILE}" ]] && rm "${BACKUP_FILE}"

if [[ "$1" == '-e' || "$1" == 'edit' || -v 'FILE_MISSING' ]]; then
    TMP_FILE="$(mktemp)"
    cp "${CONFIG_FILE}" "${TMP_FILE}"
    nvim "${TMP_FILE}"
    \cat "${TMP_FILE}"
    echo -ne 'Do you want to save configuration file? '
    read -r answer
    [[ "${answer,,}" == "y" ]] && echo 'saving configuration file ...' && cp "${TMP_FILE}" "${CONFIG_FILE}"
    touch "${CONFIG_FILE}"
    rm "${TMP_FILE}"
fi

while read -r rootdir; do
    [[ -d "${rootdir}" ]] && echo "Searching git repos inside ${rootdir}..."
    [[ -d "${rootdir}" ]] && find "${rootdir}" -iname .git 2>/dev/null | sort | while read -r dir; do
        DIR="$(dirname "${dir}" 2>/dev/null)"
        EMAIL="$(git -C "${DIR}" config user.email 2>/dev/null)"
        BRANCH="$(git -C "${DIR}" rev-parse --abbrev-ref HEAD 2>/dev/null)"
        URL="$(git -C "${DIR}" remote get-url "$(git -C "${DIR}" remote 2>/dev/null)" 2>/dev/null)"
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
                fi >/dev/tty
            fi
        else
            echo -e "\e[33;1mWARNING: ${DIR} is a worktree!\e[m" >/dev/tty
        fi
    done >>"${BACKUP_FILE}"
done <"${CONFIG_FILE}"
