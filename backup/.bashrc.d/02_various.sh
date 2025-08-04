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
            while read -r ps; do 
                if [[ -n "$ps" ]]; then
                    echo -e "\e[1;33mdeleting '$ps'...\e[m"
                    podman rm -f $ps
                fi
            done <<<"$(podman ps -a --filter "ancestor=$NEOVIM_IMAGE" -q)"
            podman pull "$NEOVIM_IMAGE"
            podman system prune -f
            ;;
    esac
    local BG_CONTAINER="$(podman ps -a --filter "ancestor=$NEOVIM_IMAGE" -q)"
    if [[ "$(echo "$BG_CONTAINER" | wc -l)" -gt 1 ]]; then
        echo -e "\e[1;33mmultiple neovim containers detected:\e[m"
        while read -r ps; do 
            echo -e "\e[1;33mdeleting '$ps'...\e[m"
            podman rm -f $ps
        done <<<"$BG_CONTAINER"
    fi
    local BG_CONTAINER="$(podman ps -a --filter "ancestor=$NEOVIM_IMAGE" -q)"
    if [[ -z "$BG_CONTAINER" ]]; then
        echo -e "\e[1;33mzero neovim containers detected: launching new container...\e[m"
        local BG_CONTAINER="$(podman run --detach-keys "" -v data_neovim:/data -d --init -e "TZ=$(timedatectl show --property=Timezone --value)" "$NEOVIM_IMAGE" sleep infinity)"
    fi
    state="$(podman inspect --format '{{.State.Status}}' "$BG_CONTAINER")"
    case "$state" in
        running) ;;
        paused) echo -e "\e[1;33mcontainer found paused: unpausing it...\e[m"; podman unpause "$BG_CONTAINER" ;;
        exited) echo -e "\e[1;33mcontainer found stopped: launching it...\e[m"; podman start "$BG_CONTAINER" ;;
        *) echo -e "\e[1;33mcountainer found in state '$state': starting a new one...\e[m"; podman rm -f "$BG_CONTAINER" ;;
    esac
    podman exec --detach-keys="" -it -w /data "$BG_CONTAINER" bash -il
}

unset command_not_found_handle
if [[ $- == *i* ]]; then
    for i in - {0..9}; do bind -r "\e$i"; done
    bind -x '"\C-l": clear'
fi
