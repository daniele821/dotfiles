#!/bin/bash

export EDITOR="nvim"
export PYTHONDONTWRITEBYTECODE="true"
export GOPATH="$HOME/.local/share/go"

function __exec_nohupped__() {
    (: && nohup "$@" &>/dev/null &)
}
function run() {
    __exec_nohupped__ "$@"
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
        [[ "${#pdfs[@]}" -gt 0 ]] && __exec_nohupped__ okular "${pdfs[@]}"
    else
        others+=("${pdfs[@]}")
    fi
    if command -v dolphin &>/dev/null; then
        [[ "${#dirs[@]}" -gt 0 ]] && __exec_nohupped__ dolphin "${dirs[@]}"
    else
        others+=("${dirs[@]}")
    fi
    if command -v mpv &>/dev/null; then
        [[ "${#videos[@]}" -gt 0 ]] && __exec_nohupped__ mpv "${videos[@]}"
    else
        others+=("${videos[@]}")
    fi
    for file in "${others[@]}"; do
        __exec_nohupped__ xdg-open "$file"
    done
}
function custom_pager() {
    printf '\e[?1049h'
    "$@"
    printf '\e[?25l'
    read -rn 1
    clear
    printf '\e[?1049l\e[?25h'
}
function preview() {
    [[ "$FPREVIEW" == "true" ]] && FULLSCREEN="--scale-up"
    [[ "$FPREVIEW" == "true" ]] || FULLSCREEN=""
    local -r oldPwd="$PWD"
    FILE="${1}"
    [[ -d "${FILE}" ]] && ! cd "${1}" &>/dev/null && return 1
    if [[ $# == 0 || -d "$FILE" ]]; then
        FILE="$(
            {
                wl-paste --list-types 2>/dev/null | grep image -q &>/dev/null && echo clipboard-image
                find . -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' \) 2>/dev/null | cut -b 3-
            } | fzf --exit-0 --select-1 --height=40% --layout=reverse --border
        )"
    fi
    if [[ "$(xdg-mime query filetype "${FILE}" 2>/dev/null)" =~ "image/" ]]; then
        custom_pager kitten icat --align=center --place "$(tput cols)"x"$(tput lines)"@0x0 "${FULLSCREEN}" "${FILE}"
    elif [[ "$FILE" == "clipboard-image" ]]; then
        custom_pager wl-paste | kitten icat --align=left --place "$(tput cols)"x"$(tput lines)"@0x0 "${FULLSCREEN}"
    fi
    cd "${oldPwd}" &>/dev/null || return 1
}
function fpreview() {
    FPREVIEW="true" preview "${@}"
}
function copy() {
    cat "$@" | wl-copy
}
function safe-update() {
    UPDATES="$(sudo dnf check-update 2>/dev/tty)"
    UPDATES_COUNT="$(echo "$UPDATES" | wc -l)"
    if [[ -n "$(echo "$UPDATES" | xargs)" ]]; then
        echo "the following packages can be updated:"
        echo "$UPDATES"
        echo -n "Do you really want to proceed with the update ($UPDATES_COUNT packages)? "
        read -r answer
        if [[ "${answer,,}" == "y" ]]; then
            sudo dnf --assumeyes offline-upgrade download
            sudo dnf --assumeyes offline-upgrade reboot
        fi
    else
        echo 'no updates available'
    fi
}

complete -W "save sa restore re saveall restoreall commit co uncommit un untracked init purge edit run help" autosaver
complete -c run
complete -f copy

alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lA'
alias clear='printf "\033[2J\033[3J\033[1;1H"'

unset command_not_found_handle
if [[ $- == *i* ]]; then
    for i in - {0..9}; do bind -r "\e$i"; done
    bind -x '"\C-l": clear'
fi
