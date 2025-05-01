#!/bin/bash

# check dependencies
for dep in jq curl wget; do
    ! command -v "$dep" &>/dev/null && echo "$dep is needed by this script!" && exit 1
done

# assure an other istance of tor isn't already running
pgrep tor &>/dev/null && echo 'an other istance of tor browser is already running!' && exit 1

# download tor browser
json_api="$(curl -s https://aus1.torproject.org/torbrowser/update_3/release/download-linux-x86_64.json)"
echo "$json_api"
cd "$(mktemp -d)" || exit
wget -O tor.tar.xz "$(echo "$json_api" | jq -r ".binary")"

# unpack and run tor browser
tar xf tor.tar.xz
cd tor-browser || exit
./start-tor-browser.desktop
