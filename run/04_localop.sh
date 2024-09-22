#!/bin/env bash

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

# autolaunch hyprland
if ! grep Hyprland "$HOME/.bash_profile" -q && ask_user 'Do you really want to autolaunch hyprland'; then
    echo '[[ "$(tty)" == "/dev/tty1" ]] && exec Hyprland' >>"$HOME/.bash_profile"
fi </dev/tty

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

# disable login manager
if ask_user 'Do you want to disable sddm'; then
    sudo systemctl disable sddm.service
fi </dev/tty

# disable bluetooth
if ask_user 'Do you want to disable bluetooth'; then
    sudo systemctl disable bluetooth
fi </dev/tty

# add user to wireshark group to enable wireshark
if ask_user 'Do you want to enable wireshark for current user'; then
    sudo usermod -aG wireshark "$USER"
fi </dev/tty

exit 0
