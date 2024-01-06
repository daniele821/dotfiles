#!/bin/bash

# create directory structure
mkdir -p ~/.personal/{repos/{mine,unibo,other},data}

# restore backup
"$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")/autosaver.sh" restore

# operations on backup
cd ~/.local/share/themes || exit 1
unzip Dracula.zip && mv gtk-master Dracula
unzip pop-dark-fixed.zip
cd ~/.local/share/fonts/Inconsolata || exit 1
unzip Inconsolata.zip 
cd ~/.local/share/fonts/FiraCode || exit 1
unzip FiraCode.zip

# clone repositories in other dir
cd ~/.personal/repos/other || exit 1
git clone https://github.com/cykerway/complete-alias

