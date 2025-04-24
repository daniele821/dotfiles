#!/bin/bash

export EDITOR="nvim"
export PYTHONDONTWRITEBYTECODE="true"
export GOPATH="$HOME/.local/share/go"

function __exec_nohupped__() {
    (: && nohup "$@" &>/dev/null &)
}
function run() {
    __exec_nohupped__ "$@"
}
function open() {
    for file in "$@"; do
        __exec_nohupped__ xdg-open "$file"
    done
}
function custom_pager() {
    printf '\e[?1049h'
    "$@"
    printf '\e[?25l'
    read -rn 1
    clear
    printf '\e[?1049l\e[?25h'
}
function preview() {
    [[ "$FPREVIEW" == "true" ]] && FULLSCREEN="--scale-up"
    [[ "$FPREVIEW" == "true" ]] || FULLSCREEN=""
    local -r oldPwd="$PWD"
    FILE="${1}"
    if [[ $# == 0 || -d "$FILE" ]]; then
        [[ -d "${FILE}" ]] && ! cd "${1}" &>/dev/null && return 1
        FILE="$(find . -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' \) 2>/dev/null |
            cut -b 3- |
            fzf --exit-0 --select-1 --height=40% --layout=reverse --border)"
    fi
    if [[ "$(xdg-mime query filetype "${FILE}" 2>/dev/null)" =~ "image/" ]]; then
        custom_pager kitten icat --align=center --place "$(tput cols)"x"$(tput lines)"@0x0 "${FULLSCREEN}" "${FILE}"
    fi
    cd "${oldPwd}" &>/dev/null || return 1
}
function fpreview() {
    FPREVIEW="true" preview "${@}"
}
function gitall() {
    DIR="$1"
    [[ "$#" -eq 0 ]] && DIR="."
    [[ ! -d "$DIR" ]] && echo "'$DIR' is not a directory" && return 1
    function color() {
        if [[ -t 1 ]]; then
            echo -en "\e[${1}m${2}\e[0m"
        else
            echo -en "${3}"
        fi
        echo -en "${4}"
    }
    find "$DIR" -iname .git 2>/dev/null | while read -r dir; do
        dir="$(dirname "$dir")"
        if git -C "$dir" rev-parse --is-inside-work-tree &>/dev/null; then
            GITST="$(git -C "$dir" status -s)"
            if [[ "$(echo "$GITST" | wc -w)" -eq 0 ]]; then
                color "32" "$dir" "$dir" "\n"
            else
                color "31" "$dir" "$dir" "\n"
                color "" "$GITST\n" ""
            fi
        fi
    done
}

complete -c run
complete -c custom_pager
complete -f open
complete -f preview
complete -f fpreview
complete -d gitall

alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lA'

unset command_not_found_handle
if [[ $- == *i* ]]; then
    for i in - {0..9}; do bind -r "\e$i"; done
    bind -x '"\C-l": clear'
fi
