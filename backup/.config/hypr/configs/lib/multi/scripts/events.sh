#!/bin/bash

WS_LAST1=1
WS_LAST2=11
WS_TRACK=1
SUBMAP_TRACK=1

function ws_in() {
    actws="$(hyprctl activeworkspace -j | jq .id)"
    [[ -n "${3}" ]] && actws="$3"
    [[ "${actws}" -ge "$1" && "${actws}" -le "$2" ]]
}

function track_hist() {
    actws="$(hyprctl activeworkspace -j | jq .id)"
    if ws_in 1 10 "$actws"; then
        WS_LAST1="$actws"
    elif ws_in 11 20 "$actws"; then
        WS_LAST2="$actws"
    fi
}

handle() {
    event="${1%%>>*}"
    data="${1#*>>}"
    case "${event}" in
    submap)
        case "${data}" in
        "")
            SUBMAP_TRACK=1
            if ! ws_in 1 10; then
                track_hist
                hyprctl dispatch workspace "$WS_LAST1"
            fi
            ;;
        work)
            SUBMAP_TRACK=2
            if ! ws_in 11 20; then
                track_hist
                hyprctl dispatch workspace "$WS_LAST2"
            fi
            ;;
        esac
        ;;
    workspacev2)
        id=${data%%,*}
        case "${SUBMAP_TRACK}" in
        1)
            if ws_in 1 10; then
                WS_TRACK="${id}"
            else
                hyprctl dispatch workspace "${WS_TRACK}"
            fi
            ;;
        2)
            if ws_in 11 20; then
                WS_TRACK="${id}"
            else
                hyprctl dispatch workspace "${WS_TRACK}"
            fi
            ;;
        esac
        ;;
    esac
}

socat -U - UNIX-CONNECT:/tmp/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock | while read -r line; do handle "$line"; done &>/dev/null
