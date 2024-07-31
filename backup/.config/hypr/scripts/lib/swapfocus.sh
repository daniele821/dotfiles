#!/bin/bash

# swap between tiled or floating windows

if "$(hyprctl -j activewindow | jq .floating)"; then
    hyprctl dispatch cyclenext tile
else
    hyprctl dispatch cyclenext float && hyprctl dispatch alterzorder top
fi
