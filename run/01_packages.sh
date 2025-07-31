#!/bin/env bash

set -e

# early exit if init operations were already run
[[ -f ~/.local/share/.script_runned_packages ]] && exit 0
touch ~/.local/share/.script_runned_packages

# ask for sudo only once
sudo bash -c ' set -e

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
dnf --assumeyes remove setroubleshoot* hplip* toolbox

# install needed programs
dnf --assumeyes install mpv podman kitten neovim htop
dnf --assumeyes install zoxide bat ripgrep lsd jq git

# enable rpm-fusion and install multimedia codecs
dnf --assumeyes install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
dnf --assumeyes install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
dnf --assumeyes install ffmpeg --allowerasing
dnf --assumeyes install mpv-mpris libheif-freeworld
dnf --assumeyes install mesa-va-drivers-freeworld libavcodec-freeworld # amd
dnf --assumeyes install intel-media-driver                             # intel

# update and cleanup
dnf --assumeyes upgrade
dnf --assumeyes autoremove
'
