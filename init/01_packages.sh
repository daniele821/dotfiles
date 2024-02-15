#!/bin/bash

sudo zypper install --no-confirm hyprland waybar ripgrep kitty neovim vim git lsd starship NetworkManager-applet bat nodejs-common zoxide fzf ShellCheck libnotify gcc libqt5-qtwayland qt6-wayland
sudo zypper remove --no-confirm -u gnome-software gnome-shell-classic opensuse-welcome
sudo zypper remove --no-confirm sway icewm
sudo zypper addlock gnome-software gnome-shell-classic sway icewm opensuse-welcome
