#!/bin/env bash

{
    # purge bloat
    sudo apt purge --auto-remove fcitx5* info khelpcenter kcharselect -y # GUI apps
    sudo apt purge --auto-remove apport im-config ksystemlog kate -y     # GUI apps
    sudo apt purge --auto-remove plasma-discover-backend-snap -y         # software managers

    # add goodies
    sudo apt install curl gh -y                                                  # requires to run these scripts
    sudo apt install tree bat zoxide entr direnv ripgrep -y                      # cli tools
    sudo apt install lsd tldr htop wl-clipboard fzf -y                           # cli tools
    sudo apt install build-essential golang nodejs npm python3.12-venv rustup -y # for programming
    sudo apt install okular libreoffice-{calc,writer,l10n-it} mpv mpv-mpris -y   # GUI apps
    sudo apt install flatpak plasma-discover-backend-flatpak -y                  # software managers

    # add flathub to flatpak + various flatpak installs
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak install --assumeyes flathub org.mozilla.firefox

    # install various ppa & cleanup
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt install neovim -y
    sudo apt autopurge --auto-remove -y

} </dev/tty

exit 0
