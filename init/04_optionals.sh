#!/bin/env bash

function ask_user(){
    echo -n "${*} [Y/n] ? "
    read -r answer </dev/tty
    [[ "${answer,,}" == 'y' ]]
}

# restore backup files
if ask_user 'Do you want to restore all backup files'; then
    SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
    SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"
    "${SCRIPT_DIR}/../autosaver.sh" restore
fi

# install dbmain 
if  ! [[ -d '/personal/exe/dbmain' ]] && ask_user 'Do you want to install dbmain [warning: potentially dangerous]' ; then
    if ! [[ -d '/personal/exe' ]]; then
        echo 'you need to create /personal/exe directory to install dbmain'
    else
        TMP_FILE="$(mktemp)"
        FILE=dbmain.tar.gz
        curl -Z 'https://projects.info.unamur.be/dbmain/files/dbm-1102-linux-amd64-setup.tar.gz' > "${TMP_FILE}" || exit 1
        mkdir -p /personal/exe/dbmain/ 
        cd /personal/exe/dbmain || exit 1
        mv "${TMP_FILE}" "${FILE}"
        tar -xzf "${FILE}"
        # necessary dependency
        sudo dnf install gtk2
        # shellcheck disable=SC2016
        echo '
# dbmain
function dbm() {
	export DB_MAIN_BIN=/personal/exe/dbmain/bin
	export PATH=$DB_MAIN_BIN:$PATH
	export LD_LIBRARY_PATH=$DB_MAIN_BIN:$DB_MAIN_BIN/../java/jre/lib/amd64/server:$LD_LIBRARY_PATH
}
function db_main() {
	dbm && "${DB_MAIN_BIN}"/db_main "${@}"
}' >> "$HOME/.bashrc"
        rm "${FILE}"
    fi
fi

# install anaconda
if ! [[ -d '/personal/exe/anaconda' ]] && ask_user 'Do you want to install anaconda [warning: potentially dangerous]'; then
    if ! [[ -d '/personal/exe' ]]; then
        echo 'you need to create /personal/exe directory to install anaconda'
    else
        # ANACONDA FOR SOME FUCKING REASON CHECKS THE FUCKING FILE EXTENSION. WHO WROTE THIS SHIT?
        TMP_FILE="$(mktemp /tmp/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.sh)"
        curl -Z 'https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Linux-x86_64.sh' > "${TMP_FILE}" || exit 1
        chmod +x "${TMP_FILE}"
        echo -e 'WARNING: install anaconda in /personal/exe/anaconda or auto install will break;\nPress enter to continue...'
        read -r _ </dev/tty
        "${TMP_FILE}" </dev/tty
        # shellcheck disable=SC2016
        echo '
# anaconda
function epe() {
	export ANACONDA_BIN=/personal/exe/anaconda/bin
	eval "$("${ANACONDA_BIN}"/conda shell.bash hook)"
	export PYTHONDONTWRITEBYTECODE="true"
}
function jupyter-lab() {
	epe && "${ANACONDA_BIN}"/jupyter-lab
} ' >> "$HOME/.bashrc"
        rm "${TMP_FILE}" 
    fi
fi
