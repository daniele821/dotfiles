#!/bin/env bash

set -e

[[ "$(id -u)" -eq 0 ]] && echo 'do not run this script as root!' && exit 1

sudo bash -c ' set -e

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
dnf --assumeyes remove setroubleshoot-server hplip* toolbox

# install needed programs
dnf --assumeyes install mpv podman distrobox kitten neovim htop
dnf --assumeyes install zoxide bat ripgrep lsd tldr entr jq git gh gcc golang rustup

# enable rpm-fusion and install multimedia codecs
dnf --assumeyes install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
dnf --assumeyes install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
dnf --assumeyes install ffmpeg --allowerasing
dnf --assumeyes install mpv-mpris libheif-freeworld
dnf --assumeyes install mesa-va-drivers-freeworld libavcodec-freeworld # amd
dnf --assumeyes install intel-media-driver                             # intel

# remove unnecessary packages
dnf --assumeyes autoremove

# create personal dirs
if ! [[ -d "/personal" ]]; then
    mkdir -p /personal/{data,repos}
    chown "$SUDO_USER":"$SUDO_USER" /personal/{data,repos}
    echo "created personal directory in /personal"
fi

# install flathub after removing fedora flatpak repos
flatpak remote-delete fedora || true
flatpak remote-delete fedora-testing || true
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# change default firewall zone for extreme safety (use logging to fix broken services)
firewall-cmd --set-default-zone=public
'

# install rust toolchain + rust_analyzer for neovim
if ! command -v cargo &>/dev/null; then
    export RUSTUP_HOME="$HOME/.local/share/rustup"
    export CARGO_HOME="$HOME/.local/share/cargo"
    rustup-init -y
fi

# install Firacode font
if ! [[ -d "$HOME/.local/share/fonts/FiraCode" ]]; then
    mkdir -p "$HOME/.local/share/fonts/FiraCode"
    cd "$HOME/.local/share/fonts/FiraCode"
    wget -O Firacode.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
    unzip Firacode.zip
    rm Firacode.zip LICENSE README.md
fi

exit 0
