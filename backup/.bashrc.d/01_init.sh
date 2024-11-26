#!/bin/bash

export MISSING_PROGRAMS=()
for init in ~/.bashrc.d/init/*; do
    bname="$(basename "$init")"
    name="${bname%%.*}"
    if command -v "$name" &>/dev/null; then
        # shellcheck disable=SC1090
        . "${init}"
    else
        export MISSING_PROGRAMS+=("${name}")
    fi
done
declare -r MISSING_PROGRAMS

function checkhealth() {
    [[ "${#MISSING_PROGRAMS[@]}" -eq 0 ]] && return 0
    echo "The following programs are required for a full bash experience:"
    for i in "${MISSING_PROGRAMS[@]}"; do
        echo "- $i"
    done
}
