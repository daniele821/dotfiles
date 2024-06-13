# dotfiles

bash script to automagically track, backup and restore dotfiles specified in a config file

# installation

- to download the repository, run the following code:

```
cd $(mktemp -d) || exit 1
git clone https://github.com/daniele821/dotfiles
cd dotfiles || exit 1
```

- to restore a backup, go to the branch you want (`git switch <branch_name>`), then run the following code:

```
./autosaver.sh restore
./autosaver.sh init
```

# TODO:

- remove starship (i want 100% packages from official fedora repo) 
    - configure PS1 -> have following in it:
        - git status?
        - exit status (color red or green to indicate last command failed or not)
        - truncate path?
        - jobs | wc -l ?
