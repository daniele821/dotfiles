#!/bin/bash

for init in ~/.bashrc.d/init/*; do
    bname="$(basename "$init")"
    name="${bname%%.*}"
    if command -v "$name" &>/dev/null; then
        # shellcheck disable=SC1090
        . "${init}"
    fi
done

function checkhealth() {
    declare MISSING=()
    for init in ~/.bashrc.d/init/*; do
        bname="$(basename "$init")"
        name="${bname%%.*}"
        if ! command -v "$name" &>/dev/null; then
            MISSING+=("$name")
        fi
    done
    [[ "${#MISSING[@]}" -eq "0" ]] && echo "All the needed programs are installed!" && return 0
    echo "The following programs are required for a full bash experience:"
    for prog in "${MISSING[@]}"; do
        echo "- $prog"
    done
    return 1
}
