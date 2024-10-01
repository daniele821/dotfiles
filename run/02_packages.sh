#!/bin/env bash
# vim:ft=bash

{
    sudo apt update -y
    sudo apt upgrade -y

    # cli essentials
    sudo apt install bat zoxide fzf htop -y

    # neovim and dependecies
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    sudo apt install neovim wl-clipboard ripgrep -y
    # TODO: nodejs, npm for neovim

    # manually install starship
    curl -sS https://starship.rs/install.sh | sh
} </dev/tty

exit 0
