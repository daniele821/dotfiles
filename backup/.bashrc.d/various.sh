#!/bin/bash

export EDITOR="nvim"
export PYTHONDONTWRITEBYTECODE="true"
export GOPATH="$HOME/.local/share/go"

eval "$(direnv hook bash)"

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
    others=()
    for file in "${@}"; do
        if [[ "$(head -c 4 "$file")" == "%PDF" ]]; then
            pdfs+=("$file")
        elif [[ -d "$file" ]]; then
            dirs+=("$file")
        else
            others+=("$file")
        fi &>/dev/null
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
    for file in "${others[@]}"; do
        __exec_nohupped__ xdg-open "$file"
    done
}
function edit() {
    ! command -v nvim &>/dev/null && echo 'neovim needs to be installed!' && return 1
    case "$#" in
    0) return 0 ;;
    1) ;;
    *) echo 'multiple files cannot be edited at once!' && return 1 ;;
    esac
    file="$1"
    path="$(realpath "${file}")"
    if ! [[ -f "${path}" ]]; then
        echo "cannot edit ${path}" 1>&2
    else
        if test -w "${path}"; then
            nvim "$path"
        else
            EDITOR=nvim sudoedit "$path"
        fi
    fi
}
function preview() {
    kitten icat --align=left --background=#232627 --place "$(tput cols)"x"$(tput lines)"@0x0 "${@}" | less -r
}
function fpreview() {
    preview --scale-up "${@}"
}

complete -f preview
complete -f fpreview
complete -f open
complete -f fopen
complete -c run

alias ls='lsd --group-dirs first'
alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lA'
alias tree='lsd --group-dirs first --tree'
alias cat='bat'
alias clear='printf "\033[2J\033[3J\033[1;1H"'

unset command_not_found_handle
for i in - {0..9}; do bind -r "\e$i"; done
bind -x '"\C-l": clear'
