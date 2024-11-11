#!/bin/env bash

{
    ### upgrade everything ###
    sudo dnf --assumeyes upgrade

    # basic stuff
    sudo dnf --assumeyes remove gnome-boxes gnome-tour gnome-maps gnome-software gnome-logs gnome-contacts gnome-connections
    sudo dnf --assumeyes remove yelp rhythmbox simple-scan mediawriter
    sudo dnf --assumeyes install gnome-tweaks libreoffice-langpack-it
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
