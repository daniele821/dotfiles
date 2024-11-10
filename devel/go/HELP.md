# documentation for autosaver script

- the script accept flags, which can either be `option` or `action` flags:
    - action flag specify what to do
    - option flag can modify the behaviour of the action executed

- action flags:
    - \<none\>      : list all tracked files, which are to be copied backup
    - b             : list all tracked files, and for each one allows to restore from backup
    - s             : list all tracked files, and for each one allows to save to backup
    - u             : list all untracked files, and can allows to delete them
    - c             : allows to commit or restore all git changes
    - e             : allows to edit files
    - i             : creates necessary directories and files
    - r             : runs init scripts

- options flags:
    - d             : show diffs
    - f             : allow dangerous operations
    - y             : auto answer yes to all questions
    - n             : auto answer no to all questions
    - t             : toggle secondary mode of the action
    - v             : show verbose output

- note for options flags with specific action:
    - \<none\>|s|b:
        - t         : show also files from the list of the `notdiff` config file
        - f         : (only with -b action) allow deleting original files
    - c:
        - t         : instead of commiting all changes, it restores everything
    - u:
        - t         : asks for each file if you want to delete the backup version
        - f         : (requires -t) also asks to delete the original version
    - i:
        - t         : deletes config files, instead of creating them
        - f         : (requires -t) deletes config directories recursively

- shortcuts:
    - save          : save all files to backup
    - saveall       : save all files to backup (even the `notdiff` ones)
    - restore       : restore all files from backup
    - restoreall    : restore all files from backup (even the `notdiff` ones)
    - commit        : commit and push all changes in git repo
    - uncommit      : delete all changes in git repo
    - untracked     : list untracked files
    - init          : initialize needed directories and config files
    - edit          : allow to edit all files
    - run           : run all init scripts 
    - co            : "commit"
    - un            : "uncommit"

- envvars:
    - DBG           : show performance and flags
        
- notes:
    - multiple actions can be executed, by separating each with `--`
