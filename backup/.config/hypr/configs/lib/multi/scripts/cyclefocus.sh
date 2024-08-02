#!/bin/bash

# cycle windows of same type of current window
# type: floating or tiled

if "$(hyprctl -j activewindow | jq .floating)"; then
    hyprctl dispatch cyclenext float && hyprctl dispatch alterzorder top
else
    hyprctl dispatch cyclenext tile
fi
