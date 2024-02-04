#!/bin/bash

set -e

sudo zypper install --no-confirm hyprland waybar ripgrep kitty neovim vim git lsd starship NetworkManager-applet blueman bat nodejs-common zoxide fzf ShellCheck libnotify gcc
sudo zypper remove --no-confirm -u gnome-software gnome-shell-classic
sudo zypper remove --no-confirm sway icewm
sudo zypper addlock gnome-software gnome-shell-classic sway icewm
