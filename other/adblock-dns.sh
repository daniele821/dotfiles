#!/bin/bash

set -e

read -rp "Specify which connection to modify: " conn
read -rp "Do you want to set the adblocking dns? [y/n] " answer

if [[ "$answer" == y ]]; then
    # set connection to use adblocking dns
    nmcli connection modify "$conn" ipv4.dns "94.140.14.14,94.140.15.15"
    nmcli connection modify "$conn" ipv4.ignore-auto-dns yes
    nmcli connection modify "$conn" ipv6.dns "2a10:50c0::ad1:ff,2a10:50c0::ad2:ff"
    nmcli connection modify "$conn" ipv6.ignore-auto-dns yes
else
    # reset connection
    nmcli connection modify "$conn" ipv4.dns ""
    nmcli connection modify "$conn" ipv4.ignore-auto-dns no
    nmcli connection modify "$conn" ipv6.dns ""
    nmcli connection modify "$conn" ipv6.ignore-auto-dns no
fi

# restart connection
nmcli connection down "$conn"
nmcli connection up "$conn"

# command to create an hotspot on IFACE
# nmcli device wifi hotspot ifname <IFACE> ssid <SSID> con-name <CON-NAME> password <PASSWORD>
