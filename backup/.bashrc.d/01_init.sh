#!/bin/bash

# bat init
alias cat='bat'

# lsd init
function tree() {
    timeout 0.2 lsd --group-dirs first --tree "$@" &>/dev/null
    if [[ $? -ne "124" ]]; then
        lsd --group-dirs first --tree "$@"
    else
        /usr/bin/tree "$@"
    fi 2>/dev/null
}
alias ls='lsd --group-dirs first'

# zoxide init
export _ZO_EXCLUDE_DIRS="$HOME:$HOME/.local*:$HOME/.cache*:/afs*:/bin*:/boot*:/dev*:/etc*:/lib*:/lib64*:/media*:/mnt*:/opt*:/proc*:/run*:/sbin*:/srv*:/sys*:/tmp*:/usr*:/var*:/"
eval "$(zoxide init bash)"
