**Notes:** Use the following example to guide you to; How to download an earlier release.

    git clone https://github.com/BradleyA/<REPOSITORY>.git --branch 2.42

## Next Version Under Construction {Version  X.X.????}  <img id="Construction" src="images/construction-icon.gif" width="120">
#### Release Name  {unreleased rc-# alpha-# beta prerelease latest}
#### Release Date  ????
### Features Added
### Features Changes
### Features Deprecations
### Issues
### Misc
* #51 ssh/check-user-ssh.sh - check for additional authorized_keys when encrypted home directory
* #58 ssh notes for design changes
* #45 ufw/create-ufw.sh - create firewall Uncomplicated Firwwall (UFW)
* #46 ufw/copy-ufw.sh - copy firewall Uncomplicated Firwwall (UFW)
* #47 ufw/create-ufw.sh - Remove firewall Uncomplicated Firwwall (UFW)
* #11 dockerd-configuration-options - why systemd
* #10 dockerd-configuration-options/setup-dockerd.sh systemctl daemon-reload testing
* #40 swarm/{docker-enter,docker-swarm-clear} - test swarm script from 2016 clusters and upgrade

closed
 * #72 docker-TLS/copy-host-2-remote-host-tls.sh - display_help description typos
 
### Issues

* #44 registry solve the incident requiring --disable-content-trust

closed
  * #37 dockerd-configuration-options/README - review and update BUG
## Version 4.1 
#### Release Name Production-4
#### Release Date 2019-12-30

Majority of changes and updates for this release are in docker-security-infrastructure/docker-TLS

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

## Version 3.234 
#### Release Name 
#### Release Date Apr 10, 2019
 
Majority of changes and updates for this release are in docker-security-infrastructure/docker-TLS

* update EXAMPLES format
* update DOCUMENTATION change links
* update README
  * added registry examples
  * added Architecture tree
* new command/service
  * added docker-TLS/copy-registry-tls.sh #43
  * added docker-TLS/create-registry-tls.sh #41
  * added docker-TLS/create-registry-tls.sh #41
* update production standard 0.1.166 --help many updates to display_help
* added new user help hints messaging
* added production standard 3.0 shellcheck
* added production standard 6.1.177 ARCHITECTURE TREE section
* added production standard 7.0 Default variable value section

## Version  3.122
#### Release Name docker-security-infrastructure-scripts
#### Release Date Feb 20, 2019

* update README, added DEBUG, update display_help; update 1-5 productio…
* …ns standards

## Version  release.3.58
#### Release Name release.3.58
#### Release Date Sep 14, 2018

* change file names to use date format without : or _ close #17

## Version  3.31
#### Release Name 
#### Release Date Jun 23, 2018

* Added uninstall-dockerd-scripts.sh to /etc/docker so it is included on each system during setup.

## Version  3.28
#### Release Name 
#### Release Date May 9, 2018

* add instruction to remove this script when complete

## Version  3.20
#### Release Name 
#### Release Date Mar 5, 2018

* changes to display help

## Version  3.15
#### Release Name 
#### Release Date Feb 28, 2018

* ready for production

## Version  3.12
#### Release Name 
#### Release Date Feb 27, 2018

* check-user-tls.sh added error message for User certificate NOT issued…
* … by CA and BOLD test messages

## Version  3.8
#### Release Name 
#### Release Date Feb 19, 2018

* dockerd-configuration-options change _ to - in XOS

## Version  3.7
#### Release Name 
#### Release Date Feb 18, 2018

* New release, ready for production

## EXAMPLE: Next Version Under Construction {Version  X.X.????}  <img id="Construction" src="images/construction-icon.gif" width="120">
# EXAMPLE: Latest Release -->  Version  X.X.????
#### Release Name  {unreleased rc-# alpha-# beta prerelease latest}
#### Release Date  ????
* Brief description
* sub-repository
  * Brief description

### Features Added
* Update feature||file
* Added the following test cases
    * hooks/bin/EXAMPLES/FVT-exit-code-error-0-001
* sub-repository
  * directory/command   git commit message
  * directory/command   git commit message close #XX

### Features Changes
### Features Deprecations
### Issues
* close #X  directory/command   git commit message
* sub-repository
  * close #XX directory/command git commit message
  
### Misc
