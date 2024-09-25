#!/bin/env bash

export HISTCONTROL="ignoredups"
export EDITOR="nvim"
export PYTHONDONTWRITEBYTECODE="true"
export GOPATH="$HOME/.local/share/go"

alias la='ls -A'
alias lla='ls -lA'
alias ll='ls -l'
alias clear='printf "\033[2J\033[3J\033[1;1H"'

function __exec_nohupped__() {
    (: && nohup "${@}" &>/dev/null &)
}
function open() {
    PDFS=()
    OTHERS=()
    for file in "${@}"; do
        if [[ $(head -c 4 "$file") = "%PDF" ]] &>/dev/null; then
            PDFS+=("$file")
        else
            OTHERS+=("$file")
        fi
    done
    [[ "${#PDFS[@]}" -gt 0 ]] && run okular --unique "${PDFS[@]}"
    for file in "${OTHERS[@]}"; do
        if command -v kde-open &>/dev/null; then
            __exec_nohupped__ "kde-open" "${file}"
        else
            __exec_nohupped__ "xdg-open" "${file}"
        fi
    done
}
function run() {
    __exec_nohupped__ "${@}"
}

# make starting up kde desktop session easy
function kde() {
    eval "$(grep "^Exec=" /usr/share/wayland-sessions/plasma.desktop | cut -b 6-)"
}

# disable fedora autoinstalling missing commands
unset -f command_not_found_handle

# disable readline arguments
for i in - {0..9}; do
    bind -r "\e$i"
done

# bind to actually clear terminal
bind -x '"\C-l": clear'
