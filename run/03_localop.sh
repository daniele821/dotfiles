#!/bin/env bash

# utility functions
function ask_user() {
    echo -en "\x1b[1;37m${*}? \x1b[m"
    read -r answer </dev/tty
    [[ "${answer,,}" == 'y' ]]
}

{
    ### MANDATORY OPERATIONS ###
    # create personal dirs
    if ! [[ -d "/personal" ]]; then
        sudo mkdir -p /personal/{data,repos} || exit 1
        sudo chown "${USER}":"${USER}" /personal/{data,repos}
        echo "created personal directory in /personal"
    fi

    # copy passwords from usb drive to this device
    if ! [[ -d "/personal/data/passwords" ]]; then
        if [[ -d "/run/media/$USER/*/passwords" ]] && ! [[ -e "/personal/data/passwords" ]]; then
            cp "/run/media/$USER/*/passwords" "/personal/data/" -r
            echo "copied passwords from usb drive"
        fi
    fi
    ### END OF MANDATORY OPERATIONS ###

    # restore backup files
    if ask_user 'Do you want to restore all backup files'; then
        SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
        SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"
        "${SCRIPT_DIR}/../autosaver" restoreall
    fi

    # create ssh keys for github
    if ask_user 'Do you really want to create new ssh keys, and adding them to github via gh'; then
        for user in daniele821 danix1234; do
            ssh-keygen -t ed25519 -f ~/.ssh/id_"${user}"
            gh auth login --with-token <"/personal/data/passwords/github/tokens/token-${user}.txt"
            gh ssh-key add "/home/daniele/.ssh/id_${user}.pub" --title "auto-generated on $(cat /sys/devices/virtual/dmi/id/product_name)"
        done
    fi

    # enable wireshark (requires reboot)
    if ask_user 'Do you really want to enable Wireshark for the current user'; then
        sudo usermod -a -G wireshark "${USER}"
    fi

    # create symlinks
    if ask_user 'Do you really want to create symlink for neovim'; then
        rm -rf "$HOME/.config/nvim" &>/dev/null # rm -rf is very DANGEROUS!
        ln -s /personal/repos/daniele821/nvim-config "$HOME/.config/nvim"
    fi

} </dev/tty

exit 0
