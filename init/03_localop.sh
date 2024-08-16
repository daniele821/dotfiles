#!/bin/env bash

# utility functions
function ask_user() {
    echo -n "${*} [Y/n] ? "
    read -r answer </dev/tty
    [[ "${answer,,}" == 'y' ]]
}

# mandatory init operations
if ! [[ -d "/personal" ]]; then
    sudo mkdir -p /personal/{data,repos} || exit 1
    sudo chown "${USER}":"${USER}" /personal/{data,repos}
    echo "created personal directory in /personal"
fi
if ! [[ -f "/usr/local/bin/xdg-terminal-exec" ]]; then
    echo -n "setting default terminal to "
    echo 'kitty' | sudo tee /usr/local/bin/xdg-terminal-exec
    sudo chmod +x /usr/local/bin/xdg-terminal-exec

fi

# restore backup files
if ask_user 'Do you want to restore all backup files'; then
    SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
    SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"
    "${SCRIPT_DIR}/../autosaver.sh" restore
fi </dev/tty

# create ssh keys for github
if ask_user 'Do you really want to create new ssh keys'; then
    USERS=(daniele821 danix1234)
    for user in "${USERS[@]}"; do
        ssh-keygen -t ed25519 -f ~/.ssh/id_"${user}"
    done
fi </dev/tty

# enable wireshark for current user
if ask_user 'Do you really want to enable wireshark'; then
    sudo usermod -a -G wireshark "${USER}"
fi </dev/tty

# disable login manager
if ask_user 'Do you want to disable sddm'; then
    sudo systemctl disable sddm.service
fi </dev/tty

exit 0
