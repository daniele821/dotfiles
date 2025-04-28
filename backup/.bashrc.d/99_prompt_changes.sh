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
    \builtin local ssh_conn=""
    if [[ -n "$SSH_CONNECTION" ]]; then
        \builtin local -r ssh_ip="$(echo "$SSH_CONNECTION" | awk '{print $3}')"
        # \builtin local -r ssh_server="$(dig -x "$ssh_ip" +short | head -1 | sed 's/\.$//')"
        ssh_conn="${red}󰖟 ${ssh_ip} "
    fi
    #####################################################################
    \builtin local workdir="${green}\w "
    #####################################################################
    \builtin local -r hasdiff="$(git status -s 2>/dev/null | wc -w)"
    \builtin local -r ahead="$(git rev-list --count '@{u}..HEAD' 2>/dev/null)"
    \builtin local -r behind="$(git rev-list --count 'HEAD..@{u}' 2>/dev/null)"
    \builtin local -r hash="$(git rev-parse --short=8 HEAD 2>/dev/null)"
    \builtin local -r branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    \builtin local gitst=""
    [[ "$hasdiff" != 0 ]] && gitst="*"
    \builtin local remote=""
    [[ "$ahead" -eq 0 && "$behind" -gt 0 ]] && remote="↓"
    [[ "$ahead" -gt 0 && "$behind" -eq 0 ]] && remote="↑"
    [[ "$ahead" -gt 0 && "$behind" -gt 0 ]] && remote="↕"
    \builtin local gitbranch=""
    \builtin local -r info="${red}${gitst}${remote}"
    case "$branch" in
    "") ;;
    "HEAD")
        case "$hash" in
        "") gitbranch="${purple}(...)${info} " ;; # empty repo (ie: no commits, yet!)
        *) gitbranch="${purple}(${hash})${info} " ;;
        esac
        ;;
    *) gitbranch="${purple}(${branch})${info} " ;;
    esac
    #####################################################################
    \builtin local -r running_jobs="$(jobs -rp | wc -l)"
    \builtin local -r stopped_jobs="$(jobs -sp | wc -l)"
    \builtin local -r amount_jobs="$((running_jobs + stopped_jobs))"
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
    PS1="${wipe}${ssh_conn}${workdir}${gitbranch}${jobs}${symbol}${wipe}"

    # exit ##############################################################
    return "${retval}"
}

# WARNING: DO NOT EXPORT VARIABLES WHEN APPENDING TO THEM -> ELEMENT APPENDED GETS APPENDED TWICE!
#   this is probably because they get appended once whilst logging into the current user, and once
#   when starting a bash process
PROMPT_COMMAND="__cleanup_prompt__;"${PROMPT_COMMAND}
