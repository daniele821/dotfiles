#!/bin/bash

alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lA'

eval "$(starship init bash)"

eval "$(zoxide init bash)"

PATH="$HOME/.local/bin:$PATH"
