# Changelog

## {Next Version}

### Misc

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
  * improve output by adding color
* docker-TLS/check-ca-tls.sh created this script to test ca.pem close #49
* docker-TLS/create-host-tls.sh add warning when ${CA_CERT} expires before cert.pem
* docker-TLS/create-user-tls.sh add warning when ${CA_CERT} expires before user-cert.pem
* docker-TLS/check-ca-tls.sh update output and display_help
* docker-TLS/copy-host-2-remote-host-tls.sh add default standard for Docker Swarm standalone manager
* 
### Bugfixes

### Misc
* docker-TLS/* update output for shellcheck incidents




docker-TLS/create-host-tls.sh removed hostname from key names in symbolic link
docker-TLS/create-host-tls.sh change file name standard to include site private CA date in all certs that are built from it
docker-TLS/create-registry-tls.sh updated display_help, added cert duration dates & cert symbolic links

docker-TLS/copy-user-2-remote-host-tls.sh docker-TLS/copy-host-2-remote-host-tls.sh changes for #5 #48 localhost does not use scp & ssh
docker-TLS/check-user-tls.sh - upgrade Production standard #62
close #70 docker-TLS/create-user-tls.sh - upgrade Production standard
close #60 docker-TLS/create-site-private-public-tls.sh Production standard 2.3.529 log format, 8.3.530 --usage, 1.3.531 DEBUG variable
close #68 docker-TLS/create-registry-tls.sh - upgrade Production standard
close #67 docker-TLS/create-new-openssl.cnf-tls.sh Production standard 2.3.529 log format, 8.3.530 --usage, 1.3.531 DEBUG variable
close #66 docker-TLS/create-host-tls.sh upgrade Production standard
#64 docker-TLS/copy-user-2-remote-host-tls.sh Production standard 2.3.529 log format, 8.3.530 --usage, 1.3.531 DEBUG variable
docker-TLS/copy-host-2-remote-host-tls.sh close #65 Production standard 2.3.529 log format, 8.3.530 --usage, 1.3.531 DEBUG variable
docker-TLS/check-user-tls.sh #62 Production standard 2.3.529 log format, 8.3.530 --usage, 1.3.531 DEBUG variable
docker-TLS/check-ca-tls.sh docker-TLS/check-registry-tls.sh #59 #61 updated Production standard 2.3.529 log format, 8.3.530 --usage, 1.3.531 DEBUG variable
close #64 docker-TLS/copy-user-2-remote-host-tls.sh - upgrade Production standard
close #61 docker-TLS/check-registry-tls.sh - upgrade Production standard
close #41 copy-registry-tls.sh - upgrade Production standard
close #63 docker-TLS/copy-host-2-remote-host-tls.sh - upgrade Production standard
close #62 docker-TLS/check-user-tls.sh - upgrade Production standard
close #60 check-host-tls.sh - upgrade Production standard
close #59 docker-TLS/check-ca-tls.sh - upgrade Production standard #59
ssh/check-user-ssh.sh change DEFAULT_USER_HOME #54
pre-commit add logging information to output / corrected incident with function not being call #57
complete, release to production close #56
dockerd-configuration-options{setup-dockerd.sh,uninstall-dockerd-scripts.sh} - added production standard 8.0 --usage #53
docker-TLS/c* - added production standard 8.0 --usage #52
docker-TLS/check-host-tls.sh - modify output: add user message about cert expires close #50
