#!/bin/env bash

set -e

# replace fedora repos with flathub
sudo flatpak remote-delete fedora || true
sudo flatpak remote-delete fedora-testing || true
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# install flatpaks
flatpak install flathub com.github.wwmm.easyeffects -y
