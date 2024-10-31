# documentation for autosaver script

- the script accept flags, which can either be `option` or `action` flags:
    - action flag specify what to do
    - option flag can modify the behaviour of the action executed

- action flags:
    - \<none\>      : list all tracked files, which are to be copied backup
    - b             : list all tracked files, and for each one allows to restore from backup
    - s             : list all tracked files, and for each one allows to save to backup
    - e             : allows to edit files
    - i             : creates necessary directories and files
    - r             : runs init scripts

- options flags:
    - c             : commit, pull, push if possible
    - d             : show diffs
    - f             : allow dangerous operations
    - y             : auto answer yes to all questions
    - v             : show verbose output

- note for options flags with specific action:
    - \<none\>|s|b:
        - f         : (only with -b action) allow deleting original files
        - c         : allow to commit saved files

- shortcuts:
    - save          : save all files to backup
    - restore       : restore all files from backup
    - init          : initialize needed directories and config files
    - edit          : allow to edit all files
        
