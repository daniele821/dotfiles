#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
CONFIG_DIR="$(dirname "$(dirname "$(dirname "${SCRIPT_PWD}")")")/others/scripts/git_repos"
BACKUP_FILE="${CONFIG_DIR}/git_repos.txt"

# early exit if no backup file is present
[[ -f "${BACKUP_FILE}" ]] || exit 0

TMPFILES=()
CLONEPID=()
MESSAGGES=()

while getopts ":bfhr" opt 2>/dev/null; do
    case "$opt" in
    b) BACKUP_FLAG="yes" ;;
    f) FORCE_FLAG="yes" ;;
    r) RESTORE_FLAG="yes" ;;
    h)
        echo "Script to update all tracked git repos

Options:
-b      after updating all git repos, restore backup
-f      force reset git branch and git email
-h      print this help message
-r      before updating repos, also restore those missing
"
        exit 0
        ;;
    *)
        echo "Invalid option: -$OPTARG"
        exit 1
        ;;
    esac
done

[[ "${RESTORE_FLAG}" == "yes" ]] && "$(dirname "$SCRIPT_PWD")/restore_git_repos.sh"

# clone missing directories
COUNTER=0
while read -r line; do
    ((COUNTER += 1))
    case "$COUNTER" in
    1) DIR="${line}" ;;
    2) URL="${line}" ;;
    3) BRANCH="${line}" ;;
    4) EMAIL="${line}" ;;
    5)
        if [[ -d ${DIR} ]]; then
            TMP="$(mktemp)"
            function update_repo() {
                EMAIL_NEW="$(git -C "${DIR}" config user.email 2>/dev/null)"
                BRANCH_NEW="$(git -C "${DIR}" rev-parse --abbrev-ref HEAD 2>/dev/null)"
                URL_NEW="$(git -C "${DIR}" remote get-url "$(git -C "${DIR}" remote 2>/dev/null)" 2>/dev/null)"
                if [[ "${URL_NEW}" != "${URL}" ]]; then
                    echo -e "\e[1;31mUrl was changed: \e[1;32m${URL}\e[1;31m -> \e[1;32m${URL_NEW}\e[1;31m. Quitting...\e[m"
                    return 1
                fi
                if [[ "${EMAIL_NEW}" != "${EMAIL}" ]]; then
                    echo -en "\e[1;33mEmail was changed\e[m"
                    if [[ ${FORCE_FLAG} == "yes" ]]; then
                        echo -e "\e[1;33m. Changing it back: \e[1;32m${EMAIL_NEW}\e[1;33m -> \e[1;32m${EMAIL}\e[m"
                        if ! git -C "${DIR}" config user.email "${EMAIL}" &>/dev/null; then
                            echo -e "\e[1;33mUnable to change email. Quitting...\e[m"
                            return 1
                        fi
                    else
                        echo -e "\e[1;33m (\e[1;32m${EMAIL}\e[1;33m -> \e[1;32m${EMAIL_NEW}\e[1;33m)\e[m"
                    fi
                fi
                if [[ "${BRANCH_NEW}" != "${BRANCH}" ]]; then
                    echo -en "\e[1;33mBranch was changed\e[m"
                    if [[ ${FORCE_FLAG} == "yes" ]]; then
                        echo -e "\e[1;33m. Changing it back: \e[1;32m${BRANCH_NEW}\e[1;33m -> \e[1;32m${BRANCH}\e[m"
                        if ! git -C "${DIR}" switch "${BRANCH}" &>/dev/null; then
                            echo -e "\e[1;33mUnable to change branch. Quitting...\e[m"
                            return 1
                        fi
                    else
                        echo -e "\e[1;33m (\e[1;32m${BRANCH}\e[1;33m -> \e[1;32m${BRANCH_NEW}\e[1;33m)\e[m"
                    fi
                fi
                git -C "${DIR}" -c color.ui=always pull --progress --ff-only
            }
            update_repo &>>"${TMP}" &
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

[[ "${BACKUP_FLAG}" == "yes" ]] && "$(dirname "$(dirname "$(dirname "${SCRIPT_PWD}")")")/autosaver" -btd

exit 0
