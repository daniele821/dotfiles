#!/bin/bash

# autosaver.sh                  <Daniele Muffato>
#
# script to track and backup files in the home directory
# and to save init scripts to run at OS installation
#
# WARNING: this file MUST be in the root of the dotfiles directory

### VARIABLES
SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"
SCRIPT_NAME="$(basename "${SCRIPT_PWD}")"
DIRS=(
    "${SCRIPT_DIR}/backup"
    "${SCRIPT_DIR}/config"
    "${SCRIPT_DIR}/init"
)
CONFIG_FILES=(
    # contains: list of files to be tracked
    "${DIRS[1]}/files_to_track.txt"
    # contains: branch on which all actions are allowed
    "${DIRS[1]}/whitelisted_branch.txt"
    # contains: editor for editing files
    "${DIRS[1]}/file_editor.txt"
    # contains: list of init scripts
    "${DIRS[1]}/init-scripts.txt"
)

### COLOR FUNCTIONS
function clr_file(){
    echo -e "\e[1;36m${1}\e[m\c"
}
function clr_warn(){
    echo -e "\e[1;33mWARNING:\e[m ${1}"
}
function clr_err(){
    echo -e "\e[1;31mERROR:\e[m ${1}"
}
function clr_err_quit(){
    clr_err "${1}"
    exit 1
}

### GIT FUNCTIONS
function git_is_repo_empty(){
    GIT_OBJECTS="$(git -C "${SCRIPT_DIR}" count-objects 2>/dev/null | awk '{print $1}')"
    [[ "${GIT_OBJECTS}" -gt "0" ]]
}
function git_current_branch(){
    git -C "${SCRIPT_DIR}" rev-parse --abbrev-ref HEAD 
}


