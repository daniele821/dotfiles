#!/bin/env bash

set -e

# clone missing git repos and set the email
GIT_URL=(
    "git@daniele821.github.com:daniele821/dotfiles.git"
    "git@daniele821.github.com:daniele821/daniele821.github.io.git"
    "git@daniele821.github.com:daniele821/golang.git"
    "git@daniele821.github.com:daniele821/nvim-config.git"
    "git@daniele821.github.com:daniele821/python.git"
    "git@daniele821.github.com:daniele821/ricette.git"
    "git@daniele821.github.com:daniele821/rust.git"
    "git@daniele821.github.com:daniele821/track-payments-data.git"
    "git@daniele821.github.com:daniele821/track-payments"
    "git@danix1234.github.com:danix1234/unibo-2a.git"
    "git@danix1234.github.com:danix1234/unibo-2b.git"
    "git@danix1234.github.com:danix1234/unibo-3a.git"
    "git@danix1234.github.com:danix1234/unibo-3b.git"
    "git@danix1234.github.com:danix1234/unibo.git"
)
GIT_REPO=(
    "/personal/repos/daniele821/dotfiles"
    "/personal/repos/daniele821/github-website"
    "/personal/repos/daniele821/golang"
    "/personal/repos/daniele821/nvim-config"
    "/personal/repos/daniele821/python"
    "/personal/repos/daniele821/ricette"
    "/personal/repos/daniele821/rust"
    "/personal/repos/daniele821/track-payments-data"
    "/personal/repos/daniele821/track-payments"
    "/personal/repos/danix1234/unibo-2a"
    "/personal/repos/danix1234/unibo-2b"
    "/personal/repos/danix1234/unibo-3a"
    "/personal/repos/danix1234/unibo-3b"
    "/personal/repos/danix1234/unibo"
)
GIT_EMAIL=(
    "danixgithub1@gmail.com"
    "danixgithub1@gmail.com"
    "danixgithub1@gmail.com"
    "danixgithub1@gmail.com"
    "danixgithub1@gmail.com"
    "danixgithub1@gmail.com"
    "danixgithub1@gmail.com"
    "danixgithub1@gmail.com"
    "danixgithub1@gmail.com"
    "daniele.muffato@studio.unibo.it"
    "daniele.muffato@studio.unibo.it"
    "daniele.muffato@studio.unibo.it"
    "daniele.muffato@studio.unibo.it"
    "daniele.muffato@studio.unibo.it"
)

# download the first repo serially, to avoid eventual ssh prompt being ignored
function download_repo() {
    git_url="$1"
    git_repo="$2"
    git_email="$3"
    echo -e "cloning \e[32m$git_url\e[m into \e[33m$git_repo\e[m, email: \e[34m$git_email\e[m"
    git clone -c color.ui=always --progress --recurse-submodules "$git_url" "$git_repo"
    git -C "$git_repo" config user.email "$git_email"
}
for ((i = 0; i < "${#GIT_REPO[@]}"; i++)); do
    git_repo="${GIT_REPO[$i]}"
    git_url="${GIT_URL[$i]}"
    git_email="${GIT_EMAIL[$i]}"
    if [[ ! -e "$git_repo" ]]; then
        download_repo "$git_url" "$git_repo" "$git_email"
        break
    fi
done

# speed up the remaining downloads, by running them in parallel
TMP_FILES=()
CLONEPIDS=()
for ((i = i + 1; i < "${#GIT_REPO[@]}"; i++)); do
    git_repo="${GIT_REPO[$i]}"
    git_url="${GIT_URL[$i]}"
    git_email="${GIT_EMAIL[$i]}"
    TMP_FILE="$(mktemp)"
    if [[ ! -e "$git_repo" ]]; then
        echo -e "\e[1;33mNOTE: LAUNCHED BACKGROUND CLONING -- $git_url\e[m" >/dev/tty
        download_repo "$git_url" "$git_repo" "$git_email"
    fi &>"$TMP_FILE" &
    CLONEPIDS+=("$!")
    TMP_FILES+=("$TMP_FILE")
done
for ((i = 0; i < ${#CLONEPIDS[@]}; i++)); do
    tail -n +0 -f "${TMP_FILES[$i]}" --pid="${CLONEPIDS[$i]}"
    rm "${TMP_FILES[$i]}"
done

# create missing symlinks
FROM_DIR="/personal/repos/daniele821/nvim-config"
TO_DIR="$HOME/.config/nvim"
if [[ ! -e "$TO_DIR" ]]; then
    echo -e "linking \e[34m$TO_DIR\e[m to \e[35m$FROM_DIR\e[m"
    ln -s "$FROM_DIR" "$TO_DIR"
fi
