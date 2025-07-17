#!/bin/bash

# run neovim dev container in current directory
function edit() {
    local -r TZVAR="TZ=$(timedatectl show --property=Timezone --value)"
    local -r IMAGE="ghcr.io/daniele821/neovim"
    local FULLPATH=""
    local WORKDIR=""
    local ARGS=()
    local arg=""

    function valid_path() {
        [[ ! -e "$FULLPATH" ]] && echo "'$arg' is not a valid path" && return 1
        local -r fullpath="$(realpath -- "$1")/"
        [[ "$fullpath" == /personal/repos/* ]] && return 0
        echo "'$1' is not an allowed path" && return 1
    }

    case "$#" in
    0 | 1)
        FULLPATH="$(realpath -- "${1:-.}")"
        DIRNAME="$(dirname -- "$FULLPATH")"
        valid_path "$FULLPATH" || return 1
        if [[ -d "$FULLPATH" ]]; then
            WORKDIR="$FULLPATH"
        elif [[ -f "$FULLPATH" ]]; then
            valid_path "$DIRNAME" || return 1
            WORKDIR="$DIRNAME"
            ARGS=("$FULLPATH")
        else
            echo 'UNREACHABLE (1)' && return 1
        fi
        ;;
    *)
        for arg in "$@"; do
            FULLPATH="$(realpath -- "${arg}")"
            valid_path "$FULLPATH"
            if [[ -d "$FULLPATH" ]]; then
                [[ -n "$WORKDIR" ]] && echo "'$arg' is the second directory found" && return 1
                WORKDIR="$FULLPATH"
            elif [[ -f "$FULLPATH" ]]; then
                ARGS+=("$FULLPATH")
            else
                echo 'UNREACHABLE (2)' && return 1
            fi
        done
        [[ -z "$WORKDIR" ]] && WORKDIR="$(dirname -- "${ARGS[0]}")" && ! valid_path "$WORKDIR" && return 1
        ;;
    esac
    [[ "${#ARGS[@]}" == 0 ]] && ARGS=("$WORKDIR")

    podman run --rm -it -e "$TZVAR" -v "/personal/repos:/personal/repos:z" -w "$WORKDIR" "$IMAGE" bash -ilc 'nvim "$@"' _ "${ARGS[@]}"
}
