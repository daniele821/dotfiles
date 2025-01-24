#!/bin/bash

alias ls='lsd --group-dirs first'
function tree() {
    if timeout 0.2 lsd --group-dirs first --tree "$@" &>/dev/null; then
        lsd --group-dirs first --tree "$@"
    else
        /usr/bin/tree "$@"
    fi
}
