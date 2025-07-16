#!/bin/bash

# run neovim dev container in current directory
function edit() {
    function fix_file() {
        local -r FULLPATH="$(realpath -- "$1")"
        case "$FULLPATH" in
        *)
            ! [[ -e "$FULLPATH" ]] && echo "'$1' does not exists" >&2 && return 1
            ! [[ -O "$FULLPATH" ]] && echo "'$1' is not owned by current user" >&2 && return 1
            ! [[ -w "$FULLPATH" ]] && echo "'$1' is not writable by current user" >&2 && return 1
            [[ -L "${1%/}" ]] && echo "'$1' is a symlink" >&2 && return 1
            ;;
        esac
        echo "$FULLPATH" && return 0
    }
    TZVAR="TZ=$(timedatectl show --property=Timezone --value)"
    IMAGE="ghcr.io/daniele821/neovim"
    case "$#" in
    0) # mount NOTHING
        FULLPATH="$(fix_file .)" || return 1
        podman run --rm -it -e "$TZVAR" --security-opt label=type:container_runtime_t -v "$FULLPATH:/host$FULLPATH" -w "/host$FULLPATH" "$IMAGE" bash -ic 'nvim "$@"' _ "/host$FULLPATH"
        ;;
    1) # mount file or directory, and set workdir to that mount location
        FULLPATH="$(fix_file "$1")" || return 1
        if [[ -d "$1" ]]; then
            podman run --rm -it -e "$TZVAR" --security-opt label=type:container_runtime_t -v "$FULLPATH:/host$FULLPATH" -w "/host$FULLPATH" "$IMAGE" bash -ic 'nvim "$@"' _ "/host$FULLPATH"
        else
            DIRNAME="$(fix_file "$(dirname "$FULLPATH")")" || return 1
            podman run --rm -it -e "$TZVAR" --security-opt label=type:container_runtime_t -v "$DIRNAME:/host$DIRNAME" -w "/host$DIRNAME" "$IMAGE" bash -ic 'nvim "$@"' _ "/host$FULLPATH"
        fi
        ;;
    *) # mount multiple files at once, in their fullpath, as to easily avoid conflicts
        declare -A tmp_files
        declare -A tmp_dirs
        for arg in "$@"; do
            path="$(fix_file "$arg")" || return 1
            if [[ -d "$path" ]]; then
                tmp_dirs["$path"]=1
            else
                dir="$(fix_file "$(dirname "$arg")")" || return 1
                tmp_dirs["$dir"]=1
                tmp_files["$path"]=1
            fi
        done
        ALL_FILES=("${!tmp_files[@]}")
        ALL_DIRS=("${!tmp_dirs[@]}")
        MOUNTS=()
        ARGS=()
        for arg in "${ALL_DIRS[@]}"; do MOUNTS+=(-v "$arg:/host$arg"); done
        for arg in "${ALL_FILES[@]}"; do ARGS+=("/host$arg"); done
        [[ "${#ARGS[@]}" == 0 ]] && ARGS+=("/host$(fix_file "$1")")
        podman run --rm -it -e "$TZVAR" --security-opt label=type:container_runtime_t "${MOUNTS[@]}" -w /host "$IMAGE" bash -ic 'nvim "$@"' _ "${ARGS[@]}"
        ;;
    esac
}
