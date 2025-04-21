#!/bin/bash

function __cleanup_prompt__() {
    \builtin local -r retval="$?"

    # force new line in terminal if previous output doesn't end with a newline
    ## UNCOMMENT: FLUSHES STDIN -> DOES NOT ALLOW TO WRITE WHILE PREVIOUS COMMAND IS STILL RUNNING
    # IFS='[;' read -p $'\e[6n' -d R -rs _ COLUMN LINE _
    # [[ "$LINE" -ne "1" ]] && echo

    # force exit from not existing directories ##########################
    if ! [[ -d "$PWD" ]]; then
        NEWPWD="$PWD"
        while ! [[ -d "$NEWPWD" ]]; do
            NEWPWD=$(dirname "${NEWPWD}")
        done
        \cd "${NEWPWD}" || exit 1
    fi

    # change PS1 ########################################################
    \builtin local -r red="\[\e[1;31m\]"
    \builtin local -r lgreen="\[\e[1;32m\]"
    \builtin local -r yellow="\[\e[1;33m\]"
    \builtin local -r lblue="\[\e[1;34m\]"
    \builtin local -r purple="\[\e[1;35m\]"
    \builtin local -r green="\[\e[1;36m\]"
    \builtin local -r wipe="\[\e[0m\]"
    #####################################################################
    \builtin local workdir=""
    workdir="${green}\w "
    #####################################################################
    \builtin local -r hasdiff="$(git status -s 2>/dev/null | wc -w)"
    \builtin local -r hash="$(git rev-parse --short=8 HEAD 2>/dev/null)"
    \builtin local -r branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    \builtin local gitst=""
    [[ "$hasdiff" != 0 ]] && gitst="${red}*"
    \builtin local gitbranch=""
    case "$branch" in
    "") ;;
    "HEAD") gitbranch="${purple}(${hash})${gitst} " ;;
    *) gitbranch="${purple}(${branch})${gitst} " ;;
    esac
    #####################################################################
    \builtin local -r amount_jobs="$(jobs -p | wc -l)"
    \builtin local jobs=""
    case "$amount_jobs" in
    0) jobs="" ;;
    1) jobs="${lblue}✦ " ;;
    *) jobs="${lblue}${amount_jobs}✦ " ;;
    esac
    #####################################################################
    \builtin local symbol=""
    case "$retval" in
    0) symbol="${lgreen}❯ " ;;
    *) symbol="${red}❯ " ;;
    esac
    #####################################################################
    PS1="${wipe}${workdir}${gitbranch}${jobs}${symbol}${wipe}"

    # exit ##############################################################
    return "${retval}"
}

# WARNING: DO NOT EXPORT VARIABLES WHEN APPENDING TO THEM -> ELEMENT APPENDED GETS APPENDED TWICE!
#   this is probably because they get appended once whilst logging into the current user, and once
#   when starting a bash process
PROMPT_COMMAND="__cleanup_prompt__;"${PROMPT_COMMAND}
