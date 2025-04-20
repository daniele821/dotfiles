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
)

for ((i = 0; i < "${#GIT_REPO[@]}"; i++)); do
    git_repo="${GIT_REPO[$i]}"
    git_url="${GIT_URL[$i]}"
    if [[ ! -d "$git_repo" ]]; then
        echo -e "cloning \e[1;32m$git_url\e[m into \e[1;33m$git_repo\e[m"
        git clone "$git_url" "$git_repo"
    fi
done
