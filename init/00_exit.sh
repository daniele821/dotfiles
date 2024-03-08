#!/bin/env bash

echo "Warning: installation scripts not tested. install manually"
echo "Warning: to avoid problems with dnf, you should upgrade from gnome-software before running these scripts"
echo -n "Do you still wish to proceed [y/n]? " 
read -r answer </dev/tty
[[ "${answer,,:0:1}" != "y" ]] && exit 1


