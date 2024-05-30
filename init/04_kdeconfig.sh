#!/bin/bash -e

# warning
echo "Warning: extreme kde configuration, may delete customizations"
echo -n "Do you still wish to proceed [y/n]? "
read -r answer </dev/tty
[[ "${answer,,:0:1}" == "y" ]] || exit 0

# change global theme
lookandfeeltool -a org.kde.breezedark.desktop --resetLayout
kwriteconfig6 --file ~/.config/kcminputrc --group 'Mouse' --key 'cursorTheme' 'Adwaita'

# configure okular
kwriteconfig6 --file ~/.config/okularpartrc --group 'Core General' --key 'ObeyDRM' --type bool false
kwriteconfig6 --file ~/.config/okularpartrc --group 'Core Performance' --key 'MemoryLevel' 'Greedy'
kwriteconfig6 --file ~/.config/okularpartrc --group 'General' --key 'ShellOpenFileInTabs' --type bool true

# configure konsole
kwriteconfig6 --file ~/.config/konsolerc --group 'KonsoleWindow' --key 'RememberWindowSize' --type bool false
kwriteconfig6 --file ~/.config/konsolerc --group 'Notification Messages' --key 'CloseAllTabs' --type bool true
kwriteconfig6 --file ~/.config/konsolerc --group 'Notification Messages' --key 'CloseAllEmptyTabs' --type bool true
if [[ -f "${HOME}/.local/share/konsole/Nerd Font.profile" ]]; then
	kwriteconfig6 --file ~/.config/konsolerc --group 'Desktop Entry' --key 'DefaultProfile' 'Nerd Font.profile'
fi
### HACKY: magically removes toolbars
kwriteconfig6 --file ~/.local/share/konsole/konsolestaterc --group 'MainWindow' --key 'State' 'AAAA/wAAAAD9AAAAAQAAAAAAAAAAAAAAAPwCAAAAAvsAAAAiAFEAdQBpAGMAawBDAG8AbQBtAGEAbgBkAHMARABvAGMAawAAAAAA/////wAAAXIA////+wAAABwAUwBTAEgATQBhAG4AYQBnAGUAcgBEAG8AYwBrAAAAAAD/////AAABEQD///8AAASyAAAC7AAAAAQAAAAEAAAACAAAAAj8AAAAAQAAAAIAAAACAAAAFgBtAGEAaQBuAFQAbwBvAGwAQgBhAHIAAAAAAP////8AAAAAAAAAAAAAABwAcwBlAHMAcwBpAG8AbgBUAG8AbwBsAGIAYQByAAAAAAD/////AAAAAAAAAAA='

# configure krunner
kwriteconfig6 --file ~/.config/krunnerrc --group 'Plugins' --key 'krunner_appstreamEnabled' --type bool false

# configure kwin
kwriteconfig6 --file ~/.config/kwinrc --group 'ModifierOnlyShortcuts' --key 'Meta' ''
kwriteconfig6 --file ~/.config/kwinrc --group 'NightColor' --key 'Active' --type bool true
kwriteconfig6 --file ~/.config/kwinrc --group 'NightColor' --key 'Mode' 'Constant'
kwriteconfig6 --file ~/.config/kwinrc --group 'NightColor' --key 'NightTemperature' '3500'
kwriteconfig6 --file ~/.config/kwinrc --group 'org.kde.kdecoration2' --key 'BorderSizeAuto' --type bool false

# configure battery
kwriteconfig6 --file ~/.config/powerdevilrc --group 'BatteryManagement' --key 'BatteryLowLevel' '30'
kwriteconfig6 --file ~/.config/powerdevilrc --group 'BatteryManagement' --key 'BatteryCriticalLevel' '15'

# configure notifications
kwriteconfig6 --file ~/.config/plasmanotifyrc --group 'Notifications' --key 'LowPriorityPopups' --type bool false
