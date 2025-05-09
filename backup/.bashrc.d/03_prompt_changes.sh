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
        \builtin local -r gitdir="$(git rev-parse --show-toplevel)"
        \builtin local -r git_status="$(git status --porcelain 2>/dev/null)"
        \builtin local -r hasdiff="$([[ -n "$git_status" ]] && echo "${#git_status}" | xargs)"
        \builtin local -r untracked="$([[ "$git_status" =~ \?\? ]] && echo '?')"
        \builtin local -r staged="$([[ "$git_status" =~ ^[ADMR] ]] && echo '+')"
        \builtin local -r modified="$([[ "$git_status" =~ ^.M ]] && echo '!')"
        \builtin local -r deleted="$([[ "$git_status" =~ ^.D ]] && echo '✘')"
        \builtin local -r conflicts="$([[ "$git_status" =~ ^.U ]] && echo '=')"
        \builtin local -r stashed=$([[ -f "${gitdir}/.git/refs/stash" ]] && echo '\$')
        \builtin local -r ahead="$(git rev-list --count '@{u}..HEAD' 2>/dev/null)"
        \builtin local -r behind="$(git rev-list --count 'HEAD..@{u}' 2>/dev/null)"
        \builtin local -r hash="$(git rev-parse --short=8 HEAD)"
        \builtin local -r branch="$(git rev-parse --abbrev-ref HEAD)"
        \builtin local remote=""
        [[ "$ahead" -eq 0 && "$behind" -gt 0 ]] && remote="⇣"
        [[ "$ahead" -gt 0 && "$behind" -eq 0 ]] && remote="⇡"
        [[ "$ahead" -gt 0 && "$behind" -gt 0 ]] && remote="⇕"
        \builtin local info=""
        if [[ -n "$hasdiff" || -n "$stashed" || -n "$remote" ]]; then
            info="${red}[${conflicts}${stashed}${deleted}${modified}${staged}${untracked}${remote}] "
        fi
        \builtin local commit=""
        case "$branch" in
        "HEAD")
            case "$hash" in
            "") commit="${purple}(...)" ;; # empty repo (ie: no commits, yet!)
            *) commit="${purple}(${hash})" ;;
            esac
            ;;
        *) commit="${purple}(${branch})" ;;
        esac
        [[ -n "$commit" ]] && commit+=" "
        \builtin local state=""
        if [[ -f "$gitdir/.git/MERGE_HEAD" ]]; then
            state="MERGING"
        elif [[ -f "$gitdir/.git/CHERRY_PICK_HEAD" ]]; then
            state="CHERRY-PICKING"
        elif [[ -f "$gitdir/.git/REVERT_HEAD" ]]; then
            state="REVERTING"
        elif [[ -f "$gitdir/.git/BISECT_START" ]]; then
            state="BISECTING"
        elif [[ -d "$gitdir/.git/rebase-merge" ]]; then
            state="REBASING"
        elif [[ -d "$gitdir/.git/rebase-apply" ]]; then
            state="AM"
        fi
        [[ -n "$state" ]] && state="${yellow}($state) "
        \builtin local -r gitbranch="${commit}${state}${info}"
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
