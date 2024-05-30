#!/bin/env bash

export HISTCONTROL=ignoredups
export PYTHONDONTWRITEBYTECODE="true"

alias la='ls -a'
alias lla='ls -la'
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

unset -f command_not_found_handle
