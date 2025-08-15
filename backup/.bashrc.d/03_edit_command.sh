#!/bin/bash

function edit() {
    local BG_CONTAINER=
    local NEOVIM_IMAGE="ghcr.io/daniele821/neovim"
    local NEOVIM_VOLUME="neovim_data"

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
        cd "$(edit _volume)" || return 1
        ;;
    fix) edit _fix ;;
    _fix) restorecon -R "$(edit _volume)" ;;
    _volume) podman volume inspect "$NEOVIM_VOLUME" -f '{{.Mountpoint}}' ;;
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
        BG_CONTAINER="$(edit _list)"
    fi
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

    edit _fix
    podman exec --detach-keys="" -it -w /data "$BG_CONTAINER" bash -il
}
