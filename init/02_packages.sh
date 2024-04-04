#!/bin/env bash

{
### upgrade everything ###
sudo dnf --assumeyes upgrade

# basic stuff
sudo dnf --assumeyes remove gnome-classic-session gnome-boxes gnome-software cheese gnome-tour gnome-maps yelp rhythmbox simple-scan 
sudo dnf --assumeyes install zoxide bat ripgrep gnome-tweaks lsd neovim gcc
sudo dnf --assumeyes copr enable atim/starship
sudo dnf --assumeyes install starship

# enable rpm-fusion and install multimedia codecs
sudo dnf --assumeyes install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-39.noarch.rpm 
sudo dnf --assumeyes install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-39.noarch.rpm  
sudo dnf --assumeyes install gstreamer1-plugins-bad-* gstreamer1-plugins-good-* gstreamer1-plugins-base gstreamer1-plugin-openh264 gstreamer1-plugin-libav --exclude=gstreamer1-plugins-bad-free-devel  
sudo dnf --assumeyes install lame* --exclude=lame-devel  
sudo dnf --assumeyes group upgrade --with-optional --allowerasing Multimedia # WARNING: avoid running twice, as it pollutes dnf history

### remove unnecessary packages ###
sudo dnf --assumeyes autoremove

} < /dev/tty
