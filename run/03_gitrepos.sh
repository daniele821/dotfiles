#!/bin/env bash

set -e

[[ "$(id -u)" -eq 0 ]] && echo 'do not run this script as root!' && exit 1

# clone missing git repos and set the email
GIT_DATA=(
    "git@daniele821.github.com:daniele821/dotfiles.git"
    "/personal/repos/daniele821/dotfiles"
    "danixgithub1@gmail.com"

    "git@daniele821.github.com:daniele821/daniele821.github.io.git"
    "/personal/repos/daniele821/github-website"
    "danixgithub1@gmail.com"

    "git@daniele821.github.com:daniele821/nvim-config.git"
    "/personal/repos/daniele821/nvim-config"
    "danixgithub1@gmail.com"

    "git@daniele821.github.com:daniele821/ricette.git"
    "/personal/repos/daniele821/ricette"
    "danixgithub1@gmail.com"

    "git@danix1234.github.com:danix1234/unibo-2a.git"
    "/personal/repos/danix1234/unibo-2a"
    "daniele.muffato@studio.unibo.it"

    "git@danix1234.github.com:danix1234/unibo-2b.git"
    "/personal/repos/danix1234/unibo-2b"
    "daniele.muffato@studio.unibo.it"

    "git@danix1234.github.com:danix1234/unibo-3a.git"
    "/personal/repos/danix1234/unibo-3a"
    "daniele.muffato@studio.unibo.it"

    "git@danix1234.github.com:danix1234/unibo-3b.git"
    "/personal/repos/danix1234/unibo-3b"
    "daniele.muffato@studio.unibo.it"

    "git@danix1234.github.com:danix1234/unibo.git"
    "/personal/repos/danix1234/unibo"
    "daniele.muffato@studio.unibo.it"

    "git@danix1234.github.com:danix1234/tesi_CRYPTO_2025.git"
    "/personal/repos/danix1234/tesi_CRYPTO_2025"
    "daniele.muffato@studio.unibo.it"
)

# downloading repo and running operations on it
function download_repo() {
    git_url="$1"
    git_repo="$2"
    git_email="$3"
    echo -e "cloning \e[32m$git_url\e[m into \e[33m$git_repo\e[m, email: \e[34m$git_email\e[m"
    git clone -c color.ui=always --progress --recurse-submodules "$git_url" "$git_repo"
    git -C "$git_repo" config user.email "$git_email"

    # additional operations done ONLY when repo gets downloaded
    case "$git_repo" in
    "/personal/repos/daniele821/dotfiles")
        NEW_BRANCH="fedora-kde"
        echo -e "\e[1;34mswitching git branch to ${NEW_BRANCH}\e[m"
        git -C "$git_repo" switch "${NEW_BRANCH}" -q
        echo -e "\e[1;34msetting ${NEW_BRANCH} as the valid branch\e[m"
        echo "$NEW_BRANCH" >"${git_repo}/.branch"
        ;;
    "/personal/repos/daniele821/nvim-config")
        NEW_BRANCH="legacy"
        FROM_DIR="$git_repo"
        TO_DIR="$HOME/.config/nvim"
        echo -e "\e[1;34mswitching git branch to ${NEW_BRANCH}\e[m"
        git -C "$git_repo" switch "${NEW_BRANCH}" -q
        if [[ ! -e "$TO_DIR" ]]; then
            echo -e "\e[1;34mlinking $TO_DIR to $FROM_DIR\e[m"
            ln -s "$FROM_DIR" "$TO_DIR"
        fi
        echo -e "\e[1;34minitializing neovim\e[m"
        rm -rf ~/.local/{state,share}/nvim ~/.cache/nvim
        nvim --headless +qa
        ;;
    esac
}

# if interrupted, clean up anyway
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

# speed up the downloads, by running them in parallel
# NOTE: this require ssh to not prompt to accept new key (can be set in .ssh/config)
for ((i = 0; i < "${#GIT_DATA[@]}"; i += 3)); do
    git_url="${GIT_DATA[$i]}"
    git_repo="${GIT_DATA[$((i + 1))]}"
    git_email="${GIT_DATA[$((i + 2))]}"
    if [[ ! -e "$git_repo" ]]; then
        TMP_FILE="$(mktemp)"
        download_repo "$git_url" "$git_repo" "$git_email" &>"$TMP_FILE" &
        CLONEPIDS+=("$!")
        TMP_FILES+=("$TMP_FILE")
    fi
done
cleanup

exit 0
