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
    local NEOVIM_IMAGE="ghcr.io/daniele821/neovim"
    case "$1" in
        up|update|upgrade) 
            if podman image exists "$NEOVIM_IMAGE"; then 
                echo "purging current neovim container..."; podman rmi -f "$NEOVIM_IMAGE"; podman system prune -f 
            fi ;;
    esac
    local BG_CONTAINER="$(podman ps -a --filter "ancestor=$NEOVIM_IMAGE" -q)"
    if [[ "$(echo "$BG_CONTAINER" | wc -l)" -gt 1 ]]; then
        echo "multiple neovim containers detected:"
        while read -r ps; do 
            echo "deleting '$ps'..."
            podman rm -f $ps >/dev/null
        done <<<"$BG_CONTAINER"
    fi
    local BG_CONTAINER="$(podman ps -a --filter "ancestor=$NEOVIM_IMAGE" -q)"
    if [[ -z "$BG_CONTAINER" ]]; then
        echo "zero neovim containers detected: launching new container..."
        local BG_CONTAINER="$(podman run --detach-keys "" -d --init -e "TZ=$(timedatectl show --property=Timezone --value)" "$NEOVIM_IMAGE" sleep infinity)"
    fi
    state="$(podman inspect --format '{{.State.Status}}' "$BG_CONTAINER")"
    case "$state" in
        running) ;;
        paused) echo "container found paused: unpausing it..."; podman unpause "$BG_CONTAINER" >/dev/null ;;
        exited) echo "container found stopped: launching it..."; podman start "$BG_CONTAINER" >/dev/null ;;
        *) echo "countainer found in state '$state': starting a new one..."; podman rm -f "$BG_CONTAINER" >/dev/null ;;
    esac
    podman exec --detach-keys="" -it -w /root "$BG_CONTAINER" bash -il
}

unset command_not_found_handle
if [[ $- == *i* ]]; then
    for i in - {0..9}; do bind -r "\e$i"; done
    bind -x '"\C-l": clear'
fi
