#!/bin/bash

# modify the script, in all places where 'TODO' is written

### TODO: VARIABLES TO MODIFY ###
BRANCH="main"

function ask_user() {
    echo -ne "$@"
    read -r answer
    [[ "${answer,,}" == "y" ]]
}

# resolve requirements to run this script
if ! command -v git &>/dev/null; then
    ### TODO: add here method to install git ###
    :
fi </dev/tty

# run initialization scripts in dotfiles repository
if ask_user "Do you want to run init scripts? "; then
    TMP_DIR="$(mktemp -d /tmp/dotfilesXXXXXXXXXXXXXXXXX)" &&
        git clone https://github.com/daniele821/dotfiles "${TMP_DIR}" --branch="${BRANCH}" --depth=1 &&
        ! "${TMP_DIR}/autosaver" run && exit 1
fi </dev/tty

# install git repos
if ask_user "Do you want to download git repos? "; then
    TMP_DIR="$(mktemp -d /tmp/dotfilesXXXXXXXXXXXXXXXXX)" &&
        git clone https://github.com/daniele821/dotfiles "${TMP_DIR}" --branch="${BRANCH}" --depth=1 &&
        ! "${TMP_DIR}/scripts/git_repos/restore_git_repos.sh" && exit 1
fi </dev/tty
