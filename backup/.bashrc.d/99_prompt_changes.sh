#!/bin/bash

function __cleanup_prompt__() {
    \builtin local -r retval="$?"
    # set DISABLE_CLEANUP env var to disable this entire function
    [[ -v DISABLE_CLEANUP ]] && return "$retval"
    # force new line in terminal if previous output doesn't end with a newline
    IFS='[;' read -p $'\e[6n' -d R -rs _ COLUMN LINE _
    [[ "$LINE" -ne "1" ]] && echo
    return "${retval}"
}

[[ -n "${PROMPT_COMMAND}" ]] && export PROMPT_COMMAND+=";"
export PROMPT_COMMAND+="__cleanup_prompt__"

export PS2="> "
