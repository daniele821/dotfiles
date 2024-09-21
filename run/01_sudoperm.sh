#!/bin/bash

echo -n "Do you wish to cache the password [Y/n]? "
read -r answer </dev/tty
[[ "${answer,,:0:1}" == "y" ]] || exit 0
sudo -v
while sleep 100; do sudo -v; done &
PID="$!"
echo "background process caching sudo password PID: $PID"
echo "SUGGESTION: reboot to remove all background processes"
