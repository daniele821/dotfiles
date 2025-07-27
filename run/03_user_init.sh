#!/bin/env bash

set -e

{
    # global variables often reused
    PASSWD_DIR="/personal/secrets/passwords"
    FIREFOX_INIT="$HOME/.mozilla/firefox/.init_mozilla_profiles"
    FIRACODE_DIR="$HOME/.local/share/fonts/FiraCode"
    AUTOSAVER_INIT="$HOME/.local/share/.init_autosaver_restorer"

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
    if ! [[ -d "$FIRACODE_DIR" ]]; then
        mkdir -p "$FIRACODE_DIR"
        cd "$FIRACODE_DIR"
        wget -O Firacode.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
        unzip Firacode.zip
        rm Firacode.zip LICENSE README.md
    fi

    # restore files and download git repos
    if ! [[ -f "$AUTOSAVER_INIT" ]]; then
        SCRIPT_PATH="$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../autosaver")"
        "$SCRIPT_PATH" git
        "$SCRIPT_PATH" restoreall
        touch "$AUTOSAVER_INIT"
    fi

} </dev/tty
