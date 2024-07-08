#!/bin/env bash

export HISTCONTROL="ignoredups"
export EDITOR="nvim"
export PYTHONDONTWRITEBYTECODE="true"
export GOPATH="$HOME/.go"

alias la='ls -A'
alias lla='ls -lA'
alias ll='ls -l'

function __exec_nohupped__() {
    (: && nohup "${@}" &>/dev/null &)
}
function open() {
    for file in "${@}"; do __exec_nohupped__ "xdg-open" "${file}"; done
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
