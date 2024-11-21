#!/bin/bash

export STARSHIP_LOG=error
export starship_precmd_user_func="blastoff"

eval "$(starship init bash)"

function blastoff() {
    git status -s &>/dev/null
}

export PS2="> "
