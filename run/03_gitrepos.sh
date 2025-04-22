#!/bin/env bash

set -e

# clone missing git repos and set the email
GIT_DATA=(
    "git@daniele821.github.com:daniele821/dotfiles.git"
    "/personal/repos/daniele821/dotfiles"
    "danixgithub1@gmail.com"

    "git@daniele821.github.com:daniele821/daniele821.github.io.git"
    "/personal/repos/daniele821/github-website"
    "danixgithub1@gmail.com"

    "git@daniele821.github.com:daniele821/golang.git"
    "/personal/repos/daniele821/golang"
    "danixgithub1@gmail.com"

    "git@daniele821.github.com:daniele821/nvim-config.git"
    "/personal/repos/daniele821/nvim-config"
    "danixgithub1@gmail.com"

    "git@daniele821.github.com:daniele821/python.git"
    "/personal/repos/daniele821/python"
    "danixgithub1@gmail.com"

    "git@daniele821.github.com:daniele821/ricette.git"
    "/personal/repos/daniele821/ricette"
    "danixgithub1@gmail.com"

    "git@daniele821.github.com:daniele821/rust.git"
    "/personal/repos/daniele821/rust"
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
)

# downloading repo and running operations on it
function download_repo() {
    function info_extra_op() {
        echo -e "\e[1;33m${*}\e[m"
    }

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
        info_extra_op "switching git branch to ${NEW_BRANCH}"
        git -C "$git_repo" switch "${NEW_BRANCH}"
        info_extra_op "setting ${NEW_BRANCH} as the valid branch"
        echo "$NEW_BRANCH" >"${git_repo}/.branch"
        ;;
    "/personal/repos/daniele821/nvim-config")
        FROM_DIR="$git_repo"
        TO_DIR="$HOME/.config/nvim"
        if [[ ! -e "$TO_DIR" ]]; then
            info_extra_op "linking $TO_DIR to $FROM_DIR"
            ln -s "$FROM_DIR" "$TO_DIR"
        fi
        ;;
    esac
}

# download the first repo serially, to avoid eventual ssh prompt being ignored
for ((i = 0; i < "${#GIT_DATA[@]}"; i += 3)); do
    git_url="${GIT_DATA[$i]}"
    git_repo="${GIT_DATA[$((i + 1))]}"
    git_email="${GIT_DATA[$((i + 2))]}"
    if [[ ! -e "$git_repo" ]]; then
        download_repo "$git_url" "$git_repo" "$git_email"
        break
    fi
done

# speed up the remaining downloads, by running them in parallel
TMP_FILES=()
CLONEPIDS=()
for ((i = i + 3; i < "${#GIT_DATA[@]}"; i += 3)); do
    git_url="${GIT_DATA[$i]}"
    git_repo="${GIT_DATA[$((i + 1))]}"
    git_email="${GIT_DATA[$((i + 2))]}"
    TMP_FILE="$(mktemp)"
    if [[ ! -e "$git_repo" ]]; then
        echo -e "\e[1;33mNOTE: LAUNCHED BACKGROUND CLONING --> $git_url\e[m" >/dev/tty
        download_repo "$git_url" "$git_repo" "$git_email"
    fi &>"$TMP_FILE" &
    CLONEPIDS+=("$!")
    TMP_FILES+=("$TMP_FILE")
done
for ((i = 0; i < ${#CLONEPIDS[@]}; i++)); do
    tail -n +0 -f "${TMP_FILES[$i]}" --pid="${CLONEPIDS[$i]}"
    rm "${TMP_FILES[$i]}"
done
