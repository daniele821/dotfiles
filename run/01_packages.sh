#!/bin/env bash

{
    # required these scripts
    sudo apt install curl gh -y

    # install neovim latest
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt install neovim -y

    # todo:
    # sudo apt install zoxide direnv entr bat ripgrep lsd tldr htop
    #
    # flatpak
} </dev/tty

exit 0
