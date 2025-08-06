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

function edit() {
    local BG_CONTAINER=
    local NEOVIM_IMAGE="ghcr.io/daniele821/neovim"
    local NEOVIM_VOLUME="data_neovim"

    case "$1" in
    end | stop) edit _stop ;;
    up | update | upgrade)
        edit _stop
        podman pull "$NEOVIM_IMAGE"
        podman system prune -f
        echo -e "\e[1;33mlaunch new container...\e[m"
        edit _launch >/dev/null
        ;;
    cd | files)
        cd "$(podman volume inspect "$NEOVIM_VOLUME" -f '{{.Mountpoint}}')" || return 1
        ;;
    _stop)
        while read -r ps; do
            if [[ -n "$ps" ]]; then
                echo -e "\e[1;33mdeleting '$ps'...\e[m"
                podman rm -f "$ps" >/dev/null
            fi
        done <<<"$(podman ps -a --filter "ancestor=$NEOVIM_IMAGE" -q)"
        ;;
    _list) podman ps -a --filter "ancestor=$NEOVIM_IMAGE" -q ;;
    _launch) podman run --detach-keys "" -v "$NEOVIM_VOLUME:/data" -d --init -e "TZ=$(timedatectl show --property=Timezone --value)" "$NEOVIM_IMAGE" sleep infinity ;;
    "") ;;
    *) echo -e "\e[1;31minvalid arg: '$1'\e[m" && return 1 ;;
    esac
    [[ -n "$1" ]] && return 0

    BG_CONTAINER="$(edit _list)"
    if [[ "$(echo "$BG_CONTAINER" | wc -l)" -gt 1 ]]; then
        echo -e "\e[1;33mmultiple neovim containers detected:\e[m"
        edit _stop
    fi
    BG_CONTAINER="$(edit _list)"
    if [[ -z "$BG_CONTAINER" ]]; then
        echo -e "\e[1;33mzero neovim containers detected: launching new container...\e[m"
        BG_CONTAINER="$(edit _launch)"
    fi
    state="$(podman inspect --format '{{.State.Status}}' "$BG_CONTAINER")"

    case "$state" in
    running) ;;
    paused)
        echo -e "\e[1;33mcontainer found paused: unpausing it...\e[m"
        podman unpause "$BG_CONTAINER"
        ;;
    exited)
        echo -e "\e[1;33mcontainer found stopped: launching it...\e[m"
        podman start "$BG_CONTAINER"
        ;;
    *)
        echo -e "\e[1;33mcontainer found in state '$state': starting a new one...\e[m"
        podman rm -f "$BG_CONTAINER"
        BG_CONTAINER="$(edit _launch)"
        ;;
    esac

    podman exec --detach-keys="" -it -w /data "$BG_CONTAINER" bash -il
}

unset command_not_found_handle
if [[ $- == *i* ]]; then
    for i in - {0..9}; do bind -r "\e$i"; done
    bind -x '"\C-l": clear'
fi
