# almawifi

for some reasons, it is a little tricky on fedora:
- create the connection
- immediately stop the connection
- make firewall-cmd less restrictive:
    - set the most permessive zone (use kde GUI to set zone to `work`, or `trusted` in extreme cases)
    - or `firewall-cmd --add-service=dns,radius,dhcp`
- disable MAC address randomization: 
    - `nmcli connection modify <wifi_name> wifi.cloned-mac-address stable`
        - it might need root permissions (rerun with sudo)
        - `stable` might not be enough, in which case use `permanent` (WARNING: exposes REAL mac address!)
- renable the connection

- if still not work, try:
    - downloading again the Wifi certificate
    - delete connection
    - reboot
