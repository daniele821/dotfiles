#!/bin/env bash

DEPENDENCIES=("lsd" "zoxide" "bat")
for dep in "${DEPENDENCIES[@]}"; do
	command -v "${dep}" &>/dev/null && . "${HOME}/.bashrc.d/init/${dep}.sh"
done
