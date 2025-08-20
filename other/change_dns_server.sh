#!/bin/bash

read -rp "Do you want to (1) set or (2) remove adblocking dns? " answer
case "$answer" in
1)
    echo '[Resolve]
DNS=94.140.14.14 94.140.15.15 2a10:50c0::ad1:ff 2a10:50c0::ad2:ff
DNSOverTLS=yes
Domains=~.
' | sudo tee /etc/systemd/resolved.conf
    ;;
2) sudo rm /etc/systemd/resolved.conf ;;
*) echo "invalid answer!" && exit 1 ;;
esac
sudo systemctl restart systemd-resolved
