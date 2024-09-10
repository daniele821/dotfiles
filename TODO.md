## VERSIONS
- 1.0:
    - 1.0.0:
        - [x] working python rewrite of autosaver script
- 1.1:
    - 1.1.0:
        - [x] add -u action to list untracked files
        - [x] do not get all files from backup folder (necessary for prev. item)
        - [x] allow -t to flag with -u action to remove untracked files
- 1.2:
    - 1.2.0:
        - [x] add -t flag to allow using a secondary config file 
        - [x] add a config file to ignore files and a secondary config file
    - 1.2.1:
        - bug fixes
    - 1.2.2:
        - bug fixes
    - 1.2.3:
        - [x] implement a checker of the flags passed
        - [x] add an env var (__CHK) to disable checker (created for prev. item)
    - 1.2.4:
        - bug fixes
    - 1.2.5:
        - bug fixes
- 1.3:
    - 1.3.0: 
        - [x] make -c an action (-t to backup, instead of saving)
        - [x] -f to delete original file with -u action, and -t flag to delete backup
        - [x] -t -> toggles secondary mode 
        - [x] add shortcut: commit, uncommit, save2, restore2
    - 1.3.1:
        - bug fixes
    - 1.3.2:
        - [x] add shortcut: status all | sa
        - [x] add message which specify which files script is working on

## TODO AND COMPLETED LIST

- COMPLETED [move to versions, once version tag is created!]:
    - [x] create shortcuts: status, status2, statusu (make status all use those)
    - [x] create shortcuts: diff, diff2, diff all | da
    - [x] create shortcuts: save all | sa (status... shortcuts -> list...)
    - [x] create shortcuts: restore all | ra 

- TODO:
    - [ ] separate primary and secondary backup files in two directories
    - [ ] add check to disable passing useless word args to script
