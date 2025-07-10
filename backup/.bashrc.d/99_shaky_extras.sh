#!/bin/bash

# run neovim dev container in current directory
# WARNING: requires 'localhost/neovim' image to be present!
function ide() {
    DIRNAME="$(basename "$(realpath .)")"
    [[ "$DIRNAME" == "/" ]] && DIRNAME="host"
    podman run --rm -it --security-opt label=type:container_runtime_t -v ".:/app/$DIRNAME" -w "/app/$DIRNAME" localhost/neovim
}

# build neovim image 
# WARNING: makes assumption about nvim-config repo structure!
function build_neovim(){
    TMP_DIR="$(mktemp -d)"
    git clone --branch complete --depth 1 https://github.com/daniele821/nvim-config "$TMP_DIR"
    podman build --rm -t neovim "$TMP_DIR/image"
    podman image prune -f
    rm -rf "$TMP_DIR"
}
