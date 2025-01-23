## bugs

- unable to connect to eudoram wifi:
    - add the following to `/etc/ssl/openssl.cnf`
        ```
        [ crypto_policy ]
        Options = UnsafeLegacyRenegotiation
        .include = /etc/..
        ```

