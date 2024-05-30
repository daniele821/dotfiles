#!/bin/env bash

# warning
echo "Warning: extreme kde configuration, may delete customizations"
echo -n "Do you still wish to proceed [y/n]? "
read -r answer </dev/tty
[[ "${answer,,:0:1}" == "y" ]] || exit 0

# change global theme
lookandfeeltool -a org.kde.breezedark.desktop --resetLayout || exit 1

# configure okular
kwriteconfig6 --file ~/.config/okularpartrc --group 'Core General' --key 'ObeyDRM' --type bool false
kwriteconfig6 --file ~/.config/okularpartrc --group 'Core Performance' --key 'MemoryLevel' 'Greedy'
kwriteconfig6 --file ~/.config/okularpartrc --group 'General' --key 'ShellOpenFileInTabs' --type bool true

# apply all changes
systemctl --user restart plasma-plasmashell
