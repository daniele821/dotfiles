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
    \builtin local -r red="\[\e[1;31m\]"
    \builtin local -r lgreen="\[\e[1;32m\]"
    \builtin local -r yellow="\[\e[1;33m\]"
    \builtin local -r lblue="\[\e[1;34m\]"
    \builtin local -r purple="\[\e[1;35m\]"
    \builtin local -r green="\[\e[1;36m\]"
    \builtin local -r wipe="\[\e[0m\]"
    \builtin local color="$red"
    [[ $retval == 0 ]] && color="$lgreen"
    \builtin local gitst=""
    [[ "$(git status -s 2>/dev/null | wc -w)" != 0 ]] && gitst="${red}*"
    \builtin local branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    [[ "$branch" == "HEAD" ]] && branch="$(git rev-parse --short=8 HEAD)"
    [[ -n "$branch" ]] && branch="${purple} ($branch)"
    PS1="${green}\w${branch}${gitst} ${color}❯ ${wipe}"

    return "${retval}"
}

# WARNING: DO NOT EXPORT VARIABLES WHEN APPENDING TO THEM -> ELEMENT APPENDED GETS APPENDED TWICE!
#   this is probably because they get appended once whilst logging into the current user, and once
#   when starting a bash process
PROMPT_COMMAND="__cleanup_prompt__;"${PROMPT_COMMAND}
