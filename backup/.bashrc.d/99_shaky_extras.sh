#!/bin/bash

# run neovim dev container in current directory
function edit() {
    function fix_file() {
        FULLPATH="$(realpath -- "$1")"
        ! [[ -e "$FULLPATH" ]] && echo "'$1' does not exists" >&2 && return 1
        ! [[ -O "$FULLPATH" ]] && echo "'$1' is not owned by current user" >&2 && return 1
        [[ -L "${1%/}" ]] && echo "'$1' is a symlink" >&2 && return 1
        echo "$FULLPATH" && return 0
    }
    TZVAR="TZ=$(timedatectl show --property=Timezone --value)"
    IMAGE="ghcr.io/daniele821/neovim"
    case "$#" in
    0) # mount NOTHING
        FULLPATH="$(fix_file .)" || return 1
        podman run --rm -it -e "$TZVAR" --security-opt label=type:container_runtime_t -v "$FULLPATH:/host$FULLPATH" -w "/host$FULLPATH" "$IMAGE" bash -ic 'nvim'
        ;;
    1) # mount file or directory, and set workdir to that mount location
        FULLPATH="$(fix_file "$1")" || return 1
        DIRNAME="$(dirname "$FULLPATH")"
        if [[ -d "$1" ]]; then
            podman run --rm -it -e "$TZVAR" --security-opt label=type:container_runtime_t -v "$FULLPATH:/host$FULLPATH" -w "/host$FULLPATH" "$IMAGE" bash -ic 'nvim'
        else
            podman run --rm -it -e "$TZVAR" --security-opt label=type:container_runtime_t -v "$FULLPATH:/host$FULLPATH" -w "/host$DIRNAME" "$IMAGE" bash -ic 'nvim "$@"' _ "/host/$FULLPATH"
        fi
        ;;
    *) # mount multiple files at once, in their fullpath, as to easily avoid conflicts
        declare -A tmp_arr
        for arg in "$@"; do
            path="$(fix_file "$arg")" || return 1
            tmp_arr["$path"]=1
        done
        FULLPATHS=("${!tmp_arr[@]}")
        MOUNTS=()
        ARGS=()
        for arg in "${FULLPATHS[@]}"; do
            MOUNTS+=(-v "$arg:/host$arg")
            [[ -f "$arg" ]] && ARGS+=("/host$arg")
        done
        podman run --rm -it -e "$TZVAR" --security-opt label=type:container_runtime_t "${MOUNTS[@]}" -w /host "$IMAGE" bash -ic 'nvim "$@"' _ "${ARGS[@]}"
        ;;
    esac
}

# update all git repos
function gup() {
    find /personal/repos -iname '.git' | while read -r path; do
        path="$(dirname "$(realpath "$path")")"
        echo -ne "\e[1;37m$path ...\e[m"
        if ! OUTPUT="$(git -C "$path" pull --all --ff-only 2>&1)"; then
            echo -e "\r\e[1;31m$path [ERROR]:\e[m"
            echo "$OUTPUT"
        elif [[ "$OUTPUT" == "Already up to date." ]]; then
            echo -e "\r\e[1;32m$path [OK]\e[m"
        else
            echo -e "\r\e[1;33m$path [CHANGED]:\e[m"
            echo "$OUTPUT"
        fi
    done
}
