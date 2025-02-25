#!/bin/env bash

{
    # purge bloat
    sudo apt purge --auto-remove -y

    # add goodies
    sudo apt install curl gh -y                                           # requires to run these scripts
    sudo apt install tree bat zoxide entr direnv ripgrep lsd tldr htop -y # cli tools
    sudo apt install build-essential golang nodejs npm python3.12-venv -y # for programming

    # install various ppa & cleanup
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    sudo sudo add-apt-repository ppa:mozillateam/ppa -y
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt install neovim firefox -y
    sudo apt autopurge --auto-remove -y

} </dev/tty

exit 0
