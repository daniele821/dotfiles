#!/bin/env bash
# vim:ft=bash

# utility functions
function ask_user() {
    echo -n "${*} [Y/n] ? "
    read -r answer </dev/tty
    [[ "${answer,,}" == 'y' ]]
}

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
fi </dev/tty

# create ssh keys for github
if ask_user 'Do you really want to create new ssh keys'; then
    for user in daniele821 danix1234; do
        ssh-keygen -t ed25519 -f ~/.ssh/id_"${user}"
    done
fi </dev/tty

# install wireshark
if ask_user 'Do you really want to install wireshark'; then
    sudo apt install wireshark -y
    sudo usermod -aG wireshark "${USER}"
fi

exit 0
