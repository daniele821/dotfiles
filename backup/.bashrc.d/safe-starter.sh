#!/bin/env bash

for dep in lsd zoxide bat starship img2sixel; do
    command -v "${dep}" &>/dev/null && . "${HOME}/.bashrc.d/init/${dep}.sh"
done
