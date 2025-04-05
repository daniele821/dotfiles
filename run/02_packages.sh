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
    sudo dnf --assumeyes remove kjournald skanpage plasma-drkonqi
    sudo dnf --assumeyes remove abrt akonadi-server kmouth
    sudo dnf --assumeyes remove krdc krfb krdp
    # sudo dnf --assumeyes remove plasma-discover PackageKit PackageKit-glib
    sudo dnf --assumeyes remove firewall-config kolourpaint im-chooser
    sudo dnf --assumeyes remove kcharselect kamoso
    sudo dnf --assumeyes install mpv kitten docker
    sudo dnf --assumeyes install zoxide direnv entr bat ripgrep lsd neovim
    sudo dnf --assumeyes install tldr htop gh gcc git golang rustup

    # enable rpm-fusion and install multimedia codecs
    sudo dnf --assumeyes install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
    sudo dnf --assumeyes install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
    sudo dnf --assumeyes install ffmpeg --allowerasing
    sudo dnf --assumeyes install libva-intel-driver intel-media-driver                                       # intel
    sudo dnf --assumeyes install libavcodec-freeworld mesa-va-drivers-freeworld mesa-vdpau-drivers-freeworld # amd
    sudo dnf --assumeyes install mpv-mpris

    ### remove unnecessary packages ###
    sudo dnf --assumeyes autoremove

} </dev/tty

exit 0
