#!/bin/env bash

set -e

{
    # global variables often reused
    PASSWD_DIR="/personal/secrets/passwords"
    FIREFOX_INIT="$HOME/.mozilla/firefox/.init_mozilla_profiles"

    # copy passwords from usb drive
    while ! [[ -d "$PASSWD_DIR" ]]; do
        PASSWORD_DIRS="$(find "/run/media/$USER" -name passwords 2>/dev/null)" || true
        if [[ "$(echo "$PASSWORD_DIRS" | wc -w)" -gt 0 && "$(echo "$PASSWORD_DIRS" | wc -l)" -eq 1 ]]; then
            echo "copying passwords from usb..."
            cp -r "$PASSWORD_DIRS" "$PASSWD_DIR"
            git -C "$PASSWD_DIR" restore "$PASSWD_DIR"
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
    if ! [[ -d "$HOME/.config/gh" ]]; then
        TMP_DIR="$(mktemp -d)"
        cd "$TMP_DIR"
        dnf download gh
        rpm2cpio ./gh*.rpm | cpio -idm
        GH="$TMP_DIR/usr/bin/gh"
        USERS=(daniele821 danix1234)
        STATUS="$("$GH" auth status 2>/dev/null)" || true
        ADDED_USERS=()
        for user in "${USERS[@]}"; do
            if ! echo "$STATUS" | grep "$user" &>/dev/null; then
                ADDED_USERS+=("$user")
                ssh-keygen -t ed25519 -f ~/.ssh/id_"${user}" -N "" || true
                "$GH" auth login --with-token <"$PASSWD_DIR/github/tokens/token-${user}.txt"
                "$GH" ssh-key add "$HOME/.ssh/id_${user}.pub" --title "auto-generated on $(cat /sys/devices/virtual/dmi/id/product_name)"
            fi
        done
        for user in "${ADDED_USERS[@]}"; do
            until ssh -T "git@${user}.github.com" 2>&1 | grep -q "successfully authenticated"; do
                echo "Waiting for ${user} SSH key to propagate..."
                sleep 1
            done
        done
        rm -rf "$TMP_DIR"
    fi

    # restore firefox backup
    if ! [[ -f "$FIREFOX_INIT" ]]; then
        rm -rf "$HOME/.mozilla"
        killall firefox || true
        firefox --headless --no-remote --safe-mode about:blank &
        sleep 1 && kill $!
        find ~/.mozilla/firefox -maxdepth 1 -name '*.default*' | while read -r profile; do
            echo "initializing '$profile'..."
            TMP_DIR="$(mktemp -d)"
            rm -rf "$profile"
            cd "$TMP_DIR"
            cp -r "$PASSWD_DIR/firefox.zip" ./firefox.zip
            unzip firefox.zip >/dev/null
            rm firefox.zip
            mv ./* "$profile"
            cd
            rm -rf "$TMP_DIR"
        done
        touch "$FIREFOX_INIT"
    fi

    # install Firacode font
    if ! [[ -d "$HOME/.local/share/fonts/FiraCode" ]]; then
        mkdir -p "$HOME/.local/share/fonts/FiraCode"
        cd "$HOME/.local/share/fonts/FiraCode"
        wget -O Firacode.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
        unzip Firacode.zip
        rm Firacode.zip LICENSE README.md
    fi

} </dev/tty

exit 0
