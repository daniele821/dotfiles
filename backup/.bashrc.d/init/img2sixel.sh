#!/bin/bash

function preview-all() {
    [[ "$#" -gt 25 ]] && echo 'too many images at once' && return 1
    COLS="$(tput cols)"
    ((COLS = COLS * 5))
    for elem in "${@}"; do
        echo "${elem}"
        if [[ "$TERM" =~ kitty ]]; then
            kitten icat "${elem}"
        else
            img2sixel -w $COLS "${elem}"
        fi
    done | less -r
}

function preview() {
    [[ "$#" -gt 25 ]] && echo 'too many images at once' && return 1
    for file in "${@}"; do
        preview-all "${file}"
    done
}
