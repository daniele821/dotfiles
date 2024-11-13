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

    # gsettings configurations (done here instead of installing gnome-tweaks)
    if ask_user 'Do you really want to tweaks few gsettings preferences'; then
        echo 'adding minimize and maximize buttons'
        gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
        echo 'setting center-new-windows to true'
        gsettings set org.gnome.mutter center-new-windows true
        echo 'setting attach-modal to false'
        gsettings set org.gnome.mutter attach-modal-dialogs false
    fi

} </dev/tty

exit 0
