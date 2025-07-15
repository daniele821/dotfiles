#!/bin/bash

# run neovim dev container in current directory
function edit() {
    case "$#" in
    0) # mount NOTHING
        podman run --rm -it -w /root ghcr.io/daniele821/neovim bash -ic 'nvim'
        ;;
    1) # mount file or directory, and set workdir to that mount location
        FULLPATH="$(realpath -- "$1")"
        ! [[ -e "$FULLPATH" ]] && echo "'$1' does not exists" && return 1
        DIRNAME="$(dirname "$FULLPATH")"
        if [[ -d "$1" ]]; then
            podman run --rm -it --security-opt label=type:container_runtime_t -v "$FULLPATH:/host/$FULLPATH" -w "/host/$FULLPATH" ghcr.io/daniele821/neovim bash -ic 'nvim'
        else
            podman run --rm -it --security-opt label=type:container_runtime_t -v "$FULLPATH:/host/$FULLPATH" -w "/host/$DIRNAME" ghcr.io/daniele821/neovim bash -ic 'nvim "$@"' _ "/host/$FULLPATH"
        fi
        ;;
    *) # mount multiple files at once, in their fullpath, as to easily avoid conflicts
        declare -A tmp_arr
        for arg in "$@"; do
            tmp_arr["$(realpath -- "$arg")"]=1
        done
        FULLPATHS=("${!tmp_arr[@]}")
        MOUNTS=()
        ARGS=()
        for arg in "${FULLPATHS[@]}"; do
            ! [[ -e "$arg" ]] && echo "'$arg' does not exists" && return 1
            [[ -d "$arg" ]] && echo "directories not supported in multi-mount mode" && return 1
            MOUNTS+=(-v "$arg:/host/$arg")
            ARGS+=("/host$arg")
        done
        podman run --rm -it --security-opt label=type:container_runtime_t "${MOUNTS[@]}" -w /host ghcr.io/daniele821/neovim bash -ic 'nvim "$@"' _ "${ARGS[@]}"
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
