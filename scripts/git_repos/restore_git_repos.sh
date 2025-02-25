#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
CONFIG_DIR="$(dirname "$(dirname "$(dirname "${SCRIPT_PWD}")")")/others/scripts/git_repos"
BACKUP_FILE="${CONFIG_DIR}/git_repos.txt"

CLONEPID=()
TMPFILES=()
MESSAGGES=()
DIRS=()
BRANCHES=()
EMAILS=()

# early exit if no backup file is present
[[ -f "${BACKUP_FILE}" ]] || exit 0

# clone missing directories
COUNTER=0
REPOCOUNT=0
while read -r line; do
    ((COUNTER += 1))
    case "$COUNTER" in
    1) DIR="${line}" ;;
    2) URL="${line}" ;;
    3) BRANCH="${line}" ;;
    4) EMAIL="${line}" ;;
    5)
        if ! [[ -d ${DIR} ]]; then
            ((REPOCOUNT += 1))
            TMP="$(mktemp)"
            git clone -c color.ui=always --progress "${URL}" "${DIR}" &>>"${TMP}" &
            CLONEPID+=("$!")
            TMPFILES+=("$TMP")
            MESSAGGES+=("Cloning \e[33m$URL\e[m in \e[32m$DIR\e[m (branch:\e[34m$BRANCH\e[m, email:\e[31m$EMAIL\e[m):")
            DIRS+=("$DIR")
            BRANCHES+=("$BRANCH")
            EMAILS+=("$EMAIL")
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
    echo -n "$((i + 1))/$REPOCOUNT: "
    echo -e "${MESSAGGES[i]}"
    tail -n +0 -f "${TMPFILES[$i]}" --pid="${CLONEPID[$i]}"
    git -C "${DIRS[$i]}" config user.email "${EMAILS[$i]}"
    git -C "${DIRS[$i]}" checkout "${BRANCHES[$i]}"
    rm "${TMPFILES[$i]}"
done

exit 0
