# almawifi

for some reasons, it is a little tricky on fedora:
- create the connection
    - set the most permessive zone (use kde GUI to set zone to `trusted`)
- immediately stop the connection
- disable MAC address randomization: 
    - `nmcli connection modify <wifi_name> wifi.cloned-mac-address stable`
        - it might need root permissions (rerun with sudo)
        - `stable` might not be enough, in which case use `permanent` (WARNING: exposes REAL mac address!)
- renable the connection

- if still not work, try:
    - downloading again the Wifi certificate
    - delete connection
    - reboot
