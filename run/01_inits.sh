#!/bin/env bash

echo "disabling screen locking and sleeping!"
kde-inhibit --power sleep infinity &

echo "purging snaps out of existance!"
echo "Package: snapd
Pin: release a=*
Pin-Priority: -10" | sudo tee /etc/apt/preferences.d/no-snap.pref
echo '
Package: firefox*
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | sudo tee /etc/apt/preferences.d/mozillateam-firefox.pref
