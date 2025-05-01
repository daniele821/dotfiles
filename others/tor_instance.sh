#!/bin/bash

set -e

# check dependencies
for dep in jq curl wget; do
    ! command -v "$dep" &>/dev/null && echo "$dep is needed by this script!" && exit 1
done

# assure an other istance of tor isn't already running
pgrep -x tor &>/dev/null && echo 'an other istance of tor browser is already running!' && exit 1

# download tor browser
json_api="$(curl -s https://aus1.torproject.org/torbrowser/update_3/release/download-linux-x86_64.json)"
echo "$json_api"
rm -rf /tmp/tor-browser-temporary-instance
mkdir -p /tmp/tor-browser-temporary-instance
cd "$(mktemp -d /tmp/tor-browser-temporary-instance/XXXXXXXXXXXXXXXXXX)" || exit
wget -O tor.tar.xz "$(echo "$json_api" | jq -r ".binary")"

# unpack and run tor browser
echo "unpacking tor browser..."
tar xf tor.tar.xz
cd tor-browser || exit
MOZ_ENABLE_WAYLAND=1 ./start-tor-browser.desktop
