#!/bin/env bash

function precmd() {
	builtin local -r __retval__=$?
	PS1="\[\033[01;36m\]\w\[\033[00m\] "
	if [[ "${__retval__}" == '0' ]]; then
		PS1+='\[\033[01;32m\]'
	else
		PS1+='\[\033[01;31m\]'
	fi
	PS1+='$ \[\033[0m\]'
	return "${__retval__}"
}

PROMPT_COMMAND='precmd'
