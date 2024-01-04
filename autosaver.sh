#!/bin/bash

# WARNING: this file MUST be in the root of the dotfiles directory

### VARIABLES 
# WARNING: array elements MUST not be changed of position
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

### UTILITY FUNCTIONS

### ACTUAL EXECUTION
