#!/bin/env bash

{
### upgrade everything ###
sudo dnf --assumeyes upgrade

# install neovim and goodies
sudo dnf --assumeyes install neovim gcc fd-find ripgrep 
# install some nice terminal cli tools
sudo dnf --assumeyes install zoxide bat lsd 
sudo dnf --assumeyes copr enable atim/starship
sudo dnf --assumeyes install starship
# other
sudo dnf --assumeyes install libreoffice-langpack-it 

### remove unnecessary packages ###
sudo dnf --assumeyes autoremove

} < /dev/tty
