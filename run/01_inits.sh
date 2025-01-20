#!/bin/env bash

echo "setting performance power profile, to speed up this process (will be reset at next reboot)!"
tuned-adm profile throughput-performance

echo "disabling screen locking and sleeping!"
kde-inhibit --power sleep infinity &

echo "keep refreshing sudo password (until reboot)!"
sudo -v
while sleep 1; do sudo -v; done &>/dev/null &
