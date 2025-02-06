#!/bin/bash

function __tree__() {
    timeout 0.2 lsd --group-dirs first --tree "$@" &>/dev/null
    if [[ $? -ne "124" ]]; then
        lsd --group-dirs first --tree "$@"
    else
        /usr/bin/tree "$@"
    fi 2>/dev/null
}

alias ls='lsd --group-dirs first'
alias tree='__tree__'
