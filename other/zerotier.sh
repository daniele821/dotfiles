#!/bin/bash

[[ -z "$(podman ps -a -q --filter "name=zerotier")" ]] && \
podman run -d \
    --name zerotier-client \
    --cap-add NET_ADMIN \
    --cap-add SYS_ADMIN \
    --cap-add NET_RAW \
    --device /dev/net/tun \
    --security-opt label=type:container_runtime_t \
    -v zerotier-data:/var/lib/zerotier-one \
    docker.io/zerotier/zerotier

exit 0
