#!/bin/env bash

{
    sudo apt update -y
    sudo apt upgrade -y

    # neovim and dependecies
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    sudo apt install neovim xsel wl-clipboard ripgrep nodejs npm python3.12-venv golang -y

    # cli essentials
    sudo apt install lsd bat zoxide fzf htop direnv tldr -y

    # install apps & tools and uninstall bad apps
    sudo apt purge celluloid -y
    sudo apt install kitty ffmpeg power-profiles-daemon mpv mpv-mpris -y

} </dev/tty

exit 0
