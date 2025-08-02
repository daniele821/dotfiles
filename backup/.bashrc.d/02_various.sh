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
    case "$1" in
        up|update|upgrade) podman image exists ghcr.io/daniele821/neovim && echo "purging current neovim container..."; podman rmi -f ghcr.io/daniele821/neovim ;;
    esac
    BG_CONTAINER="$(podman ps -a --filter "ancestor=ghcr.io/daniele821/neovim" -q)"
    if [[ "$(echo "$BG_CONTAINER" | wc -l)" -gt 1 ]]; then
        echo "multiple neovim containers detected:"
        while read -r ps; do 
            echo "deleting '$ps'..."
            podman rm -f $ps >/dev/null
        done <<<"$BG_CONTAINER"
    fi
    BG_CONTAINER="$(podman ps -a --filter "ancestor=ghcr.io/daniele821/neovim" -q)"
    if [[ -z "$BG_CONTAINER" ]]; then
        echo "zero neovim containers detected: launching new container..."
        BG_CONTAINER="$(podman run --detach-keys "" -d --init -e "TZ=$(timedatectl show --property=Timezone --value)" "ghcr.io/daniele821/neovim" sleep infinity)"
    fi
    case "$(podman inspect --format '{{.State.Status}}' "$BG_CONTAINER")" in
        running) ;;
        exited) podman start "$BG_CONTAINER" >/dev/null ;;
        *) podman rm -f "$BG_CONTAINER" >/dev/null ;;
    esac
    podman exec -it -w /root "$BG_CONTAINER" bash -il
}

unset command_not_found_handle
if [[ $- == *i* ]]; then
    for i in - {0..9}; do bind -r "\e$i"; done
    bind -x '"\C-l": clear'
fi
