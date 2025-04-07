#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
CONFIG_DIR="$(dirname "$(dirname "$(dirname "${SCRIPT_PWD}")")")/others/scripts/git_repos"
BACKUP_FILE="${CONFIG_DIR}/git_repos.txt"

### CHECK BRANCH IS CORRECT ###
REPO_DIR="$(dirname "$(dirname "$(dirname "${SCRIPT_PWD}")")")"
BRANCH_FILE="${REPO_DIR}/.branch"
BRANCH_CURR="$(git -C "${REPO_DIR}" rev-parse --abbrev-ref HEAD)"
BRANCH_WANT="$(cat "${BRANCH_FILE}" 2>/dev/null)"
if [[ "${BRANCH_CURR}" != "${BRANCH_WANT}" ]]; then
    if [[ -v BRANCH ]]; then
        echo -e "\e[1;33mWARNING: '$BRANCH_CURR' is not the valid branch ($BRANCH_WANT)\e[m"
    elif [[ -v SET_BRANCH ]]; then
        echo -e "\e[1;33mWARNING: changing valid branch: from '${BRANCH_WANT}' to '${BRANCH_CURR}'\e[m"
        echo "$BRANCH_CURR" >"$BRANCH_FILE"
    else
        echo -e "\e[1;31mERROR: '$BRANCH_CURR' is not the valid branch ($BRANCH_WANT)\e[m"
        exit 0
    fi
fi
### ------ END CHECK ------ ###

TMPFILES=()
CLONEPID=()
MESSAGGES=()

function help_msg() {
    echo "Script to update all tracked git repos

 Options:
 -b     after updating all git repos, restore backup
 -f     force reset git branch and git email
 -h     print this help message
 -r     before updating repos, also restore those missing
 -s     print git status
 -d     dry-run: do not update repos

 Shortcuts:
 all        run EVERY POSSIBLE UPDATE
 st[atus]   show only git status
 help       print this help message
 "
}

for word in "$@"; do
    case "$word" in
    --*)
        echo "Invalid word option: $word"
        exit 1
        ;;
    -*)
        for char in $(echo "${word:1}" | fold -w1); do
            case "$char" in
            b) BACKUP_FLAG="yes" ;;
            d) DRY_RUN="yes" ;;
            f) FORCE_FLAG="yes" ;;
            r) RESTORE_FLAG="yes" ;;
            h)
                help_msg
                exit 0
                ;;
            s) GIT_STATUS="yes" ;;
            *)
                echo "Invalid option: $word"
                exit 1
                ;;
            esac

        done
        ;;
    *)
        case "$word" in
        all)
            BACKUP_FLAG="yes"
            FORCE_FLAG="yes"
            RESTORE_FLAG="yes"
            ;;
        status | st)
            DRY_RUN="yes"
            GIT_STATUS="yes"
            ;;
        help)
            help_msg
            exit 0
            ;;
        *)
            echo "Invalid option: $word"
            exit 1
            ;;
        esac
        ;;
    esac
done

# early exit if no backup file is present
[[ -f "${BACKUP_FILE}" ]] || exit 0

# force update this repo, to avoid needing running this script TWICE in rare cases
if [[ "${DRY_RUN}" != "yes" ]]; then
    echo "UPDATING THIS REPOSITORY:"
    git -C "$(dirname "${SCRIPT_PWD}")" pull
fi

# restore missing repos
[[ "${RESTORE_FLAG}" == "yes" ]] && "$(dirname "$SCRIPT_PWD")/restore_git_repos.sh"

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
        ((REPOCOUNT += 1))
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
                [[ "${DRY_RUN}" != "yes" ]] && git -C "${DIR}" -c color.ui=always pull --progress --recurse-submodules
                [[ "${GIT_STATUS}" == "yes" ]] && git -C "${DIR}" status -s
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
    echo -n "$((i + 1))/$REPOCOUNT: "
    echo -e "${MESSAGGES[i]}"
    tail -n +0 -f "${TMPFILES[$i]}" --pid="${CLONEPID[$i]}"
    sleep 0.01
    rm "${TMPFILES[$i]}"
done

[[ "${BACKUP_FLAG}" == "yes" ]] && DBG="" "$(dirname "$(dirname "$(dirname "${SCRIPT_PWD}")")")/autosaver" "-bd"

exit 0
