#!/bin/env bash

set -e

# global variables often reused
DOTFILES_ROOT="$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"/../)"
INIT_DIR="$HOME/.local/share/init_operations_done"
FIREFOX_INIT="$INIT_DIR/firefox-profile"
FIRACODE_INIT="$INIT_DIR/firacode-installed"
DOTFILES_INIT="$INIT_DIR/dotfiles-restored"
GITREPOS_INIT="$INIT_DIR/gitrepos-downloaded"

# restore firefox backup
if ! [[ -f "$FIREFOX_INIT" ]]; then
    echo -e "\e[1;37minitializing firefox...\e[m"
    killall firefox 2>/dev/null || true
    rm -rf ~/.mozilla
    firefox --headless --no-remote --safe-mode about:blank &>/dev/null &
    sleep 2 && kill $!
    TMP_DIR="$(mktemp -d)"
    cd "$TMP_DIR"
    curl -L "https://addons.mozilla.org/firefox/downloads/latest/darkreader/addon-953454-latest.xpi" -o addon@darkreader.org.xpi
    curl -L "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/addon-406847-latest.xpi" -o sponsorBlocker@ajay.app.xpi
    curl -L "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/addon-607454-latest.xpi" -o uBlock0@raymondhill.net.xpi
    find ~/.mozilla/firefox -maxdepth 1 -name '*.default*' | while read -r profile; do
        rm -rf "$profile"
        cp -r "$DOTFILES_ROOT/others/firefox/init/" "$profile"
        mkdir -p "$profile/extensions/"
        cp "$TMP_DIR/"* "$profile/extensions"
    done
    rm -rf "$TMP_DIR"
    mkdir -p "$INIT_DIR" && touch "$FIREFOX_INIT"
fi

# install Firacode font
if ! [[ -f "$FIRACODE_INIT" ]]; then
    echo -e "\e[1;37minstalling firacode nerd font...\e[m"
    FIRACODE_DIR="$HOME/.local/share/fonts/FiraCode"
    rm -rf "$FIRACODE_DIR"
    mkdir -p "$FIRACODE_DIR"
    cd "$FIRACODE_DIR"
    curl -L -o Firacode.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
    unzip Firacode.zip >/dev/null
    rm Firacode.zip LICENSE README.md
    mkdir -p "$INIT_DIR" && touch "$FIRACODE_INIT"
fi

# restore files
if ! [[ -f "$DOTFILES_INIT" ]]; then
    echo -e "\e[1;37mrestoring dotfiles...\e[m"
    "$DOTFILES_ROOT/autosaver" restoreall
    mkdir -p "$INIT_DIR" && touch "$DOTFILES_INIT"
fi

# download git repos
if ! [[ -f "$GITREPOS_INIT" ]]; then
    echo -e "\e[1;37mrestoring git repos...\e[m"
    "$DOTFILES_ROOT/autosaver" git
    mkdir -p "$INIT_DIR" && touch "$GITREPOS_INIT"
fi
