#!/bin/env bash

set -e

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

# assert all arrays are of same length
urls="${#GIT_URL[@]}"
repos="${#GIT_REPO[@]}"
emails="${#GIT_EMAIL[@]}"
if [[ "$urls" -ne "$repos" || "$repos" -ne "$emails" ]]; then
    echo "amount of url, repos and emails differ"
    exit 1
fi

# clone missing git repos
for ((i = 0; i < "${#GIT_REPO[@]}"; i++)); do
    git_repo="${GIT_REPO[$i]}"
    git_url="${GIT_URL[$i]}"
    git_email="${GIT_EMAIL[$i]}"
    if [[ ! -e "$git_repo" ]]; then
        # download git repo
        echo -e "cloning \e[32m$git_url\e[m into \e[33m$git_repo\e[m"
        git clone --recurse-submodules "$git_url" "$git_repo"

        # set email
        echo -e "setting user email to \e[31m$git_email\e[m"
        git -C "$git_repo" config user.email "$git_email"
    fi
done

# symlink neovim
FROM_DIR="/personal/repos/daniele821/nvim-config"
TO_DIR="$HOME/.config/nvim"
if [[ ! -e "$TO_DIR" ]]; then
    echo -e "symlinked neovim"
    ln -s "$FROM_DIR" "$TO_DIR"
fi
