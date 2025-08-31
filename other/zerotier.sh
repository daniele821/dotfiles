#!/bin/bash

podman rm -f zerotier-client

podman run -d --rm \
    --name zerotier-client \
    --cap-add NET_ADMIN \
    --cap-add SYS_ADMIN \
    --cap-add NET_RAW \
    --device /dev/net/tun \
    --security-opt label=type:container_runtime_t \
    -p 5000:5000 \
    -v zerotier-data:/var/lib/zerotier-one \
    docker.io/zerotier/zerotier
