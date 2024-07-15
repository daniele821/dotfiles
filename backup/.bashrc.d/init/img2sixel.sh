#!/bin/bash

function preview-all() {
    COLS="$(tput cols)"
    ((COLS = COLS * 5))
    for elem in "${@}"; do
        echo "${elem}"
        img2sixel -w $COLS "${elem}"
    done | less -r
}

function preview() {
    for file in "${@}"; do
        preview-all "${file}"
    done
}
