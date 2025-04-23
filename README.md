# almawifi

for some reasons, it is a little tricky on fedora:
- `touch` the certificate file
- disable firewall via `sudo systemctl stop firewall.service`
- if still not work: 
    - try deleting the connection
    - try connecting with a different connection, download the certificate, and retry connecting
