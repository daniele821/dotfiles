#!/bin/env bash

{
### upgrade everything ###
sudo dnf update

# basic stuff
sudo dnf remove gnome-classic-session gnome-boxes gnome-software cheese gnome-tour
sudo dnf install zoxide bat ripgrep gnome-tweaks lsd neovim gcc htop
curl -sS https://starship.rs/install.sh | sh

# hyprland stuff
sudo dnf install waybar hyprland blueman network-manager-applet brightnessctl pamixer polkit-gnome
sudo dnf remove nwg-panel
sudo dnf copr enable erikreider/SwayNotificationCenter && sudo dnf install SwayNotificationCenter

sudo dnf update
sudo dnf autoremove

# enable rpm-fusion and install multimedia codecs
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-39.noarch.rpm 
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-39.noarch.rpm  
sudo dnf install gstreamer1-plugins-bad-* gstreamer1-plugins-good-* gstreamer1-plugins-base gstreamer1-plugin-openh264 gstreamer1-plugin-libav --exclude=gstreamer1-plugins-bad-free-devel  
sudo dnf install lame* --exclude=lame-devel  
sudo dnf group upgrade --with-optional --allowerasing Multimedia # WARNING: avoid running twice, as it pollutes dnf history

### remove unnecessary packages ###
sudo dnf autoremove

} < /dev/tty
