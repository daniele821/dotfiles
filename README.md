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

# TODO

- [ ]: make hyprland configuration modular
- [ ]: make a checkhealt script to check if all hyprland dependecies used in the config are installed
- [ ]: add night light (clicking backlight module)
- [x]: disable clicking battery module 
- [ ]: fix audio module click, scroll events
