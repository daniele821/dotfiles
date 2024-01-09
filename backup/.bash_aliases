#!/bin/bash


# initializations
source ~/.personal/repos/other/complete-alias/complete_alias
eval "$(zoxide init bash)"
eval "$(starship init bash)"
export STARSHIP_LOG=error
export FZF_DEFAULT_OPTS='--height=25% --border=rounded'
export CARGO_HOME=/home/daniele/.cache/cargo
export RUSTUP_HOME=/home/daniele/.cache/rustup

# functions
function clear_zoxide() {
	zoxide query -ls | while read -r score path; do
		if [[ $score -le "$1" ]] || [[ "$1" -eq "-1" ]]; then
			zoxide remove "${path}"
			echo -e "\e[1;33m${path} \e[1;31m(${score})\e[m"
		fi
	done
}
function clear_zoxide_interactive(){
    zoxide query -ls | fzf -m | while read -r score path; do
        zoxide remove "${path}";
		echo -e "\e[1;33m${path} \e[1;31m(${score})\e[m"
    done;
}
function check_zoxide() {
	if ! cd "$@" &>/dev/null; then
		if [[ "$(zoxide query -l "$@" | wc -l)" -le "1" ]]; then
			z "$@"
		else
			zi "$@"
		fi
	fi
}

# aliases
alias ls='lsd --group-dirs first'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias tree='lsd --group-dirs first --tree'
alias cat='batcat'
alias sudo='sudo '
alias clear='printf "\033[2J\033[3J\033[1;1H"'
alias cd='check_zoxide'
alias zc='clear_zoxide'
alias zd='clear_zoxide_interactive'
alias autosaver='~/.personal/repos/mine/dotfiles/autosaver.sh'
alias update='sudo apt update ; sudo apt upgrade -y ; rustup update'
unalias l

# complete all aliases
complete -F _complete_alias "${!BASH_ALIASES[@]}"
