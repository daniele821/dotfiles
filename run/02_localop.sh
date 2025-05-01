#!/bin/env bash

set -e

{
    # create personal dirs
    if ! [[ -d "/personal" ]]; then
        sudo mkdir -p /personal/{data,repos} || exit 1
        sudo chown "${USER}":"${USER}" /personal/{data,repos}
        echo "created personal directory in /personal"
    fi

    # copy passwords from usb drive
    while ! [[ -d "/personal/data/passwords" ]]; do
        PASSWORD_DIRS="$(find "/run/media/$USER" -name passwords)"
        if [[ "$(echo "$PASSWORD_DIRS" | wc -w)" -gt 0 && "$(echo "$PASSWORD_DIRS" | wc -l)" -eq 1 ]]; then
            cp -r "$PASSWORD_DIRS" /personal/data/passwords
            git -C /personal/data/passwords/ restore /personal/data/passwords/
            break
        elif [[ "$(echo "$PASSWORD_DIRS" | wc -l)" -gt 1 ]]; then
            echo -en "\e[1;31mMultiple password directories found in usb drive. Fix it or type SKIP... \e[m"
        else
            echo -en "\e[1;31mPasswords missing, mount a usb drive to copy them. Otherwise type SKIP... \e[m"
        fi
        read -r answer </dev/tty
        [[ "$answer" == "SKIP" ]] && break
    done

    # create ssh keys for github
    for user in daniele821 danix1234; do
        if ! gh auth status | grep "$user" &>/dev/null; then
            ssh-keygen -t ed25519 -f ~/.ssh/id_"${user}" || true
            gh auth login --with-token <"/personal/data/passwords/github/tokens/token-${user}.txt"
            gh ssh-key add "$HOME/.ssh/id_${user}.pub" --title "auto-generated on $(cat /sys/devices/virtual/dmi/id/product_name)"
        fi
    done

    # adding user to groups
    for group in docker wireshark; do
        if ! id -nG | grep -qw "$group" &>/dev/null; then
            echo "adding user to '$group' group"
            sudo usermod -aG "$group" "$USER"
        fi
    done

} </dev/tty

exit 0
