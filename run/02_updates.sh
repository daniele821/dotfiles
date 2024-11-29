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
            wget https://github.com/kovidgoyal/kitty/releases/download/v0.37.0/kitten-linux-386 -O "${TMP_FILE}"
            chmod +x "${TMP_FILE}"
            sudo mv "${TMP_FILE}" /usr/local/bin/kitten
        fi
    fi

} </dev/tty

exit 0
