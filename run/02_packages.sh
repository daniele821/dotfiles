#!/bin/env bash

{
    sudo apt update -y
    sudo apt full-upgrade -y

    # neovim and dependecies
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    sudo apt install neovim wl-clipboard ripgrep nodejs npm python3.12-venv golang -y

    # cli essentials
    sudo apt install lsd tree bat zoxide fzf htop direnv tldr -y

    # install apps & tools and uninstall bad apps
    sudo apt purge totem thunderbird -y
    sudo apt install kitty ffmpeg mpv mpv-mpris libreoffice -y

    # cleanup
    sudo apt autopurge -y
} </dev/tty

exit 0
