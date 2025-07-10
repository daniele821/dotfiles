#!/bin/bash

# run neovim dev container in current directory
# WARNING: requires 'localhost/neovim' image to be present!
function ide() {
    DIRNAME="$(basename "$(realpath .)")"
    [[ "$DIRNAME" == "/" ]] && DIRNAME="host"
    podman run --rm -it --security-opt label=type:container_runtime_t -v ".:/app/$DIRNAME" -w "/app/$DIRNAME" localhost/neovim
}

