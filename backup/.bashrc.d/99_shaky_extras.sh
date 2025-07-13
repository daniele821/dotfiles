#!/bin/bash

# build neovim image
function build_neovim() {
    TMP_DIR="$(mktemp -d)"
    git clone --branch complete --depth 1 https://github.com/daniele821/nvim-config "$TMP_DIR"
    podman build --rm -t neovim "$TMP_DIR/image"
    podman image prune -f
    rm -rf "$TMP_DIR"
}

# run neovim dev container in current directory
function edit() {
    if ! podman image exists localhost/neovim; then
        build_neovim
    fi
    case "$#" in
    0) # mount NOTHING
        DIRNAME="$(basename "$(realpath .)")"
        [[ "$DIRNAME" == "/" ]] && DIRNAME="host"
        podman run --rm -it -w /root localhost/neovim bash -ic 'nvim'
        ;;
    1) # mount file or directory, and set workdir to that mount location
        FULLPATH="$(realpath -- "$1")"
        ! [[ -e "$FULLPATH" ]] && echo "'$1' does not exists" && return 1
        PATHNAME="$(basename "$FULLPATH")"
        if [[ -d "$1" ]]; then
            podman run --rm -it --security-opt label=type:container_runtime_t -v "$FULLPATH:/host/$PATHNAME" -w "/host/$PATHNAME" localhost/neovim bash -ic 'nvim'
        else
            podman run --rm -it --security-opt label=type:container_runtime_t -v "$FULLPATH:/host/$PATHNAME" -w "/host/" localhost/neovim bash -ic 'nvim "$@"' _ "/host/$PATHNAME"
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
        podman run --rm -it --security-opt label=type:container_runtime_t "${MOUNTS[@]}" -w /host localhost/neovim bash -ic 'nvim "$@"' _ "${ARGS[@]}"
        ;;
    esac
}
