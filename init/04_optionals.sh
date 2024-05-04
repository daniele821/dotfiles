#!/bin/env bash

function ask_user(){
    echo -n "${*} [Y/n] ? "
    read -r answer </dev/tty
    [[ "${answer,,}" == 'y' ]]
}

# restore backup files
if ask_user 'Do you want to restore all backup files'; then
    SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
    SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"
    "${SCRIPT_DIR}/../autosaver.sh" restore
fi </dev/tty

# create ssh keys for github
if ask_user 'Do you really want to create new ssh keys?'; then
    USERS=(daniele821 danix1234)
    for user in "${USERS[@]}"; do
        ssh-keygen -t ed25519 -f ~/.ssh/id_"${user}" 
    done 
fi </dev/tty

# install extension manager with flatpak
if ask_user 'Do you really want to install extension manager app?'; then
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install flathub com.mattjakeman.ExtensionManager -y
fi </dev/tty

# install wireshark
if ask_user 'Do you want to install wireshark'; then
    sudo dnf --assumeyes install wireshark
    sudo usermod -a -G wireshark "${USER}"
fi </dev/tty
