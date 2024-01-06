#!/bin/bash

# COSTANTS
DOCK_APP_COLOR_DEFAULT="1A1E24"
DOCK_APP_OPACITY_DEFAULT="1"

# get color and opacity from user
echo -e "write hex color [default: ${DOCK_APP_COLOR_DEFAULT}] or leave empty to restore default: \c"
read -r DOCK_APP_COLOR
echo -e "write decimal number from 0 to 1 [default: ${DOCK_APP_OPACITY_DEFAULT}] or leave empty to restore default: \c"
read -r DOCK_APP_OPACITY

# apply default if no input was given
if [[ -z "$DOCK_APP_COLOR" ]]; then
    DOCK_APP_COLOR="${DOCK_APP_COLOR_DEFAULT}"
fi
if [[ -z "$DOCK_APP_OPACITY" ]]; then
    DOCK_APP_OPACITY="${DOCK_APP_OPACITY_DEFAULT}"
fi

# color application menu
RED="$((16#${DOCK_APP_COLOR:0:2}))"
GREEN="$((16#${DOCK_APP_COLOR:2:2}))"
BLUE="$((16#${DOCK_APP_COLOR:4:2}))"
APP_CSS_FILE='/usr/share/gnome-shell/extensions/pop-cosmic@system76.com/dark.css'
APP_OLD_ENTRY="$(head -2 ${APP_CSS_FILE} | tail -1)"
APP_NEW_ENTRY="background-color: rgba($RED,$GREEN,$BLUE,$DOCK_APP_OPACITY);"
TOP_CSS_FILE="${HOME}/.local/share/themes/pop-dark-fixed/gnome-shell/gnome-shell.css"
TOP_OLD_ENTRY="$(head -1439 "${TOP_CSS_FILE}" | tail -1)"
TOP_NEW_ENTRY="  background-color: rgba($RED,$GREEN,$BLUE,$DOCK_APP_OPACITY);"
sudo sed -i "s/${APP_OLD_ENTRY}/${APP_NEW_ENTRY}/" "${APP_CSS_FILE}" || exit 1
sudo sed -i "s/${TOP_OLD_ENTRY}/${TOP_NEW_ENTRY}/" "${TOP_CSS_FILE}" || exit 1

# color dock
gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity "${DOCK_APP_OPACITY}"
gsettings set org.gnome.shell.extensions.dash-to-dock background-color "#${DOCK_APP_COLOR}"

# suggestions to the user
echo "enter 'r' after clicking alt+f2 for changes to take effect!"

