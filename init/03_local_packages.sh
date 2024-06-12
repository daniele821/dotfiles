#!/bin/env bash

{
	# install starship manually
	INSTALL_DIR="$(mktemp -d)" || exit 1
	cd "${INSTALL_DIR}" || exit
	wget https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-gnu.tar.gz || exit 1
	tar xzf starship-x86_64-unknown-linux-gnu.tar.gz || exit 1
	sudo mv ./starship /usr/local/bin/starship || exit 1
	rm starship-x86_64-unknown-linux-gnu.tar.gz || exit 1
	rmdir "${INSTALL_DIR}" || exit 1

} </dev/tty
