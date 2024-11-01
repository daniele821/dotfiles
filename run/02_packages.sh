#!/bin/env bash
# vim:ft=bash

{
    sudo apt update -y
    sudo apt upgrade -y

    # neovim and dependecies
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    sudo apt install neovim wl-clipboard ripgrep nodejs npm python3.12-venv golang -y

    # apps
    sudo apt install kitty libreoffice gnome-calculator -y

    # cli essentials
    sudo apt install lsd tree bat zoxide fzf htop direnv -y

    # replace bad gnome apps
    sudo apt purge --auto-remove totem eog -y
    sudo apt install mpv mpv-mpris loupe -y

    # manually install starship
    curl -sS https://starship.rs/install.sh | sh

} </dev/tty

exit 0
