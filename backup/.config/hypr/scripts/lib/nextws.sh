#!/bin/bash

start="$1"
end="$2"
choise="$3"

current="$(hyprctl activeworkspace -j | jq .id)"
wslist="$(hyprctl workspaces -j | jq .[].id | sort -un | while read -r id; do
    [[ "$id" -ge "$start" && "$id" -le "$end" ]] && echo "$id"
done)"

case "$choise" in
prev)
    last="$(echo "$wslist" | tail -1)"
    [[ -z "$last" ]] && last="$start"

    prev="$(for ws in $wslist; do
        [[ "$ws" -lt "$current" ]] && echo "$ws"
    done | tail -1)"
    [[ -z "$prev" ]] && prev="$last"

    hyprctl dispatch workspace "$prev"
    ;;
next)
    first="$(echo "$wslist" | head -1)"
    [[ -z "$first" ]] && first="$start"

    next="$(for ws in $wslist; do
        [[ "$ws" -gt "$current" ]] && echo "$ws"
    done | head -1)"
    [[ -z "$next" ]] && next="$first"

    hyprctl dispatch workspace "$next"
    ;;
esac
