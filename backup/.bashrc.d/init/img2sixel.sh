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
    wcellpx=10
    hcellpx=20
    wterm=$((wcells * wcellpx))
    hterm=$((hcells * hcellpx))
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
    ((width = width / wcellpx * wcellpx - 5))
    ((height = height / hcellpx * hcellpx - 5))
    img2sixel -h "$height" -w "$width" "$image" | less -r
}

function preview() {
    __preview__ "1" "${@}"
}

function fpreview() {
    __preview__ "0" "${@}"
}

function fastpreview() {
    width=$(tput cols)
    width="$((width * 5))"
    img2sixel -w "$width" "$*" | less -r
}
