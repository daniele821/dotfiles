#!/bin/env bash

# utility functions
function ask_user() {
    echo -en "\x1b[1m${*}? \x1b[m"
    read -r answer </dev/tty
    [[ "${answer,,}" == 'y' ]]
}

{
    # download starship
    if ask_user 'Do you really want to download starship locally'; then
        curl -sS https://starship.rs/install.sh | sh
    fi

    # download fira code nerd font
    if ask_user 'Do you really want to download firacode nerd font'; then
        FIRACODE_DIR="$HOME/.local/share/fonts/FiraCode"
        [[ -f "${FIRACODE_DIR}" ]] && rm -rf "$HOME/.local/share/fonts/FiraCode" # rewritten manually: rm -rf is HUGELY dangerous!
        mkdir -p "${FIRACODE_DIR}"
        cd "$(mktemp -d /tmp/firacode-fontXXXXXXXXXXXXXXXXXXX)" || exit 1
        wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip -O Firacode.zip
        unzip ./Firacode.zip
        mv ./*.ttf "${FIRACODE_DIR}/"
    fi

} </dev/tty

exit 0
