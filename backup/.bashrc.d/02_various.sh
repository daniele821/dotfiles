#!/bin/bash

export EDITOR="nvim"
export PYTHONDONTWRITEBYTECODE="true"
export GOPATH="$HOME/.local/share/go"
export RUSTUP_HOME="$HOME/.local/share/rustup"
export CARGO_HOME="$HOME/.local/share/cargo"

function open() {
    (for file in "$@"; do xdg-open "$file" &>/dev/null & done)
}
function preview() {
    [[ "$FPREVIEW" == "true" ]] && FULLSCREEN="--scale-up"
    [[ "$FPREVIEW" == "true" ]] || FULLSCREEN=""
    local -r oldPwd="$PWD"
    FILE="${1}"
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

alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lA'

unset command_not_found_handle
if [[ $- == *i* ]]; then
    for i in - {0..9}; do bind -r "\e$i"; done
    bind -x '"\C-l": clear'
fi
