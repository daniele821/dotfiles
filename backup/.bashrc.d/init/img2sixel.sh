#!/bin/bash

function preview() {
    if [[ "$TERM" =~ kitty ]]; then
        kitten icat "${1}"
    else
        COLS="$(tput cols)"
        ((COLS = COLS * 8))
        img2sixel -w "$COLS" "${1}"
    fi | less -r
}
