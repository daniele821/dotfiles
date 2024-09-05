#!/bin/env bash

### startup program ###
eval "$(zoxide init --no-cmd bash)"

## startup programs configs ##
function __zoxide_euristically__() {
    cd "$@" &>/dev/null || __zoxide_z "$@" &>/dev/null
}
alias cd='__zoxide_euristically__'
alias ce='zoxide edit'
alias ci='__zoxide_zi'
alias cl='zoxide query -ls'
