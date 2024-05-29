#!/bin/env bash

## various fixes ##
function blastoff() {
	git status -s &>/dev/null
}
export starship_precmd_user_func="blastoff"
export STARSHIP_LOG=error

## startup program ##
eval "$(starship init bash)"
