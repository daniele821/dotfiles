#!/bin/bash

# shellcheck disable=SC2164,SC2034
function __cleanup_prompt__() {
    \builtin local -r retval="$?"

    # force new line in terminal if previous output doesn't end with a newline
    ## UNCOMMENT: FLUSHES STDIN -> DOES NOT ALLOW TO WRITE WHILE PREVIOUS COMMAND IS STILL RUNNING
    # IFS='[;' read -p $'\e[6n' -d R -rs _ COLUMN LINE _
    # [[ "$LINE" -ne "1" ]] && echo

    # force exit from not existing directories
    if ! [[ -d "$PWD" ]]; then
        NEWPWD="$PWD"
        while ! [[ -d "$NEWPWD" ]]; do
            NEWPWD=$(dirname "${NEWPWD}")
        done
        \cd "${NEWPWD}"
    fi

    # change PS1
    \builtin local color=31
    if [[ $retval == 0 ]]; then
        color=32
    fi
    \builtin local branch=""
    branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    [[ "$branch" == "HEAD" ]] && branch="$(git rev-parse --short=8 HEAD)"
    [[ -n "$branch" ]] && branch="\[\e[1;35m\] ($branch)"
    PS1="\[\e[0;1;36m\]\w$branch \[\e[1;${color}m\]❯ \[\e[0m\]"

    return "${retval}"
}

# WARNING: DO NOT EXPORT VARIABLES WHEN APPENDING TO THEM -> ELEMENT APPENDED GETS APPENDED TWICE!
#   this is probably because they get appended once whilst logging into the current user, and once
#   when starting a bash process
PROMPT_COMMAND="__cleanup_prompt__;"${PROMPT_COMMAND}
