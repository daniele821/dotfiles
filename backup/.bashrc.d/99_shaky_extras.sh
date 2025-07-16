#!/bin/bash

# run neovim dev container in current directory
function edit() {
    local -r TZVAR="TZ=$(timedatectl show --property=Timezone --value)"
    local -r SECOP="label=type:container_runtime_t"
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
            WORKDIR="/host$FULLPATH"
        elif [[ -f "$FULLPATH" ]]; then
            WORKDIR="/host$(dirname "$FULLPATH")"
            ARGS=("/host$FULLPATH")
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
                WORKDIR="/host$FULLPATH"
            elif [[ -f "$FULLPATH" ]]; then
                ARGS+=("/host$FULLPATH")
            else
                echo 'UNREACHABLE (2)' && return 1
            fi
        done
        ;;
    esac

    podman run --rm -it -e "$TZVAR" --security-opt "$SECOP" -v "/:/host" -w "$WORKDIR" "$IMAGE" bash -ilc 'nvim "$@"' _ "${ARGS[@]}"
}
