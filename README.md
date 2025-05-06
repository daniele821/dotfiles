# almawifi

for some reasons, it is a little tricky on fedora:
- delete ALMAWIFI connection (if exists)
- reboot
- disable firewall via `sudo systemctl stop firewalld.service`
- insert the credential correctly at first try, otherwise try again from the start
