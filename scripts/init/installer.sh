#!/bin/bash

# modify the script, in all places where 'TODO' is written

function ask_user() {
    echo -ne "$@"
    read -r answer
    [[ "${answer,,}" == "y" ]]
}
function exists() {
    command -v "$@" &>/dev/null
}

# resolve requirements to run this script
if ! exists git; then
    if exists apt; then
        sudo apt install git -y
    elif exists dnf; then
        sudo dnf --assumeyes install git
    else
        echo 'git is not installed'
        exit 1
    fi
fi </dev/tty

echo -n "What branch do you want to use? "
read -r answer
[[ -z "$answer" ]] && exit 1
BRANCH="$answer"

# run initialization scripts in dotfiles repository
if ask_user "Do you want to run init scripts? "; then
    TMP_DIR="$(mktemp -d /tmp/dotfilesXXXXXXXXXXXXXXXXX)" &&
        git clone https://github.com/daniele821/dotfiles "${TMP_DIR}" --branch="${BRANCH}" --depth=1 &&
        ! "${TMP_DIR}/autosaver" run && exit 1
fi </dev/tty

# install git repos
if ask_user "Do you want to download git repos? "; then
    # hacky way to assure github is added to valid ssh servers
    git clone git@daniele821.github.com:daniele821/dotfiles.git "$(mktemp -d)/temporary"

    TMP_DIR="$(mktemp -d /tmp/dotfilesXXXXXXXXXXXXXXXXX)" &&
        git clone https://github.com/daniele821/dotfiles "${TMP_DIR}" --branch="${BRANCH}" --depth=1 &&
        ! "${TMP_DIR}/scripts/git_repos/restore_git_repos.sh" && exit 1
fi </dev/tty
