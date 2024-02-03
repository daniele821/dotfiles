#!/bin/bash

set -e

echo -e "\e[1;33mWARNING:\e[m automatic installation is unstable (thanks packagekitd). Do installation manually, using these init script as a base\e[m" && exit 1

sudo zypper install --no-confirm hyprland waybar ripgrep kitty neovim vim git lsd starship NetworkManager-applet blueman bat nodejs-common zoxide fzf ShellCheck libnotify gcc
sudo zypper remove --no-confirm -u gnome-software gnome-shell-classic
sudo zypper remove --no-confirm sway icewm
