#!/bin/env bash

set -e

[[ "$(id -u)" -eq 0 ]] && echo 'do not run this script as root!' && exit 1

# clone missing git repos and set the email
GIT_DATA=(
    "git@daniele821.github.com:daniele821/dotfiles.git"
    "/personal/repos/daniele821/dotfiles"
    "danixgithub1@gmail.com"
    "fedora-kde"

    "git@daniele821.github.com:daniele821/daniele821.github.io.git"
    "/personal/repos/daniele821/github-website"
    "danixgithub1@gmail.com"
    ""

    "git@daniele821.github.com:daniele821/nvim-config.git"
    "/personal/repos/daniele821/nvim-config"
    "danixgithub1@gmail.com"
    ""

    "git@daniele821.github.com:daniele821/ricette.git"
    "/personal/repos/daniele821/ricette"
    "danixgithub1@gmail.com"
    ""

    "git@daniele821.github.com:daniele821/scripts.git"
    "/personal/repos/daniele821/scripts"
    "danixgithub1@gmail.com"
    ""

    "git@danix1234.github.com:danix1234/unibo-2a.git"
    "/personal/repos/danix1234/unibo-2a"
    "daniele.muffato@studio.unibo.it"
    ""

    "git@danix1234.github.com:danix1234/unibo-2b.git"
    "/personal/repos/danix1234/unibo-2b"
    "daniele.muffato@studio.unibo.it"
    ""

    "git@danix1234.github.com:danix1234/unibo-3a.git"
    "/personal/repos/danix1234/unibo-3a"
    "daniele.muffato@studio.unibo.it"
    ""

    "git@danix1234.github.com:danix1234/unibo-3b.git"
    "/personal/repos/danix1234/unibo-3b"
    "daniele.muffato@studio.unibo.it"
    ""

    "git@danix1234.github.com:danix1234/unibo.git"
    "/personal/repos/danix1234/unibo"
    "daniele.muffato@studio.unibo.it"
    ""

    "git@danix1234.github.com:danix1234/tesi_CRYPTO_2025.git"
    "/personal/repos/danix1234/tesi_CRYPTO_2025"
    "daniele.muffato@studio.unibo.it"
    ""
)

# downloading repo and running operations on it
function download_repo() {
    git_url="$1"
    git_repo="$2"
    git_email="$3"
    git_branch="$4"
    echo -en "cloning \e[32m$git_url\e[m into \e[33m$git_repo\e[m, email: \e[34m$git_email\e[m"
    [[ -n "$git_branch" ]] && echo -en ", branch: \e[35m$git_branch\e[m"
    echo
    git clone -c color.ui=always --progress --recurse-submodules "$git_url" "$git_repo"
    git -C "$git_repo" config user.email "$git_email"
    [[ -n "$git_branch" ]] && git -C "$git_repo" switch "$git_branch" -q

    # additional operations done ONLY when repo gets downloaded
    case "$git_repo" in
    "/personal/repos/daniele821/dotfiles")
        # set valid branch for script
        echo -e "\e[1;34msetting ${git_branch} as the valid branch\e[m"
        echo "$git_branch" >"${git_repo}/.branch"
        ;;
    "/personal/repos/daniele821/nvim-config")
        # link nvim config repo to ~/.config/nvim
        FROM_DIR="$git_repo"
        TO_DIR="$HOME/.config/nvim"
        if [[ "$(readlink "$TO_DIR")" != "$FROM_DIR" ]]; then
            echo -e "\e[1;34mlinking $TO_DIR to $FROM_DIR\e[m"
            rm -rf "$TO_DIR"
            ln -s "$FROM_DIR" "$TO_DIR"
        fi
        # automagically minitialize neovim with all goodies
        tput rmam
        OUTPUT=false
        nvim --headless '+StarterPackLsp' '+StarterPackParsers' +qa 2>&1 | while read -r line; do
            if [[ "$OUTPUT" == "false" ]]; then
                echo -e "\e[1;34minitializing neovim...\e[m"
                OUTPUT=true
            fi
            echo -ne "\r\e[2K"
            echo -n "$line"
        done
        tput smam
        echo -ne "\r\e[2K"
        ;;
    esac
}

# if interrupted, end execution and clean up anyway
TMP_FILES=()
CLONEPIDS=()
function cleanup() {
    for ((i = 0; i < ${#CLONEPIDS[@]}; i++)); do
        echo -n "$((i + 1))/${#CLONEPIDS[@]}: "
        tail -n +0 -f "${TMP_FILES[$i]}" --pid="${CLONEPIDS[$i]}"
        rm "${TMP_FILES[$i]}"
    done
}
trap cleanup SIGINT

# if early exit, only clean up
TMP_DIR="$(mktemp -d)"
function cleanup_on_exit() {
    rm -rf "$TMP_DIR"
}
trap cleanup_on_exit EXIT

# speed up the downloads, by running them in parallel
# NOTE: this require ssh to not prompt to accept new key (can be set in .ssh/config)
for ((i = 0; i < "${#GIT_DATA[@]}"; i += 4)); do
    git_url="${GIT_DATA[$i]}"
    git_repo="${GIT_DATA[$((i + 1))]}"
    git_email="${GIT_DATA[$((i + 2))]}"
    git_branch="${GIT_DATA[$((i + 3))]}"
    if [[ ! -e "$git_repo" ]]; then
        TMP_FILE="$(mktemp "${TMP_DIR}/XXXXXXXXXXXX.out")"
        download_repo "$git_url" "$git_repo" "$git_email" "$git_branch" &>"$TMP_FILE" &
        CLONEPIDS+=("$!")
        TMP_FILES+=("$TMP_FILE")
    fi
done
cleanup

exit 0
