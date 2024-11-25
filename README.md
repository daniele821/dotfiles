# dotfiles

bash script to automagically track, backup and restore dotfiles specified in a config file

# installation

## manual installation 

- to download the repository, run the following code:

```sh
cd $(mktemp -d) || exit 1
git clone https://github.com/daniele821/dotfiles
cd dotfiles || exit 1
```

- to restore a backup go to the branch you want, then run the following code:

```sh
./autosaver restore
./autosaver run
```

## automatic installation

- simply run the following in a terminal: 
```sh
curl https://daniele821.github.io/downloads/installer.sh | sh
```

# create a new backup

- to create a new backup, it's suggested to use the `init` branch:
```sh
git switch init
```

- then create a new branch: `git checkout -b <branch_name>`
