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
    # backup files
    "${SCRIPT_DIR}/backup"
    # config files
    "${SCRIPT_DIR}/userconfig"
    # config files
    "${SCRIPT_DIR}/config"
    # init scripts
    "${SCRIPT_DIR}/init"
)
USER_CONFIG_FILES=(
    # branch on which all actions are allowed
    "${DIRS[1]}/whitelisted_branch.txt"
    # editor for editing files
    "${DIRS[1]}/file_editor.txt"
)
CONFIG_FILES=(
    # list of files to be tracked
    "${DIRS[2]}/files_to_track.txt"
    # list of init scripts
    "${DIRS[2]}/init_scripts.txt"
)


### FLAGS ###
ON_BRANCH="n"   # n/y           (no/yes)
YEAH_OPT="n"    # n/y           (no/yes)
VERB_OPT="n"    # n/y           (no/yes)
DIFF_OPT="n"    # n/y           (no/yes)
COMM_ACT="n"    # n/y           (no/yes)
PUSH_ACT="n"    # n/y           (no/yes)
SAVE_ACT="n"    # n/y           (no/yes)
BACK_ACT="n"    # n/y           (no/yes)
ACTION=""       # ' '/s/e/i/h/r (none/save/edit/init/help/rmdir)


### COLOR FUNCTIONS ###
# no color
# args:
# 1: message
function clr_none(){
    echo -e "${1}\c"
}

# color question
# args:
# 1: message
function clr_message(){
    echo -e "\e[1;33m${1}\e[m\c"
}

# color file path 
# args:
# 1: file name
function clr_file(){
    echo -e "\e[1;36m${1}\e[m\c"
}

# color warning message
# args:
# 1: warning message
function clr_warn(){
    echo -e "\e[1;33mWARNING:\e[m ${1}\c"
}

# color error message
# args:
# 1: error message
function clr_err(){
    echo -e "\e[1;31mERROR:\e[m ${1}\c"
}

# color error message and quit
# args:
# 1: error message
function clr_err_quit(){
    clr_err "${1}\n"
    exit 1
}


### GIT FUNCTIONS ###
# check if current branch is whitelisted
function git_check_branch(){
    CURRENT="$(git -C "${SCRIPT_DIR}" rev-parse --abbrev-ref HEAD)"
    WHITELISTED="$(cat "${USER_CONFIG_FILES[0]}" 2>/dev/null)"
    [[ "${CURRENT}" == "${WHITELISTED}" ]] && ON_BRANCH="y"
}

# make the necessary git check, if any fails exit script
function git_checks_quit(){
    # check and exits if git repo is empty (ie: no commits)
    GIT_OBJECTS="$(git -C "${SCRIPT_DIR}" count-objects 2>/dev/null | awk '{print $1}')"
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


### UTILITY FUNCTIONS ###
# read from file
# args:
# file full path
function read_file(){
    cat "${1}" 2>/dev/null
}

# ask user confermation
# args:
# 1: question
function ask_user(){
   clr_message "${1} " 
   [[ "${FORCE_YES}" == "y" ]] && answer="y" && echo "y"
   [[ "${FORCE_YES}" != "y" ]] && read -r answer </dev/tty
   [[ "${answer,,}" == "y" ]]
}

# store action to execute
# args:
# 1: action to execute
function store_action(){
    [[ -n "${ACTION}" && "${ACTION}" != "${1}" ]] && clr_err_quit "cannot execute multiple actions!"
    ACTION="${1}"
}

# parse options
function parse_options(){
    while getopts ':bcdehiprsvy' OPTION; do
        case "${OPTION}" in
            b) store_action "s"; BACK_ACT="y" ;;
            c) store_action "s"; COMM_ACT="y" ;;
            d) DIFF_OPT="y" ;;
            e) store_action "e" ;;
            h) store_action "h" ;;
            i) store_action "i" ;;
            p) store_action "s"; PUSH_ACT="y" ;;
            r) store_action "r" ;;
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
        e);;
        h) help_msg; exit 0 ;;
        i) git_checks_quit; run_init ;;
        r) git_checks_quit; remove_backup ;;
        s) git_checks_quit ;;
        "") ;;
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
- d     shows diffs
- y     tries to always answer yes to all interactions
- v     show verbose output

Action Options (only one is accepted!):
- b     restores backup files
- c     commits changes
- p     push commits to remote
- s     saves files 
- e     edits config files
- h     shows help message
- i     runs init scripts
- r     remove backup directory
        "
}

# remove backup directory
function remove_backup(){
    [[ -e "${DIRS[0]}" ]] && ask_user "Do you really want to remove backup directory?" && rm -rf "${DIRS[0]}"
}

# run init scripts
function run_init(){
    read_file "${CONFIG_FILES[1]}" | while read -r script; do
        file="${DIRS[3]}/${script}"
        file_="$(basename ${DIRS[3]})/$(basename ${file})"
        [[ -f "${file}" ]] && ask_user "Do you really want to execute $(clr_file ${file_})?" && chmod +x "${file}" && "${file}"
    done
}


### ACTUAL EXECUTION ###
git_check_branch
parse_options "${@}"
execute_action
exit 0
