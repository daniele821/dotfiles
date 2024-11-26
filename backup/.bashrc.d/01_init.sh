#!/bin/bash

for init in "$HOME/.bashrc.d/init/"*; do
    bname="$(basename "$init")"
    name="${bname%%.*}"
    if command -v "$name" &>/dev/null; then
        # shellcheck disable=SC1090
        . "${init}"
    else
        echo "$name is not installed"
    fi
done
