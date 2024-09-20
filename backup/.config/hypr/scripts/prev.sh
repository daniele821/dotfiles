#!/bin/sh

TRASHWS="$1"

CURRENTWS="$(hyprctl activeworkspace -j | jq .id)"
HISTORYWS="$(hyprctl clients -j | jq 'sort_by(.focusHistoryID) | .[].workspace.id')"
GOTOWS="$({
    echo "$CURRENTWS"
    echo "$HISTORYWS"
} | uniq | tail -n +2 | grep -xv "$TRASHWS" | head -1)"
hyprctl dispatch workspace "$GOTOWS"
