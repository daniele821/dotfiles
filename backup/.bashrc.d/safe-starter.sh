#!/bin/env bash

for dep in lsd zoxide bat; do
	command -v "${dep}" &>/dev/null && . "${HOME}/.bashrc.d/init/${dep}.sh"
done
