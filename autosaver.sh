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
    "${SCRIPT_DIR}/config"
    # init scripts
    "${SCRIPT_DIR}/init"
)
CONFIG_FILES=(
    # list of files to be tracked
    "${DIRS[1]}/files_to_track.txt"
    # branch on which all actions are allowed
    "${DIRS[1]}/whitelisted_branch.txt"
    # editor for editing files
    "${DIRS[1]}/file_editor.txt"
    # list of init scripts
    "${DIRS[1]}/init_scripts.txt"
)


### FLAGS ###
ON_BRANCH="n" # n/y         (no/yes)
YEAH_OPT="n" # n/y          (no/yes)
VERB_OPT="n" # n/y          (no/yes)
DIFF_OPT="n" # n/y          (no/yes)
SAVE_ACT="n"  # n/y         (no/yes)
BACK_ACT="n"  # n/y         (no/yes)
COMM_ACT="n"  # n/y         (no/yes)
PUSH_ACT="n"  # n/y         (no/yes)
ACTION="s"    # s/e/i/h/r   (save/edit/init/help/rmdir)


### COLOR FUNCTIONS ###
# no color
# args:
# 1: message
function clr_none(){
    echo -e "${1}\c"
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
# read from config file
# args:
# 1: config file index
function read_config(){
    cat "${1}" 2>/dev/null "${CONFIG_FILES["${1}"]}"
}

# create all dirs and files necessary for this script to run
function create_files(){
    for dir in "${DIRS[@]}"; do mkdir -p "${dir}"; done
    for conf_file in "${CONFIG_FILES[@]}"; do touch "${conf_file}"; done
    for init_file in $(read_config 3); do 
        file="${DIRS[2]}/${init_file}"
        touch "${file}" && chmod +x "${file}"
    done
}

# ask user confermation
# args:
# 1: question
function ask_user(){
   clr_none "${1} " 
   [[ "${FORCE_YES}" == "y" ]] && answer="y" && echo "y"
   [[ "${FORCE_YES}" != "y" ]] && read -r answer </dev/tty
   [[ "${answer,,}" == "y" ]]
}


### ACTUAL EXECUTION ###
git_check_branch
