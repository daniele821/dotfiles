#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"

"${SCRIPT_DIR}"/autosaver.sh restore

sudo mkdir /personal
sudo chown "$USER":"$USER" /personal
mkdir /personal/repos

cd ~/.local/share/fonts/FiraCode && unzip FiraCode.zip
cd ~/.local/share/themes/ && unzip gtk-master.zip && mv gtk-master Dracula

# this and GTK_THEME=Dracula (already defined in hyprland conf file) kinda work in theming everything
gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
gsettings set org.gnome.desktop.wm.preferences theme "Dracula"

