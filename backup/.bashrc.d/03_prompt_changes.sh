#!/bin/bash

function __cleanup_prompt__() {
    \builtin local -r retval="$?"

    # force exit from not existing directories
    until [[ -d "$PWD" ]]; do PWD="$(dirname "$PWD")"; done

    # change PS1
    \builtin local -r red="\[\e[1;31m\]"
    \builtin local -r lgreen="\[\e[1;32m\]"
    \builtin local -r yellow="\[\e[1;33m\]"
    \builtin local -r lblue="\[\e[1;34m\]"
    \builtin local -r purple="\[\e[1;35m\]"
    \builtin local -r green="\[\e[1;36m\]"
    \builtin local -r wipe="\[\e[0m\]"
    \builtin local workdir="${green}\w "
    \builtin local -r branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    \builtin local gitbranch=""
    case "$branch" in
    "") ;;
    "HEAD") gitbranch="${purple}($(git rev-parse --short=8 HEAD 2>/dev/null)) " ;;
    *) gitbranch="${purple}(${branch}) " ;;
    esac
    \builtin local -r amount_jobs="$(jobs | grep -vc Done)"
    \builtin local jobs=""
    case "$amount_jobs" in
    0) jobs="" ;;
    1) jobs="${lblue}✦ " ;;
    *) jobs="${lblue}${amount_jobs}✦ " ;;
    esac
    \builtin local symbol=""
    case "$retval" in
    0) symbol="${lgreen}❯ " ;;
    *) symbol="${red}❯ " ;;
    esac
    PS1="${wipe}${workdir}${gitbranch}${jobs}${symbol}${wipe}"

    # exit with correct status code
    return "${retval}"
}

# WARNING: DO NOT EXPORT VARIABLES WHEN APPENDING TO THEM -> ELEMENT APPENDED GETS APPENDED TWICE!
#   this is probably because they get appended once whilst logging into the current user, and once
#   when starting a bash process
PROMPT_COMMAND="__cleanup_prompt__;"${PROMPT_COMMAND}
