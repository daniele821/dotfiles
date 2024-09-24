#!/bin/bash

function __preview__() {
    resize="${1}"
    image="${*:2}"
    [[ -f $image ]] || {
        echo "Not a file!"
        return 1
    }
    wimg=$(identify -format "%w" "$image" 2>/dev/null)
    himg=$(identify -format "%h" "$image" 2>/dev/null)
    wcells=$(tput cols)
    hcells=$(tput lines)
    if hyprctl activewindow -j | jq '.size[0]' &>/dev/null; then
        # hyprland is able to retrieve the size of the current window!
        wterm=$(hyprctl activewindow -j | jq '.size[0]')
        hterm=$(hyprctl activewindow -j | jq '.size[1]')
        wcellpx=$((wterm / wcells))
        hcellpx=$((hterm / hcells))
    else
        # otherwise we estimate a cell width and height!
        wcellpx=10
        hcellpx=20
        wterm=$((wcells * wcellpx))
        hterm=$((hcells * hcellpx))
    fi
    # will trasform the image to fit perfectly!
    i="$(/home/daniele/.bashrc.d/python-scripts/image-math.py "$wimg" "$himg" "$wcells" "$hcells" "$wterm" "$hterm" "$wcellpx" "$hcellpx" "$resize")" || return 1
    width="$(echo "$i" | head -1)"
    height="$(echo "$i" | tail -1)"
    img2sixel -h "$height" -w "$width" "$image" | less -r
}

function preview() {
    __preview__ "1" "${@}"
}
function fpreview() {
    __preview__ "0" "${@}"
}

function fastpreview() {
    wcells=$(tput cols)
    width=$((wcells * 8))
    img2sixel -w "$width" "$*" | less -r
}
