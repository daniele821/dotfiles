# almawifi

for some reasons, it is a little tricky on fedora:
- delete ALMAWIFI connection (if exists)
- reboot
- either one of:
    - [SOFTER]: enable required firewall services `sudo firewall-cmd --add-service=dhcp`
    - [BRUTAL]: disable firewall via `sudo systemctl stop firewall.service`
- insert the credential correctly at first try, otherwise try again from the start
