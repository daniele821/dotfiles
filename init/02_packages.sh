#!/bin/env bash

{
    # add needed copr
    sudo dnf --assumeyes copr enable atim/starship

    # install utilities (mpv or haruna for media playing)
    sudo dnf --assumeyes install neovim gcc fd-find ripgrep zoxide bat lsd tldr starship htop libreoffice-langpack-it wireshark mpv libsixel-utils jq hyprland gammastep waybar hyprlock brightnessctl

    # uninstall bloat
    sudo dnf --assumeyes remove plasma-discover plasma-welcome plasma-vault plasma-drkonqi kaddressbook kontact kde-connect kgpg ktnef kmines kmahjongg kmail kmousetool krdc kmouth akregator gnome-abrt dragon elisa-player neochat krdc korganizer krfb khelpcenter skanpage kpat kfind mediawriter kamoso kcharselect kolourpaint spectacle nwg-panel libreport kitty

    # upgrade everything #
    sudo dnf --assumeyes upgrade

} </dev/tty
