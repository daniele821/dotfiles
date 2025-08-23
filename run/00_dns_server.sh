#!/bin/env bash

set -e

echo '[Resolve]
DNS=94.140.14.14 94.140.15.15 2a10:50c0::ad1:ff 2a10:50c0::ad2:ff
DNSOverTLS=yes
DNSSEC=yes
Domains=~.' | sudo tee /etc/systemd/resolved.conf

sudo systemctl restart systemd-resolved
