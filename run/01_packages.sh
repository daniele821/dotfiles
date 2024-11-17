#!/bin/env bash

{
    ### upgrade everything ###
    sudo dnf --assumeyes upgrade

    # basic stuff
    sudo dnf --assumeyes remove kpat kmines kmahjongg
    sudo dnf --assumeyes remove dragon elisa-player neochat
    sudo dnf --assumeyes remove mediawriter akregator khelpcenter
    sudo dnf --assumeyes remove kdebugsettings plasma-welcome kde-connect
    sudo dnf --assumeyes remove kaddressbook kmail kfind
    sudo dnf --assumeyes remove konsole kjournald skanpage
    sudo dnf --assumeyes remove abrt akonadi-server kmouth
    sudo dnf --assumeyes remove krdc krfb krdp
    sudo dnf --assumeyes install libreoffice-langpack-it mpv kitty
    sudo dnf --assumeyes install zoxide bat ripgrep lsd neovim gcc tldr golang direnv htop

    # starship copr
    sudo dnf --assumeyes copr enable atim/starship
    sudo dnf --assumeyes install starship

    # enable rpm-fusion and install multimedia codecs
    sudo dnf --assumeyes install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
    sudo dnf --assumeyes install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
    sudo dnf --assumeyes install ffmpeg --allowerasing

    ### remove unnecessary packages ###
    sudo dnf --assumeyes autoremove

} </dev/tty

exit 0
