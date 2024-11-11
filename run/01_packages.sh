#!/bin/env bash

{
    ### upgrade everything ###
    sudo dnf --assumeyes upgrade

    # basic stuff
    sudo dnf --assumeyes remove gnome-boxes gnome-tour gnome-maps yelp rhythmbox simple-scan gnome-logs gnome-contacts gnome-connections mediawriter
    sudo dnf --assumeyes install gnome-tweaks libreoffice-langpack-it mpv
    sudo dnf --assumeyes install zoxide bat ripgrep lsd neovim gcc tldr golang
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
