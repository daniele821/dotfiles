# almawifi

for some reasons, it is a little tricky on fedora:
- create the connection & immediately stop it
- disable MAC address randomization: `sudo nmcli connection modify <wifi_name> wifi.cloned-mac-address permanent`
- renable the connection

