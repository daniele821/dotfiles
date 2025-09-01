#!/bin/bash

export EDITOR="nvim"
export PYTHONDONTWRITEBYTECODE="true"
export PYTHON_HISTORY="/dev/null"
export NODE_REPL_HISTORY="/dev/null"
export GOPATH="$HOME/.local/share/go"
export RUSTUP_HOME="$HOME/.local/share/rustup"
export CARGO_HOME="$HOME/.local/share/cargo"
export DIRS_FILE="$HOME/.local/share/fast_dir_switch"

function open() {
    local file=
    case "$#" in
    0) xdg-open "$PWD" ;;
    1) xdg-open "$1" ;;
    *) for file in "$@"; do xdg-open "$file"; done ;;
    esac
}
function run() {
    (: && nohup "$@" &>/dev/null &)
}

function dir-add(){
    mkdir -p "$(dirname "$DIRS_FILE")" && touch "$DIRS_FILE"
    echo "$PWD" >> "$DIRS_FILE"
    dirs="$(sort -u "$DIRS_FILE")"
    echo "$dirs" > "$DIRS_FILE"
}
function dir-rm(){
    [[ ! -s "$DIRS_FILE" ]] && return 0
    mkdir -p "$(dirname "$DIRS_FILE")" && touch "$DIRS_FILE"
    cat "$DIRS_FILE" | fzf --height 40% --border=sharp --reverse --multi | while read -r line; do
        lines="$(grep -vFx "$line" "$DIRS_FILE")"
        echo -n "$lines" > "$DIRS_FILE"
    done
}
function dir-cd(){
    [[ ! -s "$DIRS_FILE" ]] && return 0
    mkdir -p "$(dirname "$DIRS_FILE")" && touch "$DIRS_FILE"
    cd "$(cat "$DIRS_FILE" | fzf --height 40% --border=sharp --reverse)"
}

alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lA'
alias time='/usr/bin/time -f "time elapsed: %es"'

unset command_not_found_handle
if [[ $- == *i* ]]; then
    for i in - {0..9}; do bind -r "\e$i"; done
    bind -x '"\C-l": clear'
fi
