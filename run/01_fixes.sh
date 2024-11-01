#!/bin/env bash
# vim:ft=bash

# disable powersave wifi mode (fixes bluetooth stutter)
echo "disabling powersaver wifi mode (fix bluetooth stutter)"
sudo sed -i 's/wifi\.powersave\ \=\ 3/wifi\.powersave\ \=\ 2/' /etc/NetworkManager/conf.d/*

exit 0
