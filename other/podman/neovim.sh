#!/bin/bash

[[ -z "$(podman ps -a -q --filter "name=neovim-client")" ]] && \
podman run -d \
    --init \
    --detach-keys "" \
    --name neovim-client \
    -e "TZ=$(timedatectl show --property=Timezone --value)" \
    --security-opt label=type:container_runtime_t \
    -v neovim-data:/data \
    ghcr.io/daniele821/neovim

podman exec --detach-keys "" -it -w /data neovim-client bash -il

exit 0

