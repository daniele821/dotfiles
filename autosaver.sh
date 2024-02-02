#!/bin/bash

# variables
SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"
DIR_BACKUP="${SCRIPT_DIR}/backup"
DIR_USERCONFIG="${SCRIPT_DIR}/userconfig"
DIR_CONFIG="${SCRIPT_DIR}/config"
DIR_INIT="${SCRIPT_DIR}/init"
DIR_BIGFILES="${SCRIPT_DIR}/bigfiles"
DIRS=("${DIR_BACKUP}" "${DIR_USERCONFIG}" "${DIR_CONFIG}" "${DIR_INIT}" "${DIR_BIGFILES}")
FILE_BRANCH="${DIR_USERCONFIG}/whitelisted_branch.txt"
FILE_TRACK="${DIR_CONFIG}/files_to_track.txt"
FILES=("${FILE_BRANCH}" "${FILE_TRACK}")
BRANCH_WHITELISTED="$( [[ -f "${FILE_BRANCH}" ]] && cat "${FILE_BRANCH}")"
BRANCH_ACTUAL="$(git -C "${SCRIPT_DIR}" rev-parse --abbrev-ref HEAD)"
BRANCH_OK="$([[ "${BRANCH_WHITELISTED}" == "${BRANCH_ACTUAL}" ]] && echo y)"
CLR_ERROR="\e[m\e[1;31mERROR:\e[m"
CLR_FILE="\e[m\e[1m"
CLR_MSG="\e[m\e[1;33m"
CLR_CLEAN="\e[m"
ACTION=""
OPT_COMM="n"
OPT_DIFF="n"
OPT_VERB="n"
OPT_YES="n"
ARG_BRANCH=""

# utility functions
function print_line(){
    seq "$(tput cols)" | while read -r _; do echo -n "-"; done && echo
}
function copy_file(){
    mkdir -p "$(dirname "${2}")" && cp "${1}" "${2}"
}
function get_inits(){
    [[ -d "${DIR_INIT}" ]] && find "${DIR_INIT}" -type f | sort
} 
function ask_user(){
    echo -en "${CLR_MSG}${1} " 
    [[ -n "${2}" ]] && echo -en "${CLR_FILE}${2:$((${#SCRIPT_DIR}+1))}${CLR_CLEAN} "
    echo -en "${CLR_MSG}? ${CLR_CLEAN}"
    [[ "${OPT_YES}" == "y" ]] && echo "y" && return 0
    [[ "${OPT_YES}" != "y" ]] && read -r answer </dev/tty && [[ "${answer}" == "y" ]]
}
function edit_file(){
    [[ -f "${1}" ]] && ask_user "Do you really want to edit" "${1}" && nvim "${1}"
}

# action functions
function goto_branch(){
    git -C "${SCRIPT_DIR}" switch -q "${BRANCH_WHITELISTED}"
}
function whitelist_branch(){
    echo "${ARG_BRANCH}" > "${FILE_BRANCH}"
}
function edit_config(){
    edit_file "${SCRIPT_PWD}"
    for file in "${FILES[@]}"; do edit_file "${file}"; done
    get_inits | while read -r file; do edit_file "${file}"; done
}
function run_init(){
    get_inits | while read -r file; do
        if ask_user "Do you really want to execute" "${file}"; then
            chmod +x "${file}" && ! "${file}" && echo -e "${CLR_ERROR} init script failed!" && exit 1
        fi
    done
}
function save_action(){
    [[ "${BRANCH_OK}" != "y" ]] && echo -e "${CLR_ERROR} current branch ('${BRANCH_ACTUAL}') is not whitelisted ('${BRANCH_WHITELISTED}')" && exit 1
    ### BACKUP ###
    { [[ -d "${DIR_BACKUP}" ]] && cd "${DIR_BACKUP}" && find . -type f | cut -c 3-
        [[ -f "${FILE_TRACK}" ]] && while read -r line || [[ -n "${line}" ]]; do
            if [[ -n "${line}" && "${line:0:1}" != "/" ]] ; then
                file=${HOME}/${line}
                [[ -f "${file}" ]] && echo "${line}";
                [[ -d "${file}" ]] && cd "${HOME}" && find "./${line}" -type f | cut -c 3-
            fi
        done < "${FILE_TRACK}"
    } | sort -u | while read -r line; do 
        file="${HOME}/${line}"
        backup="${DIR_BACKUP}/${line}"
        if [[ -f "${file}" && ! -f "${backup}" ]]; then
            echo -en "${CLR_FILE}${file}${CLR_CLEAN}" && [[ "${OPT_VERB}" == "y" ]] && echo -en " : backup file is missing!"; echo
            [[ "${ACTION}" == "s" ]] && ask_user "Do you really want to create backup file"  && copy_file "${file}" "${backup}"
        elif [[ ! -f "${file}" && -f "${backup}" ]]; then
            echo -en "${CLR_FILE}${file}${CLR_CLEAN}" && [[ "${OPT_VERB}" == "y" ]] && echo -en " : original file is missing!"; echo
            [[ "${ACTION}" == "s" ]] && ask_user "Do you really want to delete backup file" && rm "${backup}"
            [[ "${ACTION}" == "b" ]] && ask_user "Do you really want to create original file" && copy_file "${backup}" "${file}"
        elif ! diff -q "${file}" "${backup}" 1>/dev/null; then
            echo -en "${CLR_FILE}${file}${CLR_CLEAN}" && [[ "${OPT_VERB}" == "y" ]] && echo -en " : original and backup files differ!"; echo
            [[ "${OPT_DIFF}" == "y" ]] && print_line
            [[ "${OPT_DIFF}" == "y" && "${ACTION}" != "b" ]] && diff --color -u "${backup}" "${file}"
            [[ "${OPT_DIFF}" == "y" && "${ACTION}" == "b" ]] && diff --color -u "${file}" "${backup}" 
            [[ "${OPT_DIFF}" == "y" ]] && print_line
            [[ "${ACTION}" == "s" ]] && ask_user "Do you really want to update backup file" && copy_file "${file}" "${backup}"
            [[ "${ACTION}" == "b" ]] && ask_user "Do you really want to update original file" && copy_file "${backup}" "${file}"
        fi
    done
    ### COMMIT ###
    if [[ "${OPT_COMM}" == "y" ]]; then
        [[ "${ACTION}" == "s" ]] && git -C "${SCRIPT_DIR}" pull -q
        git -C "${SCRIPT_DIR}" add "${SCRIPT_DIR}"
        git -C "${SCRIPT_DIR}" status -su | while read -r status file; do
            [[ "${OPT_DIFF}" == "y" ]] && diff="$( [[ -n "$(git -C "${SCRIPT_DIR}" diff HEAD --diff-filter=adcr -- "${file}")" ]] && echo y)"
            echo -en "${CLR_FILE}${file}${CLR_CLEAN}"
            [[ "${OPT_VERB}" == "y" ]] && echo -en " : to be commited (${status})"
            echo && [[ "${diff}" == "y" ]] && print_line
            [[ "${OPT_DIFF}" == "y" && "${ACTION}" != "b" ]] && git -C "${SCRIPT_DIR}" --no-pager diff HEAD --diff-filter=adcr -- "${file}" 
            [[ "${OPT_DIFF}" == "y" && "${ACTION}" == "b" ]] && git -C "${SCRIPT_DIR}" --no-pager diff HEAD --diff-filter=adcr -R -- "${file}" 
            [[ "${diff}" == "y" ]] && print_line
        done
        git -C "${SCRIPT_DIR}" restore --staged "${SCRIPT_DIR}"
        [[ -n "$(git -C "${SCRIPT_DIR}" status -s)" ]] && case "${ACTION}" in
            b)  if ask_user "Do you really want to restore all"; then
                    git -C "${SCRIPT_DIR}" restore "${SCRIPT_DIR}" -q
                    git -C "${SCRIPT_DIR}" clean -fq
                fi ;;
            s)  if ask_user "Do you really want to commit all"; then
                    git -C "${SCRIPT_DIR}" add "${SCRIPT_DIR}"
                    echo -en "${CLR_MSG}Write commit message: ${CLR_CLEAN}"
                    read -r msg </dev/tty
                    git -C "${SCRIPT_DIR}" commit -m "${msg}" -q
                fi ;;
        esac
        [[ "${ACTION}" == "s" ]] && git -C "${SCRIPT_DIR}" push -q
    fi
}
function help_msg(){
    echo -e "\
Flag options:
- c         commit, pull, push if possible
- d         show diffs
- v         show verbose output
- y         always answer yes to questions  \n
Action options:
- b         restore backup
- e         edit config, init files
- g         goto whitelisted branch
- h         show help message
- r         run init scripts
- s         save tracked files
- w         change whitelisted branch"
}

# init, parse, execute functions
function init_ops(){
    [[ "${BRANCH_OK}" != "y" ]] && mkdir -p "${DIR_USERCONFIG}" && touch "${FILE_BRANCH}"
    [[ "${BRANCH_OK}" != "y" ]] && for dir in "${DIRS[@]}"; do [[ -e "${dir}" && -z "$(ls -A "${dir}")" ]] && rmdir "${dir}"; done
    [[ "${BRANCH_OK}" == "y" ]] && for dir in "${DIRS[@]}"; do mkdir -p "${dir}"; done && for file in "${FILES[@]}"; do touch "${file}"; done
}
function parse(){
    case "${1}" in
        save) parse_options "-scvy";;
        restore) parse_options "-bvy";;
        init) parse_options "-ry";;
        edit) parse_options "-ey";;
        help) parse_options "-h";;
        branch) parse_options "-w" "${*:2}";;
        switch) parse_options "-g";; 
        *) parse_options "${@}";;
    esac
}
function parse_options(){
    while getopts ':bcdeghrsvw:y' OPTION; do
        case "${OPTION}" in 
            b|e|g|h|r|s) ACTION+="${OPTION}";;
            w) ACTION+="${OPTION}"; ARG_BRANCH="${OPTARG}" ;;
            c) OPT_COMM="y" ;;
            d) OPT_DIFF="y" ;;
            v) OPT_VERB="y" ;;
            y) OPT_YES="y" ;;
            *) echo -e "${CLR_ERROR} flag (-${OPTARG}) is not valid!"; exit 1;;
        esac
    done
}
function execute_action(){
    case "${ACTION}" in
        b|s|"") save_action;;
        e) edit_config;;
        g) goto_branch;;
        h) help_msg;;
        r) run_init;;
        w) whitelist_branch;;
        *) echo -e "${CLR_ERROR} multiple actions (-${ACTION}) are not supported!"; exit 1 ;;
    esac
}

# actual execution
init_ops
parse "${@}"
execute_action
exit 0
