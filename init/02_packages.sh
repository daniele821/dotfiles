#!/bin/env bash

{
	# install utilities (mpv or haruna for media playing)
	sudo dnf --assumeyes install neovim gcc fd-find ripgrep zoxide bat lsd tldr libreoffice-langpack-it wireshark mpv hyprland wlsunset waybar swaylock brightnessctl

	# uninstall bloat
	sudo dnf --assumeyes remove plasma-discover plasma-welcome plasma-vault plasma-drkonqi kaddressbook kontact kde-connect kgpg ktnef kmines kmahjongg kmail kmousetool kwalletmanager krdc kmouth akregator gnome-abrt dragon elisa-player neochat krdc korganizer krfb khelpcenter skanpage kpat kfind mediawriter kamoso kcharselect kolourpaint spectacle nwg-panel libreport kitty

	# enable rpmfusion repos
	sudo dnf --assumeyes install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-40.noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-40.noarch.rpm

	# install ffmpeg (fixes bluetooth stuttering)
	sudo dnf --assumeyes --allowerasing install ffmpeg

	# upgrade everything #
	sudo dnf --assumeyes upgrade

} </dev/tty
