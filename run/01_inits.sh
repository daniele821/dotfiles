#!/bin/env bash

echo "disabling screen locking and sleeping!"
kde-inhibit --power sleep infinity &

echo "keep refreshing sudo password (until reboot)!"
sudo -v
while sleep 1; do sudo -v; done &>/dev/null &
