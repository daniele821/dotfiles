#!/bin/env bash

{
### upgrade everything ###
sudo dnf --assumeyes upgrade

# basic stuff
sudo dnf --assumeyes install zoxide bat ripgrep lsd neovim gcc libreoffice-langpack-it
sudo dnf --assumeyes copr enable atim/starship
sudo dnf --assumeyes install starship

### remove unnecessary packages ###
sudo dnf --assumeyes autoremove

} < /dev/tty
