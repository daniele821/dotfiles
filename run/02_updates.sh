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

    # assure platform is x86, since binaries downloaded are specific for that platform
    [[ "$(uname -m)" != "x86_64" ]] && echo "platform '$(uname -m)' not supported!" && exit 0

    # download kitten for terminal image drawing protocol
    if ask_user 'Do you really want to download kitten locally'; then
        TMP_FILE="$(mktemp)"
        wget https://github.com/kovidgoyal/kitty/releases/download/v0.37.0/kitten-linux-386 -O "${TMP_FILE}"
        chmod +x "${TMP_FILE}"
        sudo mv "${TMP_FILE}" /usr/local/bin/kitten
    fi

} </dev/tty

exit 0
