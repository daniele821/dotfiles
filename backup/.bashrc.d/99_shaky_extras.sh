#!/bin/bash

# run neovim dev container in current directory
function edit() {
    local -r TZVAR="TZ=$(timedatectl show --property=Timezone --value)"
    local -r IMAGE="ghcr.io/daniele821/neovim"
    local FULLPATH=""
    local WORKDIR=""
    local ARGS=()
    local arg=""

    case "$#" in
    0 | 1)
        FULLPATH="$(realpath -- "${1:-.}")"
        [[ ! -e "$FULLPATH" ]] && echo "'$1' is not a valid path" && return 1
        if [[ -d "$FULLPATH" ]]; then
            WORKDIR="$FULLPATH"
        elif [[ -f "$FULLPATH" ]]; then
            WORKDIR="$(dirname "$FULLPATH")"
            ARGS=("$FULLPATH")
        else
            echo 'UNREACHABLE (1)' && return 1
        fi
        ;;
    *)
        for arg in "$@"; do
            FULLPATH="$(realpath -- "${arg}")"
            [[ ! -e "$FULLPATH" ]] && echo "'$arg' is not a valid path" && return 1
            if [[ -d "$FULLPATH" ]]; then
                [[ -n "$WORKDIR" ]] && echo "'$arg' is the second directory found" && return 1
                WORKDIR="$FULLPATH"
            elif [[ -f "$FULLPATH" ]]; then
                ARGS+=("$FULLPATH")
            else
                echo 'UNREACHABLE (2)' && return 1
            fi
        done
        [[ -z "$WORKDIR" ]] && WORKDIR="$(dirname "${ARGS[0]}")"
        ;;
    esac
    [[ "${#ARGS[@]}" == 0 ]] && ARGS=("$WORKDIR")

    function valid_path() {
        case "$1" in
        /personal/repos/* | /personal/repos) ;;
        *) echo "'$1' is not an allowed path" && return 1 ;;
        esac
    }
    valid_path "$WORKDIR" || return 1
    for arg in "${ARGS[@]}"; do valid_path "$arg"; done || return 1

    podman run --rm -it -e "$TZVAR" -v "/personal/repos:/personal/repos:z" -w "$WORKDIR" "$IMAGE" bash -ilc 'nvim "$@"' _ "${ARGS[@]}"
}
