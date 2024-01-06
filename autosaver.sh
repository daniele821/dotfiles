#!/bin/bash

# autosaver.sh                  <Daniele Muffato>
#
# script to track and backup files in the home directory
# and to save init scripts to run at OS installation
#
# WARNING: this file MUST be in the root of the dotfiles directory


### VARIABLES ###
SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"
DIRS=(
    "${SCRIPT_DIR}/backup"
    "${SCRIPT_DIR}/userconfig"
    "${SCRIPT_DIR}/config"
    "${SCRIPT_DIR}/init"
)
USER_CONFIG_FILES=(
    "${DIRS[1]}/whitelisted_branch.txt"
)
CONFIG_FILES=(
    "${DIRS[2]}/files_to_track.txt"
    "${DIRS[2]}/init_scripts.txt"
)
OUTPUT="/dev/null"
EDITOR="nvim"; nvim --version &>/dev/null || EDITOR="vim"; vim --version &>/dev/null || EDITOR="nano"


### FLAGS ###
ON_BRANCH="n"   # n/y           (no/yes)
YEAH_OPT="n"    # n/y           (no/yes)
VERB_OPT="n"    # n/y           (no/yes)
DIFF_OPT="n"    # n/y           (no/yes)
COMM_ACT="n"    # n/y           (no/yes)
PUSH_ACT="n"    # n/y           (no/yes)
SAVE_ACT="n"    # n/y           (no/yes)
BACK_ACT="n"    # n/y           (no/yes)
ACTION=""       # ' '/s/e/i/h   (none/save/edit/init/help)


### COLOR FUNCTIONS ###
function clr_none(){
    echo -e "${1}\c"
}
function clr_message(){
    echo -e "\e[1;33m${1}\e[m\c"
}
function clr_file(){
    clr_file_full "$(dirbasename "${1}")"
}
function clr_file_full(){
    echo -e "\e[1;36m${1}\e[m\c"
}
function clr_success(){
    echo -e "\e[1;32m${1}\e[m\c"
}
function clr_warn(){
    echo -e "\e[1;33mWARNING:\e[m ${1}\c"
}
function clr_err(){
    echo -e "\e[1;31mERROR:\e[m ${1}\c"
}
function clr_err_quit(){
    clr_err "${1}\n"
    exit 1
}

### FILESYSTEM FUNCTIONS ###
function dirbasename(){
    echo "$(basename "$(dirname "${1}")")/$(basename "${1}")"
}
function touch_file(){
    mkdir -p "$(dirname "${1}")" && touch "${1}"
}
function copy_file(){
    mkdir -p "$(dirname "${2}")" && cp "${1}" "${2}"
}
function edit_file(){
    ask_user "Do you really want to edit" "${1}" && touch_file "${1}" && "${EDITOR}" "${1}" < /dev/tty
    [[ -z "$(read_file "${1}" | xargs -0 2>"${OUTPUT}")" ]] && rm "${1}" &> "${OUTPUT}"
    rmdir "$(dirname "${1}")" &> "${OUTPUT}"
    [[ "${2}" == "exec" ]] && chmod +x "${1}" &> "${OUTPUT}"
}
function read_file(){
    cat "${1}" 2> "${OUTPUT}"
}


### GIT FUNCTIONS ###
# check if current branch is whitelisted
function git_check_branch(){
    CURRENT="$(git -C "${SCRIPT_DIR}" rev-parse --abbrev-ref HEAD)"
    WHITELISTED="$(read_file "${USER_CONFIG_FILES[0]}")"
    [[ "${CURRENT}" == "${WHITELISTED}" ]] && ON_BRANCH="y"
}

# make the necessary git check, if any fails exit script
function git_checks_quit(){
    # check and exits if git repo is empty (ie: no commits)
    GIT_OBJECTS="$(git -C "${SCRIPT_DIR}" count-objects 2> "${OUTPUT}" | awk '{print $1}')"
    [[ "${GIT_OBJECTS}" -gt "0" ]] || clr_err_quit "this git repo is empty!"

    # checks and exit if current branch is not whitelisted
    [[ "${ON_BRANCH}" != "y" ]] && clr_err_quit "the current branch is not whitelisted!"
}

# check if user name and email are valid, otherwise force user to fix them
function git_fix_user(){
    # fix user.name
    while [[ -z "$(git -C "${SCRIPT_DIR}" config user.name)" ]]; do
        clr_warn "git user name is invalid! Insert git name: "
        read -r answer
        git -C "${SCRIPT_DIR}" config user.name "${answer}"
    done

    # fix user.email
    while [[ -z "$(git -C "${SCRIPT_DIR}" config user.email)" ]]; do
        clr_warn "git user email is invalid! Insert git email: "
        read -r answer
        git -C "${SCRIPT_DIR}" config user.email "${answer}"
    done
}

# pull from remote
function git_pull(){
    FAIL="0"
    while ! git -C "${SCRIPT_DIR}" pull &> "${OUTPUT}"; do
        clr_warn "git pull failed! Retrying...\n";
        sleep 1;
        FAIL=$(( FAIL + 1 )) 
        [[ "${FAIL}" -ge "10" ]] && clr_err_quit "git pull failed a lot of times! Quitting program..."
    done
    clr_success "git pull successfull\n"
}

# push to remote
function git_push(){
    FAIL="0"
    while ! git -C "${SCRIPT_DIR}" push &> "${OUTPUT}"; do
        clr_warn "git push failed! Retrying...\n";
        sleep 1;
        FAIL=$(( FAIL + 1 )) 
        [[ "${FAIL}" -ge "10" ]] && clr_err_quit "git push failed a lot of times! Quitting program..."
    done
    clr_success "git push successfull\n"
}


### UTILITY FUNCTIONS ###
# ask user confermation
function ask_user(){
   clr_message "${1} " 
   [[ -n "${2}" ]] && clr_file "${2} " 
   clr_message "? "
   [[ "${YEAH_OPT}" == "y" ]] && answer="y" && echo "y"
   [[ "${YEAH_OPT}" != "y" ]] && read -r answer </dev/tty
   [[ "${answer,,}" == "y" ]]
}

# store action to execute
function store_action(){
    [[ -n "${ACTION}" && "${ACTION}" != "${1}" ]] && clr_err_quit "cannot execute multiple actions!"
    ACTION="${1}"
}

# list tracked files 
function list_tracked_files(){
    [[ -f "${CONFIG_FILES[0]}" ]] && while read -r line || [[ -n "${line}" ]]; do
        if [[ -n "${line}" ]] ; then
            file=${HOME}/${line}
            backup="${DIRS[0]}"
            if [[ -f "${file}" || -f "${backup}" ]]; then
                echo "${file}";
            fi
            if [[ -d "${file}" ]]; then
                find "${file}" -type f
            fi
            if [[ -d "${backup}" ]]; then
                find "${backup}" -type f | while read -r tmp; do
                    echo "${tmp:${#DIRS[0]}}"
                done
            fi
        fi
    done < "${CONFIG_FILES[0]}" | sort -u
}

function parse_all(){
    case "${@}" in
        save) parse_options "-svycp";;
        restore) parse_options "-bvy";;
        init) parse_options "-iy";;
        edit) parse_options "-e";;
        help) parse_options "-h";;
        *) parse_options "${@}";;
    esac
}

# parse options
function parse_options(){
    while getopts ':bcdehiopsvy' OPTION; do
        case "${OPTION}" in
            b) store_action "s"; BACK_ACT="y" ;;
            c) store_action "s"; COMM_ACT="y" ;;
            d) DIFF_OPT="y" ;;
            e) store_action "e" ;;
            h) store_action "h" ;;
            i) store_action "i" ;;
            o) OUTPUT="/dev/tty" ;;
            p) store_action "s"; PUSH_ACT="y" ;;
            s) store_action "s"; SAVE_ACT="y" ;;
            v) VERB_OPT="y" ;;
            y) YEAH_OPT="y" ;;
            *) clr_err_quit "-${OPTARG} is an invalid option!" ;;
        esac
    done
}

# execute stored action
function execute_action(){
    case "${ACTION}" in
        e) edit_files;;
        h) help_msg;;
        i) git_checks_quit; run_init ;;
        s|"") git_checks_quit; save_action ;;
        *) clr_err_quit "${ACTION} not a valid action!";;
    esac
}

# print help message
function help_msg(){
    echo "\
Usage: ./${SCRIPT_NAME} [options] 

script to automagically track dotfiles around the user 
home directory, and to backup init script files to be 
execute on a fresh reinstall of the current OS

Flag Options:
- d         shows diffs
- y         tries to always answer yes to all interactions
- v         show verbose output

Action Options (only one is accepted!):
- b         restores backup files
- c         commits changes
- e         edits config files
- h         shows help message
- i         runs init scripts
- o         output everything (debug)
- p         push commits to remote
- s         saves files 

Shortcuts:
save        saves all files, commits and pushes
restore     restores current backup
edit        edit config files
help        show this help message
init        run all initialization scripts
        "
}

# run init scripts
function run_init(){
    [[ -f "${CONFIG_FILES[1]}" ]] && while read -r script; do
        file="${DIRS[3]}/${script}"
        if [[ -f "${file}" ]] && ask_user "Do you really want to execute" "${file}"; then
            chmod +x "${file}"
            "${file}" </dev/tty || clr_err_quit "init script failed!"
        fi
    done < "${CONFIG_FILES[1]}"
}

# edit config and init files
function edit_files(){
    for file in "${USER_CONFIG_FILES[@]}"; do edit_file "${file}"; done
    if [[ "${ON_BRANCH}" == "y" ]]; then
        for file in "${CONFIG_FILES[@]}"; do edit_file "${file}"; done
        [[ -f "${CONFIG_FILES[1]}" ]] && while read -r filename; do edit_file "${DIRS[3]}/${filename}" "exec"; done < "${CONFIG_FILES[1]}"
    fi
}

# save actions
function save_action(){
    # checks
    [[ "${SAVE_ACT}" == "y" && "${BACK_ACT}" == "y" ]] && clr_err_quit "cannot save and restore at once!"

    ## save/restore/no action ##
    if [[ "${SAVE_ACT}" == "y" || "${BACK_ACT}" == "y" || -z "${ACTION}" ]]; then
        list_tracked_files | while read -r file; do
            # temporary flags
            backup="${DIRS[0]}${file}"
            BACK="n"; [[ -f "${backup}" ]] && BACK="y"
            FILE="n"; [[ -f "${file}" ]] && FILE="y"
            BOTH="n"; [[ "${FILE}" == "y" && "${BACK}" == "y" ]] && BOTH="y"
            MISS="n"; [[ "${BOTH}" != "y" ]] && [[ "${FILE}" == "y" || "${BACK}" == "y" ]] && MISS="y"
            DIFF="n"; [[ "${BOTH}" == "y" ]] && ! diff -q "${backup}" "${file}" &> "${OUTPUT}" && DIFF="y"
            CHNG="n"; [[ "${MISS}" == "y" || "${DIFF}" == "y" ]] && CHNG="y"
            
            # actions if files are different
            if [[ "${CHNG}" == "y" ]]; then
                # print file name
                clr_file_full "${file}"
                # verbose explanation
                if [[ "${VERB_OPT}" == "y" ]]; then
                    [[ "${FILE}" != "y" ]] && clr_none " : original file is missing"
                    [[ "${BACK}" != "y" ]] && clr_none " : backup file is missing"
                    [[ "${DIFF}" == "y" ]] && clr_none " : original and backup do differ"
                fi
                clr_none "\n"
                # show diff
                if [[ "${DIFF_OPT}" == "y" && "${DIFF}" == "y" ]]; then
                    [[ "${SAVE_ACT}" == "y" ]] && diff --color "${backup}" "${file}"
                    [[ "${BACK_ACT}" == "y" ]] && diff --color "${file}" "${backup}"
                fi
                # save / restore
                if [[ "${SAVE_ACT}" == "y" ]] ; then
                    [[ "${FILE}" != "y" ]] && ask_user "Do you really want to delete backup file" && rm "${backup}"
                    [[ "${BACK}" != "y" ]] && ask_user "Do you really want to create backup file" && copy_file "${file}" "${backup}"
                    [[ "${DIFF}" == "y" ]] && ask_user "Do you really want to save file" && copy_file "${file}" "${backup}"
                elif  [[ "${BACK_ACT}" == "y" ]] ; then
                    [[ "${FILE}" != "y" ]] && ask_user "Do you really want to create original file" && copy_file "${backup}" "${file}"
                    [[ "${DIFF}" == "y" ]] && ask_user "Do you really want to restore file" && copy_file "${backup}" "${file}"
                fi
            fi
        done
    fi
     
    ## pull ##
    [[ "${PUSH_ACT}" == "y" || "${COMM_ACT}" == "y" ]] && git_pull

    ## commit ##
    if [[ "${COMM_ACT}" == "y" ]] && [[ -n "$(git -C "${SCRIPT_DIR}" status -s)" ]] ; then
        # show status
        git -C "${SCRIPT_DIR}" add . &> "${OUTPUT}"
        git -C "${SCRIPT_DIR}" status -s | awk '{print $2}' | while read -r file; do
            clr_file_full "$(basename "${SCRIPT_DIR}")/${file}";
            [[ "${VERB_OPT}" == "y" ]] && clr_none " : not commited yet"
            echo
            [[ "${DIFF_OPT}" == "y" ]] && git -C "${SCRIPT_DIR}" diff HEAD -- "${file}"
        done
        git -C "${SCRIPT_DIR}" restore --staged . &> "${OUTPUT}"

        # do commit
        if ask_user "Do you really want to commit everything"; then
            git -C "${SCRIPT_DIR}" add . &> "${OUTPUT}"
            clr_message "Insert commit name: " 
            read -r answer
            [[ -z "${answer}" ]] && clr_err_quit "invalid commit name!"
            git -C "${SCRIPT_DIR}" commit -m "${answer}" &> "${OUTPUT}"
        fi
    fi

    ## push ##
    [[ "${PUSH_ACT}" == "y" ]] && git_push
}


### ACTUAL EXECUTION ###
git_check_branch
parse_all "${@}"
execute_action
exit 0
