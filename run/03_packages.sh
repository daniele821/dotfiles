#!/bin/env bash

# speed up installations
powerprofilesctl set performance

{
    # upgrade everything
    sudo dnf --assumeyes upgrade

    # add needed copr
    sudo dnf --assumeyes copr enable atim/starship
    sudo dnf --assumeyes install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
    sudo dnf --assumeyes install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

    # codecs and licenses programs fedora doesn't install out of the box
    sudo dnf --assumeyes install --allowerasing ffmpeg
    sudo dnf --assumeyes install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
    sudo dnf --assumeyes install lame\* --exclude=lame-devel
    sudo dnf --assumeyes group upgrade --with-optional Multimedia

    # install utilities
    sudo dnf --assumeyes install neovim gcc fd-find ripgrep
    sudo dnf --assumeyes install zoxide bat lsd tldr starship htop direnv
    sudo dnf --assumeyes install libreoffice-langpack-it haruna wireshark
    sudo dnf --assumeyes install jq hyprland gammastep waybar hyprlock brightnessctl

    # safe uninstall bloat
    sudo dnf --assumeyes remove nwg-panel kitty
    sudo dnf --assumeyes remove kaddressbook kontact kde-connect kamoso kcharselect kmines kmahjongg kmail kfind
    sudo dnf --assumeyes remove krdc krfb kgpg khelpcenter kmousetool korganizer kpat kolourpaint kmouth kwalletmanager5
    sudo dnf --assumeyes remove krdp kjournald kdebugsettings filelight firewall-config kde-partitionmanager
    sudo dnf --assumeyes remove plasma-drkonqi plasma-discover plasma-welcome plasma-vault plasma-systemmonitor
    sudo dnf --assumeyes remove mediawriter spectacle akregator dragon elisa-player neochat im-chooser libreport skanpage gnome-abrt

    # cleanup
    sudo dnf --assumeyes autoremove

} </dev/tty

# disable speed up
powerprofilesctl set power-saver

exit 0
