#!/bin/env bash

### startup program ###
eval "$(zoxide init --hook none --no-cmd bash)"

## startup programs configs ##
function __zoxide_euristically__() {
    local -r oldpwd="${PWD}"
    if ! cd "$@" &>/dev/null; then
        if (__zoxide_z "$@" &>/dev/null && zoxide add "${PWD}"); then
            __zoxide_z "$@" &>/dev/null
        fi
        [[ "${oldpwd}" != "${PWD}" ]]
    fi
}
function __zoxide_add_paths__() {
    if [[ "$#" -eq 0 ]]; then
        zoxide add "${PWD}"
        return 0
    fi
    for path in "${@}"; do
        path="$(realpath "${path}")"
        if [[ -d "${path}" ]]; then
            zoxide add "${path}"
        fi
    done
    return 0
}
alias cd='__zoxide_euristically__'
alias ca='__zoxide_add_paths__'
alias ce='zoxide edit'
alias ci='__zoxide_zi'
alias cl='zoxide query -ls'
