#!/bin/bash

for init in ~/.bashrc.d/init/*; do
    bname="$(basename "$init")"
    name="${bname%%.*}"
    if command -v "$name" &>/dev/null; then
        # shellcheck disable=SC1090
        . "${init}"
    fi
done
