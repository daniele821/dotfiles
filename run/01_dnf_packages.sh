#!/bin/env bash

set -e

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
sudo dnf --assumeyes remove setroubleshoot* hplip* toolbox

# install needed programs
sudo dnf --assumeyes install mpv podman kitten neovim htop
sudo dnf --assumeyes install zoxide bat ripgrep lsd jq git

# enable rpm-fusion and install multimedia codecs
sudo dnf --assumeyes install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
sudo dnf --assumeyes install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
sudo dnf --assumeyes install ffmpeg --allowerasing
sudo dnf --assumeyes install mpv-mpris libheif-freeworld
sudo dnf --assumeyes install mesa-va-drivers-freeworld libavcodec-freeworld # amd
sudo dnf --assumeyes install intel-media-driver                             # intel

# update and cleanup
sudo dnf --assumeyes upgrade
sudo dnf --assumeyes autoremove
