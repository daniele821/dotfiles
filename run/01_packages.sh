#!/bin/env bash

set -e

{
    ### upgrade everything ###
    sudo dnf --assumeyes upgrade

    # remove bloat
    sudo dnf --assumeyes remove kpat kmines kmahjongg
    sudo dnf --assumeyes remove dragon elisa-player neochat
    sudo dnf --assumeyes remove mediawriter akregator khelpcenter
    sudo dnf --assumeyes remove kdebugsettings plasma-welcome kde-connect
    sudo dnf --assumeyes remove kaddressbook kmail kfind
    sudo dnf --assumeyes remove kjournald skanpage plasma-drkonqi
    sudo dnf --assumeyes remove abrt akonadi-server kmouth
    sudo dnf --assumeyes remove krdc krfb krdp
    sudo dnf --assumeyes remove kolourpaint im-chooser kamoso
    sudo dnf --assumeyes remove kcharselect firewall-config qrca
    sudo dnf --assumeyes remove setroubleshoot-server hplip*

    # install needed programs
    sudo dnf --assumeyes install jq git gh rustup # NECESSARY for following scripts!!!
    sudo dnf --assumeyes install mpv kitten docker neovim
    sudo dnf --assumeyes install zoxide direnv entr bat ripgrep lsd
    sudo dnf --assumeyes install tldr htop gcc golang

    # enable rpm-fusion and install multimedia codecs
    sudo dnf --assumeyes install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
    sudo dnf --assumeyes install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
    sudo dnf --assumeyes install ffmpeg --allowerasing
    sudo dnf --assumeyes install libva-intel-driver intel-media-driver                                       # intel codecs
    sudo dnf --assumeyes install libavcodec-freeworld mesa-va-drivers-freeworld mesa-vdpau-drivers-freeworld # amd codecs
    sudo dnf --assumeyes install libheif-freeworld mpv-mpris                                                 # heic support + mpv mpris protocol

    ### remove unnecessary packages ###
    sudo dnf --assumeyes autoremove

} </dev/tty

exit 0
