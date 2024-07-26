#!/bin/env bash

# speed up installations
powerprofilesctl set performance

{
    # add needed copr
    sudo dnf --assumeyes copr enable atim/starship
    sudo dnf -y install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
    sudo dnf -y install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

    # install utilities
    sudo dnf --assumeyes install --allowerasing ffmpeg
    sudo dnf --assumeyes install neovim gcc fd-find ripgrep
    sudo dnf --assumeyes install zoxide bat lsd tldr starship htop direnv
    sudo dnf --assumeyes install libreoffice-langpack-it wireshark mpv libsixel-utils
    sudo dnf --assumeyes install jq hyprland gammastep waybar hyprlock brightnessctl

    # upgrade everything
    sudo dnf --assumeyes upgrade

    # safe uninstall bloat
    sudo dnf --assumeyes remove kitty nwg-panel
    sudo dnf --assumeyes remove kaddressbook kontact kde-connect kamoso kcharselect kmines kmahjongg kmail kfind khelpcenter kmousetool korganizer kpat kolourpaint kmouth
    sudo dnf --assumeyes remove krdc krfb kgpg
    sudo dnf --assumeyes remove plasma-drkonqi plasma-discover plasma-welcome plasma-vault
    sudo dnf --assumeyes remove mediawriter spectacle akregator dragon elisa-player neochat im-chooser libreport skanpage gnome-abrt

    # cleanup
    sudo dnf --assumeyes autoremove

} </dev/tty

# disable speed up
powerprofilesctl set balanced

exit 0
