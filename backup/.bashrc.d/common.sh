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
    if command -v kde-open &>/dev/null; then
        for file in "${@}"; do __exec_nohupped__ "kde-open" "${file}"; done
    else
        for file in "${@}"; do __exec_nohupped__ "xdg-open" "${file}"; done
    fi
}
function run() {
    __exec_nohupped__ "${@}"
}

# disable fedora autoinstalling missing commands
unset -f command_not_found_handle

# disable readline arguments
for i in - {0..9}; do
    bind -r "\e$i"
done

# bind to actually clear terminal
bind -x '"\C-l": clear'
