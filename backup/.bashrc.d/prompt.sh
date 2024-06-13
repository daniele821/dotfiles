#!/bin/env bash

function precmd() {
	builtin local -r RETVAL=$?
	builtin local -r GITBR="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"

	# directory
	PS1="\[\033[01;36m\]\w\[\033[00m\] "

	# git branch
	[[ -n "${GITBR}" ]] && PS1+="\[\033[01;35m\](${GITBR}) "

	# return value
	if [[ "${RETVAL}" == '0' ]]; then
		PS1+='\[\033[01;32m\]'
	else
		PS1+='\[\033[01;31m\]'
	fi
	PS1+='$ \[\033[0m\]'
	return "${RETVAL}"
}

PROMPT_COMMAND='precmd'
PROMPT_DIRTRIM=3
