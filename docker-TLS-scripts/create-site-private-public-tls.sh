#!/bin/bash
#	create-site-private-public-tls.sh	3.2	2018-01-29_11:48:25_CST uadmin six-rpi3b.cptx86.com
#	added logic to check if ca-priv-key.pem or ca.pem exist
#	create-site-private-public-tls	3.1	2017-12-19_15:43:01_CST uadmin rpi3b-two.cptx86.com
#	Adding version number
#
#	set -x
#	set -v
#
#	Create site private and public keys
#	This script uses two arguement; 
#		NUMBERDAYS - number of days site CA is valid, default 730 days (two years)
#		USERHOME - location of user home directory, default is /home/
#		   Many sites have different home directories locations (/u/north-office/<user>)
#		TLSUSER - user, default is user running script
#	This script creates site private and public keys that all other TLS keys require
#	Documentation: https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS-scripts
###		
NUMBERDAYS=${1:-730}
USERHOME=${2:-/home/}
TLSUSER=${1:-${USER}}
#       Check if user has home directory on system
if [ ! -d ${USERHOME}${TLSUSER} ] ; then
        echo -e "${0} ${LINENO} [ERROR]:        ${TLSUSER} does not have a home directory\n\ton this system or ${TLSUSER} home directory is not ${USERHOME}${TLSUSER}"  1>&2
        exit 1
fi
#
mkdir -p   ${USERHOME}${TLSUSER}/.docker/docker-ca/.private
chmod 0700 ${USERHOME}${TLSUSER}/.docker/docker-ca/.private
chmod 0700 ${USERHOME}${TLSUSER}/.docker/docker-ca
chmod 0700 ${USERHOME}${TLSUSER}/.docker
cd         ${USERHOME}${TLSUSER}/.docker/docker-ca/.private
#       Check if ca-priv-key.pem file exists
if [ -e ${USERHOME}${TLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem ] ; then
        echo -e "${0} ${LINENO} [ERROR]:	Site private key ${USERHOME}${TLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem\n\talready exists, renaming existing site private key"   1>&2
	mv ${USERHOME}${TLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem ${USERHOME}${TLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem`date +%Y-%m-%d_%H:%M:%S_%Z`
fi
echo -e "\n${0} ${LINENO} [INFO]:	Creating private key with passphrase in ${USERHOME}${TLSUSER}/.docker/docker-ca/.private"	1>&2
openssl genrsa -aes256 -out ca-priv-key.pem 4096
chmod 0400 ${USERHOME}${TLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem
echo -e "\nOnce all the certificates and keys have been generated with this private key,"
echo    "it would be prudent to move the private key to a Universal Serial Bus (USB) memory stick."
echo    "Remove the private key from the system and store the USB memory stick in a locked"
echo -e "fireproof location.\n"
echo    "${0} ${LINENO} [INFO]:	Creating public key good for ${NUMBERDAYS} days in ${USERHOME}${TLSUSER}/.docker/docker-ca"	1>&2
echo -e "\nThe public key is copied to all systems in an environment so that those systems"
echo    "trust signed certificates."
echo    "The following is a list of prompts from the following command and example answers are"
echo    "in parentheses."
echo    "Country Name (US)"
echo    "State or Province Name (Texas)"
echo    "Locality Name (Cedar Park)"
echo    "Organization Name (Company Name)"
echo    "Organizational Unit Name (IT - SRE Team Central US)"
echo    "Common Name (two.cptx86.com)"
echo -e "Email Address ()\n"
cd ${USERHOME}${TLSUSER}/.docker/docker-ca
#       Check if ca.pem file exists
if [ -e ${USERHOME}${TLSUSER}/.docker/docker-ca/ca.pem ] ; then
        echo -e "${0} ${LINENO} [ERROR]:	Site CA ${USERHOME}${TLSUSER}/.docker/docker-ca/ca.pem\n\talready exists, renaming existing site CA"   1>&2
	mv ${USERHOME}${TLSUSER}/.docker/docker-ca/ca.pem ${USERHOME}${TLSUSER}/.docker/docker-ca/ca.pem`date +%Y-%m-%d_%H:%M:%S_%Z`
fi
openssl req -x509 -days ${NUMBERDAYS} -sha256 -new -key .private/ca-priv-key.pem -out ca.pem
chmod 0444 ca.pem
echo -e "\n\n${0} ${LINENO} [INFO]:	These certificate are valid for ${NUMBERDAYS} days.\n"	1>&2
echo    "It would be prudent to document the date when to renew these certificates and set"
echo    "an operations or project management calendar entry about 15 days before renewal as"
echo    "a reminder to schedule a new site certificate or open a work ticket."
###
