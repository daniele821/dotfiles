#!/bin/bash

function edit(){
    podman run -it --rm \
    --detach-keys "" \
    -e "TZ=$(timedatectl show --property=Timezone --value)" \
    --security-opt label=type:container_runtime_t \
    -v neovim-data:/data \
    -w /data \
    ghcr.io/daniele821/neovim
    bash -il
}
