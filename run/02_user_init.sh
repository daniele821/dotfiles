#!/bin/env bash

set -e

# global variables often reused
INIT_DIR="$HOME/.local/share/init_operations_done"
FIREFOX_INIT="$INIT_DIR/firefox-profile"
DOTFILES_INIT="$INIT_DIR/dotfiles-restored"
FIRACODE_INIT="$INIT_DIR/firacode-installed"
DOTFILES_ROOT="$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"/../)"

# restore firefox backup
if ! [[ -f "$FIREFOX_INIT" ]]; then
    killall firefox 2>/dev/null || true
    echo "initializing firefox..."
    rm -rf ~/.mozilla
    firefox --headless --no-remote --safe-mode about:blank &>/dev/null &
    sleep 2 && kill $!
    find ~/.mozilla/firefox -maxdepth 1 -name '*.default-release' | while read -r profile; do
        rm -rf "$profile"
        cp -r "$DOTFILES_ROOT/others/firefox-init/" "$profile"
        mkdir -p "$profile/extensions/"
        cd "$profile/extensions/"
        curl -s -L "https://addons.mozilla.org/firefox/downloads/latest/darkreader/addon-953454-latest.xpi" -o addon@darkreader.org.xpi
        curl -s -L "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/addon-406847-latest.xpi" -o sponsorBlocker@ajay.app.xpi
        curl -s -L "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/addon-607454-latest.xpi" -o uBlock0@raymondhill.net.xpi
    done
    mkdir -p "$INIT_DIR" && touch "$FIREFOX_INIT"
fi

# install Firacode font
if ! [[ -f "$FIRACODE_INIT" ]]; then
    FIRACODE_DIR="$HOME/.local/share/fonts/FiraCode"
    rm -rf "$FIRACODE_DIR"
    mkdir -p "$FIRACODE_DIR"
    cd "$FIRACODE_DIR"
    echo "installing firacode font..."
    curl -s -L -o Firacode.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
    unzip Firacode.zip >/dev/null
    rm Firacode.zip LICENSE README.md
    mkdir -p "$INIT_DIR" && touch "$FIRACODE_INIT"
fi

# restore files and download git repos
if ! [[ -f "$DOTFILES_INIT" ]]; then
    echo "restoring all dotfiles..."
    "$DOTFILES_ROOT/autosaver" restoreall >/dev/null
    mkdir -p "$INIT_DIR" && touch "$DOTFILES_INIT"
fi
