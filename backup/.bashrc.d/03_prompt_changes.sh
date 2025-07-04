#!/bin/bash

function __cleanup_prompt__() {
    \builtin local -r retval="$?"

    # force exit from not existing directories
    TMPOLD=$OLDPWD
    TMPPWD="$PWD"
    until [[ -d "$TMPPWD" ]]; do TMPPWD="$(dirname "$TMPPWD")"; done
    cd "$TMPPWD"
    OLDPWD="$TMPOLD"

    # change PS1
    \builtin local -r red="\[\e[1;31m\]"
    \builtin local -r lgreen="\[\e[1;32m\]"
    \builtin local -r yellow="\[\e[1;33m\]"
    \builtin local -r lblue="\[\e[1;34m\]"
    \builtin local -r purple="\[\e[1;35m\]"
    \builtin local -r green="\[\e[1;36m\]"
    \builtin local -r wipe="\[\e[0m\]"
    ###############################################
    \builtin local -r workdir="${green}\w "
    ###############################################
    \builtin local pyvenv=""
    [[ -n "$VIRTUAL_ENV" ]] && pyvenv="${yellow}(venv) "
    ###############################################
    \builtin local branch=""
    GITDIR="$PWD"
    until [[ -z "$GITDIR" || -d "$GITDIR/.git" ]]; do GITDIR="${GITDIR%/*}"; done
    if [[ -d "$GITDIR/.git" ]]; then
        read -r file <"$GITDIR/.git/HEAD"
        case "$file" in
        ref:*) branch="${file##*/}" ;;
        *) branch="${file:0:8}" ;;
        esac
        \builtin local -r gitbranch="${purple}(${branch}) "
        ###############################################
        \builtin local state=""
        if [[ -f "$GITDIR/.git/MERGE_HEAD" ]]; then
            state="MERGING"
        elif [[ -f "$GITDIR/.git/CHERRY_PICK_HEAD" ]]; then
            state="CHERRY-PICKING"
        elif [[ -f "$GITDIR/.git/REVERT_HEAD" ]]; then
            state="REVERTING"
        elif [[ -f "$GITDIR/.git/BISECT_START" ]]; then
            state="BISECTING"
        elif [[ -d "$GITDIR/.git/rebase-merge" ]]; then
            state="REBASING"
        elif [[ -d "$GITDIR/.git/rebase-apply" ]]; then
            if [[ -f "$GITDIR/.git/AM_HEAD" ]]; then
                state="AM"
            else
                state="AM/REBASE"
            fi
        elif [[ -f "$GITDIR/.git/REBASE_HEAD" ]]; then
            state="REBASING"
        elif [[ -f "$GITDIR/.git/AM_HEAD" ]]; then
            state="AM"
        fi
        [[ -n "$state" ]] && \builtin local -r gitstate="${yellow}($state) "
        ###############################################
        IFS="" \builtin local -r _status="$(git status --porcelain 2>/dev/null)"
        while IFS= read -r line; do
            case "${line:0:2}" in
            "") continue ;;
            "??") \builtin local untracked='?' ;;
            "DD" | "AA" | *U*) \builtin local conflicted='=' ;;
            *)
                case "${line:0:1}" in
                " ") ;;
                M | T | A | D) \builtin local staged='+' ;;
                R) \builtin local renamed='»' ;;
                *) \builtin local others='*' ;;
                esac
                case "${line:1:1}" in
                " ") ;;
                M | T) \builtin local modified='!' ;;
                D) \builtin local removed='✘' ;;
                *) \builtin local others='*' ;;
                esac
                ;;
            esac
        done <<<"$_status"
        [[ -f "${GITDIR}/.git/refs/stash" ]] && \builtin local -r stashed='\$'
        \builtin local -r diff="$(git rev-list --left-right --count '@{u}...HEAD' 2>/dev/null)"
        \builtin local -r ahead="${diff##*$'\t'}"
        \builtin local -r behind="${diff%%$'\t'*}"
        \builtin local remote=""
        [[ "$ahead" -eq 0 && "$behind" -gt 0 ]] && remote="⇣"
        [[ "$ahead" -gt 0 && "$behind" -eq 0 ]] && remote="⇡"
        [[ "$ahead" -gt 0 && "$behind" -gt 0 ]] && remote="⇕"
        \builtin local -r allstat="${conflicted}${stashed}${renamed}${staged}${removed}${modified}${others}${untracked}${remote}"
        [[ -n "$allstat" ]] && \builtin local -r gitstatus="${red}[${allstat}] "
    fi
    ###############################################
    \builtin local status=
    [[ "$retval" -ne 0 ]] && status="${red}❌${retval} "
    ###############################################
    \builtin local symbol=""
    case "$retval" in
    0) symbol="${lgreen}❯ " ;;
    *) symbol="${red}❯ " ;;
    esac
    ###############################################
    PS1="${wipe}${workdir}${pyvenv}${gitbranch}${gitstate}${gitstatus}${status}${symbol}${wipe}"

    # exit with correct status code
    return "${retval}"
}

# WARNING: DO NOT EXPORT VARIABLES WHEN APPENDING TO THEM -> ELEMENT APPENDED GETS APPENDED TWICE!
#   this is probably because they get appended once whilst logging into the current user, and once
#   when starting a bash process
PROMPT_COMMAND="__cleanup_prompt__;"${PROMPT_COMMAND}
