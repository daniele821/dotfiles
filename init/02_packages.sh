#!/bin/env bash

{
	# uninstall kde bloat
	sudo dnf --assumeyes remove plasma-discover plasma-welcome plasma-vault plasma-drkonqi
	sudo dnf --assumeyes remove kaddressbook kontact kde-connect kgpg ktnef kmines
	sudo dnf --assumeyes remove kmahjongg kmail kmousetool kwalletmanager krdc kmouth
	sudo dnf --assumeyes remove akregator gnome-abrt dragon elisa-player neochat krdc
	sudo dnf --assumeyes remove korganizer krfb khelpcenter skanpage kpat kfind

	### upgrade everything ###
	sudo dnf --assumeyes upgrade

	# install neovim and goodies
	sudo dnf --assumeyes install neovim gcc fd-find ripgrep

	# install some nice terminal cli tools
	sudo dnf --assumeyes install zoxide bat lsd
	sudo dnf --assumeyes copr enable atim/starship
	sudo dnf --assumeyes install starship

	# other
	sudo dnf --assumeyes install libreoffice-langpack-it

	### remove unnecessary packages ###
	sudo dnf --assumeyes autoremove

} </dev/tty
