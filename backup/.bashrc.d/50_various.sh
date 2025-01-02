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
    [[ "${#@}" -eq "0" ]] && return 0
    pdfs=()
    dirs=()
    videos=()
    others=()
    for file in "${@}"; do
        type="$(xdg-mime query filetype "${file}" 2>/dev/null)"
        case "$type" in
        application/pdf) pdfs+=("$file") ;;
        inode/directory) dirs+=("$file") ;;
        video/*) videos+=("$file") ;;
        *) others+=("$file") ;;
        esac &>/dev/null
    done
    if command -v okular &>/dev/null; then
        [[ "${#pdfs[@]}" -gt 0 ]] && __exec_nohupped__ okular "${pdfs[@]}"
    else
        others+=("${pdfs[@]}")
    fi
    if command -v dolphin &>/dev/null; then
        [[ "${#dirs[@]}" -gt 0 ]] && __exec_nohupped__ dolphin "${dirs[@]}"
    else
        others+=("${dirs[@]}")
    fi
    if command -v mpv &>/dev/null; then
        [[ "${#videos[@]}" -gt 0 ]] && __exec_nohupped__ mpv "${videos[@]}"
    else
        others+=("${videos[@]}")
    fi
    for file in "${others[@]}"; do
        __exec_nohupped__ xdg-open "$file"
    done
}
function preview() {
    kitten icat --align=left --background=#232627 --place "$(tput cols)"x"$(tput lines)"@0x0 "${@}" | less -r
    echo -ne "\e[1A\e[J"
}
function fpreview() {
    preview --scale-up "${@}"
}

complete -c run

alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lA'
alias clear='printf "\033[2J\033[3J\033[1;1H"'

unset command_not_found_handle
if [[ $- == *i* ]]; then
    for i in - {0..9}; do bind -r "\e$i"; done
    bind -x '"\C-l": clear'
fi
