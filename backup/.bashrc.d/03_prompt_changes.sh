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
    ###############################################
    \builtin local workdir="${green}\w "
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
            state="AM"
        fi
        [[ -n "$state" ]] && \builtin local -r gitstate="${yellow}($state) "
        ###############################################
        IFS="" \builtin local -r status="$(git status --porcelain 2>/dev/null)"
        while IFS= read -r line; do
            IFS="" line="${line:0:2}"
            case "$line" in
            # TODO: slowly fix small cases
            "") continue ;;
            "??") \builtin local untracked='?' ;;
            M[MTD\ ] | A[MTD\ ] | D[MTD\ ]) \builtin local staged='+' ;;
            ?M) \builtin local modified='!' ;;
            ?D) \builtin local removed='✘' ;;
            ?U) \builtin local conflicted='=' ;;
            R?) \builtin local renamed='»' ;;
            *) echo "[WARNING] unknow git status: '$line'" ;;
            esac
            \builtin local have_changed=true
        done <<<"$status"
        [[ -f "${GITDIR}/.git/refs/stash" ]] && \builtin local -r stashed='\$'
        # TODO: remote ⇡⇕⇣
        \builtin local -r allstat="${conflicted}${stashed}${removed}${renamed}${modified}${staged}${untracked}${remote}"
        [[ -n "$allstat" ]] && \builtin local -r gitstatus="${red}[${allstat}] "
        [[ "$have_changed" == "true" && -z "$allstat" ]] && \builtin local -r gitstatus="${red}[*] "
    fi
    ###############################################
    \builtin local symbol=""
    case "$retval" in
    0) symbol="${lgreen}❯ " ;;
    *) symbol="${red}❯ " ;;
    esac
    ###############################################
    PS1="${wipe}${workdir}${gitbranch}${gitstate}${gitstatus}${symbol}${wipe}"

    # exit with correct status code
    return "${retval}"
}

# WARNING: DO NOT EXPORT VARIABLES WHEN APPENDING TO THEM -> ELEMENT APPENDED GETS APPENDED TWICE!
#   this is probably because they get appended once whilst logging into the current user, and once
#   when starting a bash process
PROMPT_COMMAND="__cleanup_prompt__;"${PROMPT_COMMAND}
