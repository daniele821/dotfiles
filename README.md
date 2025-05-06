# almawifi

for some reasons, it is a little tricky on fedora:
- create the connection & immediately stop it
- disable MAC address randomization: 
    - `nmcli connection modify <wifi_name> wifi.cloned-mac-address stable`
        - it might need root permissions (rerun with sudo)
        - `stable` might not be enough, in which case use `permanent` (WARNING: exposes REAL mac address!)
- renable the connection

