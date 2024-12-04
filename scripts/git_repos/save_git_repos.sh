#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
CONFIG_DIR="$(dirname "$(dirname "$(dirname "${SCRIPT_PWD}")")")/others/scripts/git_repos"
BACKUP_FILE="${CONFIG_DIR}/git_repos.txt"
CONFIG_FILE="${CONFIG_DIR}/config.txt"

if [[ "$1" == '-e' || "$1" == 'edit' || ! -f "${CONFIG_FILE}" ]]; then
    # create temporary files
    TMP_FILE1="$(mktemp)"
    TMP_FILE2="$(mktemp)"
    TMP_FILE3="$(mktemp)"
    TMP_FILE4="$(mktemp)"
    TMP_FILE="${TMP_FILE4}"

    # make user write to config file
    [[ -f "${CONFIG_FILE}" ]] && cp "${CONFIG_FILE}" "${TMP_FILE1}"
    nvim "${TMP_FILE1}"

    # config file cleanup
    sort "${TMP_FILE1}" -u >"${TMP_FILE2}"
    while IFS="" read -r line || [[ -n "$line" ]]; do
        if [[ -n "$line" ]]; then
            [[ "${line:0-1}" == '/' && ${line} != "/" ]] && line="${line::-1}"
            [[ "${line:0:1}" == '~' ]] && line="${HOME}${line:1}"
            if [[ -d "${line}" ]]; then
                echo "${line}" >>"${TMP_FILE3}"
            else
                echo -e "WARNING: '${line}' not a directory" >/dev/tty
            fi
        fi
    done <"${TMP_FILE2}"
    sort "${TMP_FILE3}" -u >"${TMP_FILE4}"

    # ask user if he wants to save config save
    echo -e "\e[1;33mNEW CONFIGURATION FILE:\e[m"
    \cat "${TMP_FILE}"
    echo -ne 'Do you want to save configuration file? '
    read -r answer
    if [[ "${answer,,}" == "y" ]]; then
        echo 'saving configuration file ...'
        mkdir -p "${CONFIG_DIR}"
        cp "${TMP_FILE}" "${CONFIG_FILE}"
    fi

    # remove temporary files
    rm "${TMP_FILE1}" "${TMP_FILE2}" "${TMP_FILE3}" "${TMP_FILE4}"
fi

[[ -f "${CONFIG_FILE}" ]] && while read -r rootdir; do
    [[ -d "${rootdir}" ]] && echo "Searching git repos inside ${rootdir}..."
    [[ -d "${rootdir}" ]] && find "${rootdir}" -iname .git 2>/dev/null | sort | while read -r dir; do
        DIR="$(dirname "${dir}" 2>/dev/null)"
        EMAIL="$(git -C "${DIR}" config user.email 2>/dev/null)"
        BRANCH="$(git -C "${DIR}" rev-parse --abbrev-ref HEAD 2>/dev/null)"
        URL="$(git -C "${DIR}" remote get-url "$(git -C "${DIR}" remote 2>/dev/null)" 2>/dev/null)"
        if [[ ! -d "${dir}" ]]; then
            echo -e "\e[33;1mWARNING: ${DIR} is a worktree!\e[m" >/dev/tty
        elif [[ -z "${URL}" ]]; then
            echo -e "\e[33;1mWARNING: ${DIR} couldn't be parsed: couldn't parse remote url\e[m" >/dev/tty
        else
            echo -e "Saving DIR:\e[33m${DIR}\e[m, URL:\e[32m${URL}\e[m, BRANCH:\e[34m${BRANCH}\e[m, EMAIL:\e[31m${EMAIL}\e[m" >/dev/tty
            echo -e "${DIR}\n${URL}\n${BRANCH}\n${EMAIL}"
            echo "---------------------------------------------------------------------"
        fi
    done
done <"${CONFIG_FILE}" >"${BACKUP_FILE}"

exit 0
