#!/bin/env bash

# apply all changes
echo "Warning: to apply changes, reboot is required"
echo -n "Do you still wish to proceed [y/n]? "
read -r answer </dev/tty
[[ "${answer,,:0:1}" == "y" ]] || exit 0
reboot
