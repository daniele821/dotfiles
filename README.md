# bugs

- if eudoram wifi not work:
    - make sure password is not encrypted
    - in `/etc/ssl/openssl.cnf` uncomment the following commented lines:
    ```
        [provider_sect]
        default = default_sect
        ## legacy = legacy_sect
        ##
        [default_sect]
        activate = 1
        ##
        ## [legacy_sect]
        ## activate = 1
    ```
    - kde for some goddamn reasons adds %00 in the config file for the CA path: REMOVE IT!

        
    
