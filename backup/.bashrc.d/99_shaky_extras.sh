#!/bin/bash

# run neovim dev container in current directory
function edit() {
    local -r TZVAR="TZ=$(timedatectl show --property=Timezone --value)"
    local -r IMAGE="ghcr.io/daniele821/neovim"
    local FULLPATH=""
    local DIRNAME=""
    local WORKDIR=""
    local ARGS=()
    local arg=""

    function __valid_path_() {
        [[ ! -e "$FULLPATH" ]] && echo "'$arg' is not a valid path" && return 1
        local -r fullpath="$(realpath -- "$1")/"
        [[ "$fullpath" == "$HOME/.personal/repos/"* ]] && return 0
        echo "'$1' is not an allowed path" && return 1
    }

    case "$#" in
    0 | 1)
        FULLPATH="$(realpath -- "${1:-.}")"
        DIRNAME="$(dirname -- "$FULLPATH")"
        __valid_path_ "$FULLPATH" || return 1
        if [[ -d "$FULLPATH" ]]; then
            WORKDIR="$FULLPATH"
        elif [[ -f "$FULLPATH" ]]; then
            __valid_path_ "$DIRNAME" || return 1
            WORKDIR="$DIRNAME"
            ARGS=("$FULLPATH")
        else
            echo 'UNREACHABLE (1)' && return 1
        fi
        ;;
    *)
        for arg in "$@"; do
            FULLPATH="$(realpath -- "${arg}")"
            __valid_path_ "$FULLPATH"
            if [[ -d "$FULLPATH" ]]; then
                [[ -n "$WORKDIR" ]] && echo "'$arg' is the second directory found" && return 1
                WORKDIR="$FULLPATH"
            elif [[ -f "$FULLPATH" ]]; then
                ARGS+=("$FULLPATH")
            else
                echo 'UNREACHABLE (2)' && return 1
            fi
        done
        if [[ -z "$WORKDIR" ]]; then
            DIRNAME="$(dirname -- "${ARGS[0]}")" 
            __valid_path_ "$DIRNAME" || return 1
            WORKDIR="$DIRNAME"
        fi
        ;;
    esac
    [[ "${#ARGS[@]}" == 0 ]] && ARGS=("$WORKDIR")

    # NOTE: detach-keys is necessary, otherwise ctrl+p gets stuck waiting for ctrl+q (or any other input)
    podman run --detach-keys "" --rm -it -e "$TZVAR" -v "$HOME/.personal/repos:$HOME/.personal/repos:z" -w "$WORKDIR" "$IMAGE" bash -ilc 'nvim "$@"' _ "${ARGS[@]}"
}
