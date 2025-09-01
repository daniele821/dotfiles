#!/bin/bash

# util function
function exist() {
    command -v "$@" &>/dev/null
}

# bat init
if exist bat; then
    alias cat='bat'
fi

# lsd init
if exist lsd; then
    function tree() {
        timeout 0.2 lsd --group-dirs first --tree "$@" &>/dev/null
        if [[ $? -ne "124" ]]; then
            lsd --group-dirs first --tree "$@"
        else
            /usr/bin/tree "$@"
        fi 2>/dev/null
    }
    alias ls='lsd --group-dirs first'
fi

# zoxide init
if exist zoxide; then
    eval "$(zoxide init bash)"
fi

# kitten init
if exist kitten; then
    function preview() {
        [[ "$FPREVIEW" == "true" ]] && local -r FULLSCREEN="--scale-up"
        [[ "$FPREVIEW" == "true" ]] || local -r FULLSCREEN=""
        local -r oldPwd="$PWD"
        local FILE="${1}"
        if [[ $# == 0 || -d "$FILE" ]]; then
            [[ -d "${FILE}" ]] && ! cd "${1}" &>/dev/null && return 1
            FILE="$(
                find . -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' \
                    -o -iname '*.webp' -o -iname '*.bmp' -o -iname '*.tiff' \) 2>/dev/null |
                    cut -b 3- |
                    fzf --exit-0 --select-1 --height=40% --layout=reverse --border
            )"
        fi
        if [[ "$(xdg-mime query filetype "${FILE}" 2>/dev/null)" =~ "image/" ]]; then
            printf '\e[?1049h'
            kitten icat --align=center --place "$(tput cols)"x"$(tput lines)"@0x0 "${FULLSCREEN}" "${FILE}"
            printf '\e[?25l'
            read -rn 1
            clear
            printf '\e[?1049l\e[?25h'
        fi
        cd "${oldPwd}" &>/dev/null || return 1
    }
    function fpreview() {
        FPREVIEW="true" preview "${@}"
    }
fi
