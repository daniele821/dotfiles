#!/bin/bash -e

# warning
echo "Warning: extreme kde configuration, may delete customizations"
echo -n "Do you still wish to proceed [y/n]? "
read -r answer </dev/tty
[[ "${answer,,:0:1}" == "y" ]] || exit 0

# change global theme
lookandfeeltool -a org.kde.breezedark.desktop --resetLayout

# configure okular
kwriteconfig6 --file ~/.config/okularpartrc --group 'Core General' --key 'ObeyDRM' --type bool false
kwriteconfig6 --file ~/.config/okularpartrc --group 'Core Performance' --key 'MemoryLevel' 'Greedy'
kwriteconfig6 --file ~/.config/okularpartrc --group 'General' --key 'ShellOpenFileInTabs' --type bool true

# configure konsole
kwriteconfig6 --file ~/.config/konsolerc --group 'KonsoleWindow' --key 'RememberWindowSize' --type bool false
kwriteconfig6 --file ~/.config/konsolerc --group 'Notification Messages' --key 'CloseAllTabs' --type bool true
kwriteconfig6 --file ~/.config/konsolerc --group 'Notification Messages' --key 'CloseAllEmptyTabs' --type bool true
# TODO: konsole nerd font profile

# configure krunner
kwriteconfig6 --file ~/.config/krunnerrc --group 'Plugins' --key 'krunner_appstreamEnabled' --type bool false

# configure kwin
kwriteconfig6 --file ~/.config/kwinrc --group 'ModifierOnlyShortcuts' --key 'Meta' ''
kwriteconfig6 --file ~/.config/kwinrc --group 'NightColor' --key 'Active' --type bool true
kwriteconfig6 --file ~/.config/kwinrc --group 'NightColor' --key 'Mode' 'Constant'
kwriteconfig6 --file ~/.config/kwinrc --group 'NightColor' --key 'NightTemperature' '3500'

# apply all changes
systemctl --user restart plasma-plasmashell
