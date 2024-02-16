#!/bin/bash

sudo zypper install --no-confirm hyprland waybar ripgrep kitty neovim vim git lsd starship NetworkManager-applet bat nodejs-common zoxide fzf ShellCheck libnotify gcc libqt5-qtwayland qt6-wayland
sudo zypper remove --no-confirm -u gnome-software gnome-shell-classic opensuse-welcome
sudo zypper remove --no-confirm sway icewm
sudo zypper addlock gnome-software gnome-shell-classic sway icewm opensuse-welcome

# add packam repo for multimedia codecs and stuff like obs
sudo zypper addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/' packman
sudo zypper dist-upgrade --from packman --allow-vendor-change
sudo zypper install obs-studio
