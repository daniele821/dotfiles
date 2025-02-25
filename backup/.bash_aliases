#!/bin/bash

export EDITOR="nvim"
export PYTHONDONTWRITEBYTECODE="true"
export GOPATH="$HOME/.local/share/go"

alias cat='batcat'
alias ls='lsd --group-dirs first'
alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lA'
alias clear='printf "\033[2J\033[3J\033[1;1H"'

function tree() {
    timeout 0.2 lsd --group-dirs first --tree "$@" &>/dev/null
    if [[ $? -ne "124" ]]; then
        lsd --group-dirs first --tree "$@"
    else
        /usr/bin/tree "$@"
    fi 2>/dev/null
}

# init various
eval "$(direnv hook bash)"
eval "$(zoxide init bash)"
export STARSHIP_LOG=error
export starship_precmd_user_func="blastoff"
eval "$(starship init bash)"
function blastoff() {
    git status -s &>/dev/null
}

# runner and launcher functions
function run() {
    (: && nohup "$@" &>/dev/null &)
}
function open() {
    [[ "${#@}" -eq "0" ]] && return 0
    pdfs=()
    dirs=()
    videos=()
    others=()
    for file in "${@}"; do
        type="$(xdg-mime query filetype "${file}" 2>/dev/null)"
        case "$type" in
        application/pdf) pdfs+=("$file") ;;
        inode/directory) dirs+=("$file") ;;
        video/*) videos+=("$file") ;;
        *) others+=("$file") ;;
        esac &>/dev/null
    done
    if command -v okular &>/dev/null; then
        [[ "${#pdfs[@]}" -gt 0 ]] && run okular "${pdfs[@]}"
    else
        others+=("${pdfs[@]}")
    fi
    if command -v dolphin &>/dev/null; then
        [[ "${#dirs[@]}" -gt 0 ]] && run dolphin "${dirs[@]}"
    else
        others+=("${dirs[@]}")
    fi
    if command -v mpv &>/dev/null; then
        [[ "${#videos[@]}" -gt 0 ]] && run mpv "${videos[@]}"
    else
        others+=("${videos[@]}")
    fi
    for file in "${others[@]}"; do
        run xdg-open "$file"
    done
}

# fix bash prompt
function __cleanup_prompt__() {
    \builtin local -r retval="$?"
    # force exit from not existing directories
    if ! [[ -d "$PWD" ]]; then
        NEWPWD="$PWD"
        while ! [[ -d "$NEWPWD" ]]; do
            NEWPWD=$(dirname "${NEWPWD}")
        done
        \cd "${NEWPWD}" || exit 1
    fi

    return "${retval}"
}
PROMPT_COMMAND="__cleanup_prompt__;"${PROMPT_COMMAND}

# fix bash shortcuts
if [[ $- == *i* ]]; then
    for i in - {0..9}; do bind -r "\e$i"; done
    bind -x '"\C-l": clear'
fi
