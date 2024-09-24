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
    width=$((wcells * wcellpx))
    height=$(((hcells - 2) * hcellpx))
    # calculations to avoid streching image [*** magic ***]
    if [[ "${resize}" -ne 0 ]]; then
        width_factor="$(echo "$width / $wimg" | bc -lq)"
        height_factor="$(echo "$height / $himg" | bc -lq)"
        width_factor_rel="$(echo "$width_factor / $height_factor" | bc -lq)"
        height_factor_rel="$(echo "$height_factor / $width_factor" | bc -lq)"
        if [[ "$(echo "$width_factor_rel > 1" | bc -lq)" -eq 1 ]]; then
            width="$(echo "$width / $width_factor_rel" | bc -lq)"
            width=${width%%.*}
        elif [[ "$(echo "$height_factor_rel > 1" | bc -lq)" -eq 1 ]]; then
            height="$(echo "$height / $height_factor_rel" | bc -lq)"
            height=${height%%.*}
        fi
    fi
    img2sixel -h "$height" -w "$width" "$image" | less -r
}

function preview() {
    __preview__ "1" "${@}"
}
function fpreview() {
    __preview__ "0" "${@}"
}
