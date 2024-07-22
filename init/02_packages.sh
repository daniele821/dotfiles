#!/bin/env bash

{
    # add needed copr
    sudo dnf --assumeyes copr enable atim/starship

    # install utilities (mpv or haruna for media playing)
    sudo dnf --assumeyes install neovim gcc fd-find ripgrep zoxide bat lsd tldr starship htop libreoffice-langpack-it wireshark mpv libsixel-utils jq hyprland gammastep waybar hyprlock brightnessctl

    # upgrade everything #
    sudo dnf --assumeyes upgrade

    # safe uninstall bloat
    sudo dnf --assumeyes remove kaddressbook kontact kde-connect kgpg kitty nwg-panel mediawriter kamoso kcharselect  spectacle kmines kmahjongg kmail akregator dragon elisa-player neochat im-chooser kfind khelpcenter kmousetool libreport skanpage gnome-abrt plasma-drkonqi korganizer kpat kolourpaint kmouth plasma-discover plasma-welcome krdc krfb plasma-vault

} </dev/tty


