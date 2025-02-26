#!/bin/env bash

{
    # purge bloat
    sudo apt purge --auto-remove plasma-discover* fcitx5* info -y # GUI apps
    sudo apt purge --auto-remove khelpcenter kcharselect -y       # GUI apps
    sudo apt purge --auto-remove apport im-config ksystemlog -y   # GUI apps

    # add goodies
    sudo apt install curl gh -y                                           # requires to run these scripts
    sudo apt install tree bat zoxide entr direnv ripgrep -y               # cli tools
    sudo apt install lsd tldr htop wl-clipboard fzf -y                    # cli tools
    sudo apt install build-essential golang nodejs npm python3.12-venv -y # for programming
    sudo apt install okular libreoffice-{calc,writer,l10n-it} -y          # GUI apps
    sudo apt install mpv mpv-mpris plasma-discover -y                     # GUI apps

    # install various ppa & cleanup
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    sudo sudo add-apt-repository ppa:mozillateam/ppa -y
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt install neovim firefox -y
    sudo apt autopurge --auto-remove -y

} </dev/tty

exit 0
