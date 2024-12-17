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

    # downloads for only x86 platform
    if [[ "$(uname -m)" == "x86_64" ]]; then

        # download kitten for terminal image drawing protocol
        if ask_user 'Do you really want to download kitten locally'; then
            TMP_FILE="$(mktemp)"
            wget https://github.com/kovidgoyal/kitty/releases/latest/download/kitten-linux-386 -O "${TMP_FILE}"
            chmod +x "${TMP_FILE}"
            sudo mv "${TMP_FILE}" /usr/local/bin/kitten
        fi
    else
        echo "unable to download some programs: $(uname -m) platform support needs to be manually added"
    fi

    # download fira code nerd font
    if ask_user 'Do you really want to download firacode nerd font'; then
        FIRACODE_DIR="$HOME/.local/share/fonts/FiraCode"
        [[ -f "${FIRACODE_DIR}" ]] && rm -rf "$HOME/.local/share/fonts/FiraCode" # rewritten manually: rm -rf is HUGELY dangerous!
        mkdir -p "${FIRACODE_DIR}"
        cd "$(mktemp -d /tmp/firacode-fontXXXXXXXXXXXXXXXXXXX)" || exit 1
        wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/FiraCode.zip" # THIS LINKS NEEDS TO BE MANUALLY UPDATED!
        unzip ./*.zip
        mv ./*.ttf "${FIRACODE_DIR}/"
    fi

} </dev/tty

exit 0
