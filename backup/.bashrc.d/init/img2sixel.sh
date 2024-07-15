#!/bin/bash

function preview() {
    COLS="$(tput cols)"
    ((COLS = COLS * 5))
    for elem in "${@}"; do
        echo "${elem}"
        img2sixel -w $COLS "${elem}"
    done | less -r
}
