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
kwriteconfig6 --file ~/.config/konsolerc --group 'Desktop Entry' --key 'DefaultProfile' 'Nerd Font.profile' # requires profile file

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

# configure shortcuts
kwriteconfig6 --file ~/.config/kglobalshortcutsrc --group 'plasmashell' --key 'manage activities' 'none,Meta+Q,Show Activity Switcher'
kwriteconfig6 --file ~/.config/kglobalshortcutsrc --group 'plasmashell' --key 'stop current activity' 'none,Meta+S,Stop Current Activity'
kwriteconfig6 --file ~/.config/kglobalshortcutsrc --group 'kwin' --key 'Switch One Desktop Down' 'Meta+Alt+Down,Meta+Ctrl+Down,Switch One Desktop Down'
kwriteconfig6 --file ~/.config/kglobalshortcutsrc --group 'kwin' --key 'Switch One Desktop Up' 'Meta+Alt+Up,Meta+Ctrl+Up,Switch One Desktop Up'
kwriteconfig6 --file ~/.config/kglobalshortcutsrc --group 'kwin' --key 'Switch One Desktop to the Left' 'Meta+Alt+Left,Meta+Ctrl+Left,Switch One Desktop to the Left'
kwriteconfig6 --file ~/.config/kglobalshortcutsrc --group 'kwin' --key 'Switch One Desktop to the Right' 'Meta+Alt+Right,Meta+Ctrl+Right,Switch One Desktop to the Right'
kwriteconfig6 --file ~/.config/kglobalshortcutsrc --group 'kwin' --key 'Switch Window Down' 'none,Meta+Alt+Down,Switch to Window Below'
kwriteconfig6 --file ~/.config/kglobalshortcutsrc --group 'kwin' --key 'Switch Window Left' 'none,Meta+Alt+Left,Switch to Window to the Left'
kwriteconfig6 --file ~/.config/kglobalshortcutsrc --group 'kwin' --key 'Switch Window Right' 'none,Meta+Alt+Right,Switch to Window to the Right'
kwriteconfig6 --file ~/.config/kglobalshortcutsrc --group 'kwin' --key 'Switch Window Up' 'none,Meta+Alt+Up,Switch to Window Above'
kwriteconfig6 --file ~/.config/kglobalshortcutsrc --group 'kwin' --key 'Window Close' 'Meta+Q\tAlt+F4,Alt+F4,Close Window'
