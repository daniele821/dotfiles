#!/bin/env bash

set -e

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
        function get_usb() {
            USB_PATH="$(lsblk -o NAME,TRAN,MOUNTPOINT -J | jq -r '
                .blockdevices[] 
                | select(.tran == "usb") 
                | recurse(.children[])? 
                | select(.mountpoint != null) 
                | .mountpoint ')"
            if [[ "$(echo "$USB_PATH" | wc -w)" -eq 0 ]]; then
                echo 'no usb devices connected'
                return 1
            elif [[ "$(echo "$USB_PATH" | wc -l)" -gt 1 ]]; then
                echo 'more then one usb device connected'
                return 1
            else
                pass_dir="$(find "$USB_PATH" -type d -name "passwords" 2>/dev/null)"
                if [[ "$(echo "$pass_dir" | wc -w)" -eq 0 ]]; then
                    echo "no password directory found in $USB_PATH"
                    return 1
                elif [[ "$(echo "$pass_dir" | wc -l)" -gt 1 ]]; then
                    echo "more then one password directory found in $USB_PATH"
                    return 1
                else
                    echo "$pass_dir"
                    return 0
                fi
            fi
        }
        answer=""
        while [[ "$answer" != "SKIP" ]]; do
            if USB_PASSWORD_DIR="$(get_usb)"; then
                break
            else
                echo "WARNING: $USB_PASSWORD_DIR"
                echo -en "\x1b[1;31mWARNING: Insert a usb device with the passwords backup or type SKIP to skip... \x1b[m"
                read -r answer </dev/tty
            fi
        done
        usb_passwords="$USB_PASSWORD_DIR"
        new_location="/personal/data/passwords"
        if [[ -d "$usb_passwords" ]] && [[ ! -e "$new_location" ]]; then
            cp "$usb_passwords" "$new_location" -r
            git -C "$new_location" restore "$new_location"
            echo "copied passwords from usb drive"
        fi
    fi
    ### END OF MANDATORY OPERATIONS ###

    # restore backup files
    if ask_user 'Do you want to restore all backup files'; then
        SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
        SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"
        BRANCH="" "${SCRIPT_DIR}/../autosaver" restoreall
    fi

    # create ssh keys for github
    if ask_user 'Do you really want to create new ssh keys, and adding them to github via gh'; then
        for user in daniele821 danix1234; do
            ssh-keygen -t ed25519 -f ~/.ssh/id_"${user}" || true
            gh auth login --with-token <"/personal/data/passwords/github/tokens/token-${user}.txt"
            gh ssh-key add "$HOME/.ssh/id_${user}.pub" --title "auto-generated on $(cat /sys/devices/virtual/dmi/id/product_name)"
        done
    fi

    # install rust
    if ask_user 'Do you really want to install rust'; then
        rustup-init -y
    fi

} </dev/tty

exit 0
