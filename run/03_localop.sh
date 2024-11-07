#!/bin/env bash

# utility functions
function ask_user() {
    echo -en "\x1b[1m${*}? \x1b[m"
    read -r answer </dev/tty
    [[ "${answer,,}" == 'y' ]]
}

{
    # mandatory init operations
    if ! [[ -d "/personal" ]]; then # create personal dirs
        sudo mkdir -p /personal/{data,repos} || exit 1
        sudo chown "${USER}":"${USER}" /personal/{data,repos}
        echo "created personal directory in /personal"
    fi

    # restore backup files
    if ask_user 'Do you want to restore all backup files'; then
        SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
        SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"
        "${SCRIPT_DIR}/../autosaver" restoreall
    fi

    # create ssh keys for github
    if ask_user 'Do you really want to create new ssh keys'; then
        for user in daniele821 danix1234; do
            ssh-keygen -t ed25519 -f ~/.ssh/id_"${user}"
        done
    fi

    # install/update starship
    if ask_user "Do you really want to install starship"; then
        curl -sS https://starship.rs/install.sh | sh
    fi

    # install appimage imagemagick (no app icon)
    if ask_user "Do you really want to install imagemagick, without app icon"; then
        TMPDIR="$(mktemp -d)"
        wget -O "${TMPDIR}/magick" https://imagemagick.org/archive/binaries/magick
        chmod +x "${TMPDIR}/magick"
        sudo mv "${TMPDIR}/magick" "/usr/local/bin/magick"
        rmdir "${TMPDIR}"
    fi

} </dev/tty

exit 0
