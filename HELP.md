# documentation for autosaver.py

- the script accept flags, which can either be `option` or `action` flags:
    - action flag specify what to do
    - option flag can modify the behaviour of the action executed

- action flags:
    - \<none\> -> list all tracked files, which are to be copied backup
    - b -> list all tracked files, and for each one allows to restore from backup
    - s -> list all tracked files, and for each one allows to save to backup
    - u -> list all untracked files, and can allows to delete them
    - c -> allows to commit or restore all git changes
    - e -> allows to edit files
    - i -> creates necessary directories and files
    - r -> runs init scripts

- options flags:
    - d -> show diffs
    - f -> allow dangerous operations
    - y -> auto answer yes to all questions
    - n -> auto answer no to all questions
    - t -> toggle secondary mode of the action
    - v -> show verbose output

- note for options flags with specific action:
    - \<none\>|s|b:
        - t -> show also files from the list of the `notdiff` config file
    - c:
        - t -> instead of commiting all changes, it restores everything
    - u:
        - t -> asks for each file if you want to delete the backup version
        - f -> (requires -t), also asks to delete the original version

- shortcuts:
    - save
    - restore
    - commit
    - uncommit
    - untracked
    - init
    - edit
    - run
        
- notes:
    - multiple actions can be executed, by separating each with `--`
