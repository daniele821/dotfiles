#!/bin/bash

function color() {
    echo -e "\e[${1}m${2}\e[m"
}

# update
while ! sudo apt update -y; do
    color "1;31" "update failed"
done
while ! sudo apt upgrade -y; do
    color "1;31" "upgrade failed"
done

# add necessary ppa
while ! sudo apt-add-repository ppa:neovim-ppa/unstable -y; do
    color "1;31" "adding neovim instable ppa failed"
done
while ! sudo apt update -y; do
    color "1;31" "update failed"
done

# install packages 
while ! sudo apt install ripgrep fzf zoxide bat vim neovim unclutter-xfixes neofetch htop ncdu kitty -y; do
    color "1;31" "installation of utilities failed!"
done
while ! sudo apt install gnome-tweaks gnome-shell-extension-manager -y; do
    color "1;31" "installation of apps failed"
done

# clean up
while ! sudo apt purge --auto-remove pop-shop -y; do
    color "1;31" "purge of pop-shop failed"
done
while ! sudo apt update -y; do
    color "1;31" "update failed"
done
while ! sudo apt upgrade -y; do
    color "1;31" "upgrade failed"
done
while ! sudo apt autopurge -y; do
    color "1;31" "autopurge failed"
done

