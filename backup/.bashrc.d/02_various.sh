#!/bin/bash

export EDITOR="nvim"
export PYTHONDONTWRITEBYTECODE="true"
export PYTHON_HISTORY="/dev/null"
export NODE_REPL_HISTORY="/dev/null"
export GOPATH="$HOME/.local/share/go"
export RUSTUP_HOME="$HOME/.local/share/rustup"
export CARGO_HOME="$HOME/.local/share/cargo"

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

alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lA'
alias time='/usr/bin/time -f "time elapsed: %es"'

function edit(){
    BG_CONTAINER="$(podman ps --filter "ancestor=ghcr.io/daniele821/neovim:latest" -q)"
    if [[ -z "$BG_CONTAINER" ]]; then
        BG_CONTAINER="$(podman run --detach-keys "" -d --init -e "TZ=$(timedatectl show --property=Timezone --value)" "ghcr.io/daniele821/neovim:latest" sleep infinity)"
    fi
    podman exec -it -w /root "$BG_CONTAINER" bash -il
}

unset command_not_found_handle
if [[ $- == *i* ]]; then
    for i in - {0..9}; do bind -r "\e$i"; done
    bind -x '"\C-l": clear'
fi
