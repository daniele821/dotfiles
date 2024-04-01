#!/bin/env bash

{
### upgrade everything ###
sudo dnf upgrade

# basic stuff
sudo dnf remove gnome-classic-session gnome-boxes gnome-software cheese gnome-tour gnome-maps yelp rhythmbox simple-scan 
sudo dnf install zoxide bat ripgrep gnome-tweaks lsd neovim gcc
curl -sS https://starship.rs/install.sh | sh

### remove unnecessary packages ###
sudo dnf autoremove

} < /dev/tty
