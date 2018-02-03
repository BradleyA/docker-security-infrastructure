#!/bin/bash
#	create-site-private-public-tls.sh	3.4	2018-02-01_20:40:19_CST uadmin six-rpi3b.cptx86.com
#	added logic for display_help()
#	create-site-private-public-tls.sh	3.2	2018-01-29_11:48:25_CST uadmin six-rpi3b.cptx86.com
#	added logic to check if ca-priv-key.pem or ca.pem exist
#	create-site-private-public-tls	3.1	2017-12-19_15:43:01_CST uadmin rpi3b-two.cptx86.com
#	Adding version number
#
#	set -x
#	set -v
#
display_help() {
echo -e "\nCreate site private and public keys"
echo    "This script uses three arguement; "
echo    "   NUMBERDAYS - number of days site CA is valid, default 730 days (two years)"
echo    "   USERHOME - location of admin home directory, default is /home/"
echo    "      Many sites have different home directories (/u/north-office/<user>)"
echo    "   ADMTLSUSER - administration user creating TLS accounts, default is user running script"
echo    "This script creates site private, public keys that all other TLS keys require."
echo -e "Documentation: https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS\n"
echo -e "Example:\t${0} 365 /u/north-office/ uadmin\n"
}
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] || [ "$1" == "?" ] ; then
	display_help
	exit 0
fi
###		
NUMBERDAYS=${1:-730}
USERHOME=${2:-/home/}
ADMTLSUSER=${3:-${USER}}
#	Check if admin user has home directory on system
if [ ! -d ${USERHOME}${ADMTLSUSER} ] ; then
	echo -e "${0} ${LINENO} [ERROR]:        ${ADMTLSUSER} does not have a home directory\n\ton this system or ${ADMTLSUSER} home directory is not ${USERHOME}${ADMTLSUSER}"  1>&2
	display_help
	exit 1
fi
#
mkdir -p   ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private
chmod 0700 ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private
chmod 0700 ${USERHOME}${ADMTLSUSER}/.docker/docker-ca
chmod 0700 ${USERHOME}${ADMTLSUSER}/.docker
cd         ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private
#	Check if ca-priv-key.pem file exists
if [ -e ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem ] ; then
	echo -e "${0} ${LINENO} [ERROR]:	Site private key\n\t${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem\n\talready exists, renaming existing site private key."   1>&2
	mv ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem`date +%Y-%m-%d_%H:%M:%S_%Z`
fi
echo -e "\n${0} ${LINENO} [INFO]:	Creating private key with passphrase in ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private"	1>&2
openssl genrsa -aes256 -out ca-priv-key.pem 4096
chmod 0400 ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem
echo -e "\nOnce all the certificates and keys have been generated with this private key,"
echo    "it would be prudent to move the private key to a Universal Serial Bus (USB)"
echo    "memory stick.  Remove the private key from the system and store the USB memory"
echo -e "stick in a locked fireproof location.\n"
echo -e "${0} ${LINENO} [INFO]:	Creating public key good for\n\t${NUMBERDAYS} days in ${USERHOME}${ADMTLSUSER}/.docker/docker-ca"	1>&2
echo -e "\nThe public key is copied to all systems in an environment so that those"
echo    "systems trust signed certificates.  The following is a list of prompts from"
echo    "the following command and example answers are in parentheses."
echo    "Country Name (US)"
echo    "State or Province Name (Texas)"
echo    "Locality Name (Cedar Park)"
echo    "Organization Name (Company Name)"
echo    "Organizational Unit Name (IT - SRE Team Central US)"
echo    "Common Name (two.cptx86.com)"
echo -e "Email Address ()\n"
cd ${USERHOME}${ADMTLSUSER}/.docker/docker-ca
#       Check if ca.pem file exists
if [ -e ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/ca.pem ] ; then
        echo -e "${0} ${LINENO} [ERROR]:	Site CA ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/ca.pem\n\talready exists, renaming existing site CA"   1>&2
	mv ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/ca.pem ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/ca.pem`date +%Y-%m-%d_%H:%M:%S_%Z`
fi
openssl req -x509 -days ${NUMBERDAYS} -sha256 -new -key .private/ca-priv-key.pem -out ca.pem
chmod 0444 ca.pem
echo -e "\n${0} ${LINENO} [INFO]:	These certificate\n\tare valid for ${NUMBERDAYS} days.\n"	1>&2
echo    "It would be prudent to document the date when to renew these certificates and"
echo    "set an operations or project management calendar entry about 15 days before"
echo    "renewal as a reminder to schedule a new site certificate or open a work\nticket."
###