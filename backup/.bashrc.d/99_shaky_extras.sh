#!/bin/bash

# run neovim dev container in current directory
function edit() {
    if ! podman image exists ghcr.io/daniele821/neovim; then
        podman pull ghcr.io/daniele821/neovim
    else
        created=$(podman inspect --format '{{ .Created.Unix }}' neovim:latest)
        now=$(date +%s)
        time_diff="$((now - created))"
        [[ "$time_diff" -gt 86400 ]] && podman pull ghcr.io/daniele821/neovim
    fi
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
        MULTI_MOUNT_LIMIT=25
        declare -A tmp_arr
        for arg in "$@"; do
            tmp_arr["$(realpath -- "$arg")"]=1
        done
        FULLPATHS=("${!tmp_arr[@]}")
        [[ "${#FULLPATHS[@]}" -gt "$MULTI_MOUNT_LIMIT" ]] && echo "cannot mount more then $MULTI_MOUNT_LIMIT files at once" && return 1
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
