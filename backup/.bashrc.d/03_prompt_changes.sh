#!/bin/bash

function __cleanup_prompt__() {
    \builtin local -r retval="$?"

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
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        \builtin local -r hasdiff="$(git status -s 2>/dev/null | wc -w)"
        \builtin local -r untracked="$([[ -n "$(git ls-files --others --exclude-standard)" ]] && echo '?')"
        \builtin local -r staged="$(git diff --cached --quiet || echo '+')"
        \builtin local -r modified="$(git diff --quiet --diff-filter=M || echo '!')"
        \builtin local -r deleted="$(git diff --quiet --diff-filter=D || echo '✘')"
        \builtin local -r conflicts="$(git diff --quiet --diff-filter=U || echo '=')"
        \builtin local -r stashed="$(git rev-parse --verify --quiet refs/stash &>/dev/null && echo '$')"
        \builtin local -r ahead="$(git rev-list --count '@{u}..HEAD')"
        \builtin local -r behind="$(git rev-list --count 'HEAD..@{u}')"
        \builtin local -r hash="$(git rev-parse --short=8 HEAD)"
        \builtin local -r branch="$(git rev-parse --abbrev-ref HEAD)"
        \builtin local remote=""
        [[ "$ahead" -eq 0 && "$behind" -gt 0 ]] && remote="⇣"
        [[ "$ahead" -gt 0 && "$behind" -eq 0 ]] && remote="⇡"
        [[ "$ahead" -gt 0 && "$behind" -gt 0 ]] && remote="⇕"
        \builtin local info=""
        if [[ "$hasdiff" != 0 || -n "$stashed" || -n "$remote" ]]; then
            info="${red} [${conflicts}${stashed}${deleted}${modified}${staged}${untracked}${remote}]"
        fi
        \builtin local gitbranch=""
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
    fi
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
