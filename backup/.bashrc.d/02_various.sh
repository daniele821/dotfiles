#!/bin/bash

export EDITOR="nvim"
export PYTHONDONTWRITEBYTECODE="true"
export PYTHON_HISTORY="/dev/null"
export NODE_REPL_HISTORY="/dev/null"
export GOPATH="$HOME/.local/share/go"
export RUSTUP_HOME="$HOME/.local/share/rustup"
export CARGO_HOME="$HOME/.local/share/cargo"

function open() {
    case "$#" in
    0) xdg-open "$PWD" ;;
    1) xdg-open "$1" ;;
    *) for file in "$@"; do xdg-open "$file"; done ;;
    esac
}

alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lA'

unset command_not_found_handle
if [[ $- == *i* ]]; then
    for i in - {0..9}; do bind -r "\e$i"; done
    bind -x '"\C-l": clear'
fi
