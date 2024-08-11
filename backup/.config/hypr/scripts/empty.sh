#!/bin/bash

FIRST_EMPTY=5

CURRENT_ID="$(hyprctl activeworkspace -j | jq '.id')"
CURRENT_WINDOWS="$(hyprctl activeworkspace -j | jq '.windows')"
EXTRA_WS="$(hyprctl workspaces -j | jq ".[] | select(.id >= $FIRST_EMPTY) | .id" | sort -n)"
PREV_WS="$(hyprctl workspaces -j | jq ".[] | select(.id >= $FIRST_EMPTY) | select(.id < $CURRENT_ID) | .id" | sort -n | tail -1)"
NEXT_WS="$(hyprctl workspaces -j | jq ".[] | select(.id >= $FIRST_EMPTY) | select(.id > $CURRENT_ID) | .id" | sort -n | head -1)"
EMPTY="${FIRST_EMPTY}"
for n in ${EXTRA_WS}; do [[ $n -eq $EMPTY ]] && ((EMPTY = EMPTY + 1)); done

case "$1" in
"goto")
    [[ "$CURRENT_ID" -ge "$FIRST_EMPTY" && "$CURRENT_WINDOWS" -eq 0 ]] || hyprctl dispatch workspace "${EMPTY}"
    ;;
"moveto")
    [[ "$CURRENT_ID" -ge "$FIRST_EMPTY" && "$CURRENT_WINDOWS" -le 1 ]] || hyprctl dispatch movetoworkspace "${EMPTY}"
    ;;
"sendto")
    [[ "$CURRENT_ID" -ge "$FIRST_EMPTY" && "$CURRENT_WINDOWS" -le 1 ]] || hyprctl dispatch movetoworkspacesilent "${EMPTY}"
    ;;
"left")
    [[ -z "$EXTRA_WS" ]] && hyprctl dispatch workspace "${EMPTY}" && exit 0
    [[ -n "$PREV_WS" ]] && hyprctl dispatch workspace "${PREV_WS}" && exit 0
    [[ -z "$PREV_WS" ]] && hyprctl dispatch workspace "$(echo "$EXTRA_WS" | tail -1)"
    ;;
"right")
    [[ -z "$EXTRA_WS" ]] && hyprctl dispatch workspace "${EMPTY}" && exit 0
    [[ -n "$NEXT_WS" ]] && hyprctl dispatch workspace "${NEXT_WS}" && exit 0
    [[ -z "$NEXT_WS" ]] && hyprctl dispatch workspace "$(echo "$EXTRA_WS" | head -1)"
    ;;
esac
