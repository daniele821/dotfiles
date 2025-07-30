#!/bin/env bash

set -e

{
    # global variables often reused
    FIREFOX_INIT="$HOME/.mozilla/firefox/.init_firefox_profile"
    FIRACODE_DIR="$HOME/.local/share/fonts/FiraCode"
    AUTOSAVER_INIT="$HOME/.local/share/.init_autosaver_restorer"

    # restore firefox backup
    if ! [[ -f "$FIREFOX_INIT" ]]; then
        killall firefox 2>/dev/null || true
        echo "initializing firefox..."
        rm -rf ~/.mozilla
        firefox --headless --no-remote --safe-mode about:blank &>/dev/null &
        sleep 2 && kill $!
        find ~/.mozilla/firefox -maxdepth 1 -name '*.default-release' | while read -r profile; do
            echo "initializing '$profile'..."
            rm -rf "$profile"
            cp -r "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../others/firefox-init/" "$profile"
            mkdir -p "$profile/extensions/"
            cd "$profile/extensions/"
            echo "downloading darkreader extension..."
            curl -s -L "https://addons.mozilla.org/firefox/downloads/latest/darkreader/addon-953454-latest.xpi" -o addon@darkreader.org.xpi
            echo "downloading sponsorblock extension..."
            curl -s -L "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/addon-406847-latest.xpi" -o sponsorBlocker@ajay.app.xpi
            echo "downloading ublock origin extension..."
            curl -s -L "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/addon-607454-latest.xpi" -o uBlock0@raymondhill.net.xpi
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
