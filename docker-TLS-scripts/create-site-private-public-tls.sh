#!/bin/bash
#	create-site-private-public-tls	3.1	2017-12-19_15:43:01_CST uadmin rpi3b-two.cptx86.com
#	Adding version number
#
#	set -x
#	set -v
#
#	Create site private and public keys
#	This script uses one arguement; 
#		NUMBERDAYS - number of days site CA is valid, default 1460 days (four years)
#	This script creates site private and public keys that all other TLS keys require
#	Documentation: https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS-scripts
###		
#	The defualt value is 4 years (1460 days).  Parameter 1 will over ride default value.
NUMBERDAYS=${1:-1460}
#
mkdir -pv  ${HOME}/.docker/docker-ca/.private
chmod 0700 ${HOME}/.docker/docker-ca/.private
cd         ${HOME}/.docker/docker-ca/.private
#
echo -e "\n${0} ${LINENO} [INFO]:	Creating private key with passphrase in ${HOME}/.docker/docker-ca/.private"	1>&2
openssl genrsa -aes256 -out ca-priv-key.pem 4096
chmod 0400 ${HOME}/.docker/docker-ca/.private/ca-priv-key.pem
echo -e "\nOnce all the certificates and keys have been generated with this private key,"
echo    "it would be prudent to move the private key to a Universal Serial Bus (USB) memory stick."
echo    "Remove the private key from the system and store the USB memory stick in a locked"
echo -e "fireproof location.\n"
echo    "${0} ${LINENO} [INFO]:	Creating public key good for ${NUMBERDAYS} days in ${HOME}/.docker/docker-ca"	1>&2
echo -e "\nThe public key is copied to all systems in an environment so that those systems"
echo    "trust signed certificates."
echo    "The following is a list of prompts from the following command and example answers are"
echo    "in parentheses."
echo    "Country Name (US)"
echo    "State or Province Name (Texas)"
echo    "Locality Name (Cedar Park)"
echo    "Organization Name (Company Name)"
echo    "Organizational Unit Name (IT)"
echo    "Common Name (two.cptx86.com)"
echo -e "Email Address ()\n"
cd ${HOME}/.docker/docker-ca
openssl req -x509 -days ${NUMBERDAYS} -sha256 -new -key .private/ca-priv-key.pem -out ca.pem
chmod 0444 ca.pem
echo -e "\n\n${0} ${LINENO} [INFO]:	These certificate are valid for ${NUMBERDAYS} days.\n"	1>&2
echo    "It would be prudent to document the date when to renew these certificates and set"
echo    "an operations or project management calendar entry about 15 days before renewal as"
echo    "a reminder to schedule a new site certificate or open a work ticket."
###
