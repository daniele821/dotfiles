#!/bin/env bash

{
	# uninstall kde bloat
	sudo dnf --assumeyes remove plasma-discover plasma-welcome plasma-vault plasma-drkonqi kaddressbook kontact kde-connect kgpg ktnef kmines kmahjongg kmail kmousetool kwalletmanager krdc kmouth akregator gnome-abrt dragon elisa-player neochat krdc korganizer krfb khelpcenter skanpage kpat kfind

	# upgrade everything #
	sudo dnf --assumeyes upgrade

	# install utilities
	sudo dnf --assumeyes install neovim gcc fd-find ripgrep zoxide bat lsd tldr libreoffice-langpack-it hyprland wlsunset waybar swaylock wireshark

} </dev/tty
