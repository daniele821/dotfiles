#!/bin/bash

[[ -z "$(podman ps -a -q --filter "name=netbird-client")" ]] && \
podman run -d \
    --name netbird-client \
    --cap-add NET_ADMIN \
    --cap-add SYS_ADMIN \
    --cap-add NET_RAW \
    --device /dev/net/tun \
    --security-opt label=type:container_runtime_t \
    -v netbird-data:/var/lib/netbird \
    docker.io/netbirdio/netbird

exit 0

