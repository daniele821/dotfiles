#!/bin/bash

# shellcheck disable=SC2164,SC2034
function __cleanup_prompt__() {
    \builtin local -r retval="$?"

    # set DISABLE_CLEANUP env var to disable this entire function
    [[ -v DISABLE_CLEANUP ]] && return "$retval"

    # force new line in terminal if previous output doesn't end with a newline
    IFS='[;' read -p $'\e[6n' -d R -rs _ COLUMN LINE _
    [[ "$LINE" -ne "1" ]] && echo

    # force exit from not existing directories
    if ! [[ -d "$PWD" ]]; then
        NEWPWD="$PWD"
        while ! [[ -d "$NEWPWD" ]]; do
            NEWPWD=$(dirname "${NEWPWD}")
        done
        \cd "${NEWPWD}"
    fi

    return "${retval}"
}

# WARNING: DO NOT EXPORT VARIABLES WHEN APPENDING TO THEM -> ELEMENT APPENDED GETS APPENDED TWICE!
#   this is probably because they get appended once whilst logging into the current user, and once
#   when starting a bash process
PROMPT_COMMAND="__cleanup_prompt__;"${PROMPT_COMMAND}

export PS2="> "
