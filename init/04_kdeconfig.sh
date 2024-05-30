#!/bin/env bash

# warning
echo "Warning: extreme kde configuration, may delete customizations"
echo -n "Do you still wish to proceed [y/n]? "
read -r answer </dev/tty
[[ "${answer,,:0:1}" == "y" ]] || exit 0

# change global theme
lookandfeeltool -a org.kde.breezedark.desktop --resetLayout || exit 1
