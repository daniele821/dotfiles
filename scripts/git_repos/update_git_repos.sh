#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"
BACKUP_FILE="${SCRIPT_DIR}/git_repos.txt"

TMPFILES=()
CLONEPID=()
MESSAGGES=()

# early exit if no backup file is present
[[ -f "${BACKUP_FILE}" ]] || exit 0

# clone missing directories
COUNTER=0
while read -r line; do
    ((COUNTER += 1))
    case "$COUNTER" in
    1) DIR="${line}" ;;
    2) URL="${line}" ;;
    3) ;;
    4) ;;
    5)
        if [[ -d ${DIR} ]]; then
            TMP="$(mktemp)"
            git -C "${DIR}" -c color.ui=always pull --progress --ff-only &>>"${TMP}" &
            PID="$!"
            TMPFILES+=("$TMP")
            CLONEPID+=("$PID")
            MESSAGGES+=("Updating \e[33m$URL\e[m in \e[32m$DIR\e[m")
        fi
        COUNTER=0
        ;;
    *)
        echo -e "\e[31merror: INVALID COUNTER VALUE\e[m"
        exit 1
        ;;
    esac
done <"$BACKUP_FILE"

for ((i = 0; i < ${#CLONEPID[@]}; i++)); do
    echo -e "${MESSAGGES[i]}"
    tail -n +0 -f "${TMPFILES[$i]}" --pid="${CLONEPID[$i]}"
    rm "${TMPFILES[$i]}"
done

exit 0
