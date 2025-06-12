#!/bin/env bash

set -e

[[ "$(id -u)" -eq 0 ]] && echo 'do not run this script as root!' && exit 1

{
    # copy passwords from usb drive
    while ! [[ -d "/personal/data/passwords" ]]; do
        PASSWORD_DIRS="$(find "/run/media/$USER" -name passwords 2>/dev/null)" || true
        if [[ "$(echo "$PASSWORD_DIRS" | wc -w)" -gt 0 && "$(echo "$PASSWORD_DIRS" | wc -l)" -eq 1 ]]; then
            echo "copying passwords from usb..."
            cp -r "$PASSWORD_DIRS" /personal/data/passwords
            git -C /personal/data/passwords/ restore /personal/data/passwords/
            break
        elif [[ "$(echo "$PASSWORD_DIRS" | wc -l)" -gt 1 ]]; then
            echo -en "\e[1;34mMultiple password directories found in usb drive. Fix it or type SKIP... \e[m"
        else
            echo -en "\e[1;34mPasswords missing, mount a usb drive to copy them. Otherwise type SKIP... \e[m"
        fi
        read -r answer </dev/tty
        [[ "$answer" == "SKIP" ]] && break
    done

    # create ssh keys for github and wait until gh successfully propagates ssh keys
    USERS=(daniele821 danix1234)
    STATUS="$(gh auth status 2>/dev/null)" || true
    ADDED_USERS=()
    for user in "${USERS[@]}"; do
        if ! echo "$STATUS" | grep "$user" &>/dev/null; then
            ADDED_USERS+=("$user")
            ssh-keygen -t ed25519 -f ~/.ssh/id_"${user}" -N "" || true
            gh auth login --with-token <"/personal/data/passwords/github/tokens/token-${user}.txt"
            gh ssh-key add "$HOME/.ssh/id_${user}.pub" --title "auto-generated on $(cat /sys/devices/virtual/dmi/id/product_name)"
        fi
    done
    for user in "${ADDED_USERS[@]}"; do
        until ssh -T "git@${user}.github.com" 2>&1 | grep -q "successfully authenticated"; do
            echo "Waiting for ${user} SSH key to propagate..."
            sleep 1
        done
    done

} </dev/tty

exit 0
