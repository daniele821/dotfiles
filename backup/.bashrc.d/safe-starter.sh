#!/bin/env bash

DEPENDENCIES=("lsd" "zoxide" "starship" "bat")
for dep in "${DEPENDENCIES[@]}"; do
	command -v "${dep}" &>/dev/null && . "${HOME}/.bashrc.d/init/${dep}.sh"
done
