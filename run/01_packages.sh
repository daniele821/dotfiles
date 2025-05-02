#!/bin/env bash

set -e

sudo bash -c '
{
    set -e

    # upgrade everything
    dnf --assumeyes upgrade

    # remove bloat
    dnf --assumeyes remove kpat kmines kmahjongg
    dnf --assumeyes remove dragon elisa-player neochat
    dnf --assumeyes remove mediawriter akregator khelpcenter
    dnf --assumeyes remove kdebugsettings plasma-welcome kde-connect
    dnf --assumeyes remove kaddressbook kmail kfind
    dnf --assumeyes remove kjournald skanpage plasma-drkonqi
    dnf --assumeyes remove abrt akonadi-server kmouth
    dnf --assumeyes remove krdc krfb krdp
    dnf --assumeyes remove kolourpaint im-chooser kamoso
    dnf --assumeyes remove kcharselect firewall-config qrca
    dnf --assumeyes remove setroubleshoot-server hplip* kde-partitionmanager
    dnf --assumeyes remove flatpak

    # install needed programs
    dnf --assumeyes install git gh # NECESSARY for following scripts!!!
    dnf --assumeyes install mpv docker kitten neovim htop wireshark
    dnf --assumeyes install zoxide bat ripgrep lsd tldr gcc jq

    # enable rpm-fusion and install multimedia codecs
    dnf --assumeyes install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
    dnf --assumeyes install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
    dnf --assumeyes install ffmpeg --allowerasing
    dnf --assumeyes install libva-intel-driver intel-media-driver                                       # intel codecs
    dnf --assumeyes install libavcodec-freeworld mesa-va-drivers-freeworld mesa-vdpau-drivers-freeworld # amd codecs
    dnf --assumeyes install mpv-mpris libheif-freeworld

    # remove unnecessary packages
    dnf --assumeyes autoremove

} </dev/tty '

exit 0
