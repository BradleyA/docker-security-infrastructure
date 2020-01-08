# Changelog

## {Next Version}

### Misc
* #51 ssh/check-user-ssh.sh - check for additional authorized_keys when encrypted home directory
* #58 ssh notes for design changes
* #45 ufw/create-ufw.sh - create firewall Uncomplicated Firwwall (UFW)
* #46 ufw/copy-ufw.sh - copy firewall Uncomplicated Firwwall (UFW)
* #47 ufw/create-ufw.sh - Remove firewall Uncomplicated Firwwall (UFW)
* #11 dockerd-configuration-options - why systemd
* #10 dockerd-configuration-options/setup-dockerd.sh systemctl daemon-reload testing
### Issue
* #37 dockerd-configuration-options/README - review and update

## Version 4.1 
#### Release Name Production-4
#### Release Date 2019-12-30

### Features
* docker-TLS/* 
  * Production standard 6.3.547 Architecture tree
  * Production standard 5.3.550 Copyright
  * Production standard 0.3.550 --help
  * Production standard 8.3.541 --usage
  * Production standard 4.3.550 Documentation Language
  * Production standard 1.3.550 DEBUG variable
  * added SA and FVT tests
  * update output for shellcheck incidents
  * improve output by adding color
* docker-TLS/check-ca-tls.sh 
  * created this script to test ca.pem close #49
  * update output and display_help
* docker-TLS/create-host-tls.sh 
  * add warning when ${CA_CERT} expires before cert.pem
  * removed hostname from key names in symbolic link
  * change file name standard to include site private CA date in all certs that are built from it
* docker-TLS/create-user-tls.sh add warning when ${CA_CERT} expires before user-cert.pem
* docker-TLS/copy-host-2-remote-host-tls.sh add default standard for Docker Swarm standalone manager
* docker-TLS/create-registry-tls.sh updated display_help, added cert duration dates & cert symbolic links

### Issues
* close #5 #48 docker-TLS/copy-user-2-remote-host-tls.sh docker-TLS/copy-host-2-remote-host-tls.sh changes for #5 #48 localhost does not use scp & ssh
* close #41 copy-registry-tls.sh - upgrade Production standard
* close #50 docker-TLS/check-host-tls.sh - modify output: add user message about cert expires 
* close #52 docker-TLS/c* - added production standard 8.0 --usage
* close #53 dockerd-configuration-options{setup-dockerd.sh,uninstall-dockerd-scripts.sh} - added production standard 8.0 --usage 
* close #54 ssh/check-user-ssh.sh change DEFAULT_USER_HOME 
* close #56 complete, release to production
* close #57 pre-commit add logging information to output / corrected incident with function not being call
* close #59 docker-TLS/check-ca-tls.sh - upgrade Production standard #59
   * docker-TLS/check-ca-tls.sh docker-TLS/check-registry-tls.sh #59 #61 updated Production standard 2.3.529 log format, 8.3.530 --usage, 1.3.531 DEBUG variable
* close #60 check-host-tls.sh - upgrade Production standard
* close #60 docker-TLS/create-site-private-public-tls.sh Production standard 2.3.529 log format, 8.3.530 --usage, 1.3.531 DEBUG variable
* close #61 docker-TLS/check-registry-tls.sh - upgrade Production standard
* close #62 docker-TLS/check-user-tls.sh - upgrade Production standard
* close #63 docker-TLS/copy-host-2-remote-host-tls.sh - upgrade Production standard
* close #64 docker-TLS/copy-user-2-remote-host-tls.sh - upgrade Production standard
* #64 docker-TLS/copy-user-2-remote-host-tls.sh Production standard 2.3.529 log format, 8.3.530 --usage, 1.3.531 DEBUG variable
* close #65docker-TLS/copy-host-2-remote-host-tls.sh  Production standard 2.3.529 log format, 8.3.530 --usage, 1.3.531 DEBUG variable
* close #66 docker-TLS/create-host-tls.sh upgrade Production standard
* close #67 docker-TLS/create-new-openssl.cnf-tls.sh Production standard 2.3.529 log format, 8.3.530 --usage, 1.3.531 DEBUG variable
* close #68 docker-TLS/create-registry-tls.sh - upgrade Production standard
* close #70 docker-TLS/create-user-tls.sh - upgrade Production standard

### Misc
