#!/bin/bash

CWD="$(hyprctl activewindow -j | jq 'select(.class=="kitty") | .title' -r | sed 's/.*://g' | grep -Ev "^(kitty|bash)$")"
[[ -n "$CWD" ]] && kitty -d "${CWD}"
