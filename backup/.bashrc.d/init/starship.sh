#!/bin/bash

export STARSHIP_LOG=error
export starship_precmd_user_func="blastoff"

function blastoff() {
    git status -s &>/dev/null
}

eval "$(starship init bash)"
