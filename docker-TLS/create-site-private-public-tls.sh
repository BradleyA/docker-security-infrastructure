#!/bin/bash
# 	create-site-private-public-tls.sh  3.58.415  2018-09-01_18:08:57_CDT  https://github.com/BradleyA/docker-scripts  uadmin  three-rpi3b.cptx86.com 3.57  
# 	   change file names to use date format without : or _ close #17 
# 	docker-TLS/create-site-private-public-tls.sh  3.42.391  2018-08-12_10:59:20_CDT  https://github.com/BradleyA/docker-scripts  uadmin  three-rpi3b.cptx86.com 3.41-8-g21e9f27  
# 	   sync to standard script design changes 
# 	docker-TLS/create-site-private-public-tls.sh  3.15.318  2018-02-28_21:41:27_CST  https://github.com/BradleyA/docker-scripts  uadmin  four-rpi3b.cptx86.com 3.14-2-g9866315  
# 	   ready for production 
# 	create-site-private-public-tls.sh  3.14.315  2018-02-27_21:01:40_CST  https://github.com/BradleyA/docker-scripts  uadmin  four-rpi3b.cptx86.com 3.13  
# 	   added BOLD and NORMAL with little testing 
###
DEBUG=0                 # 0 = debug off, 1 = debug on
#	set -x
#	set -v
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
###
display_help() {
echo -e "\n${NORMAL}${0} - Create site private and CA keys"
echo -e "\nUSAGE\n   ${0} [<NUMBERDAYS>] [<USERHOME>] [<ADMTLSUSER>]"
echo    "   ${0} [--help | -help | help | -h | h | -? | ?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION\nAn administration user can run this script to create site private and CA"
echo    "keys.  Run this script first on your host that will be creating all your TLS"
echo    "keys for your site.  It creates the working directories"
echo    "${HOME}/.docker/docker-ca and ${HOME}/.docker/docker-ca/.private"
echo    "for your site private and CA keys.  If you later choose to use a different"
echo    "host to continue creating your user and host TLS keys, cp the"
echo    "${HOME}/.docker/docker-ca and ${HOME}/.docker/docker-ca/.private"
echo    "to the new host and run create-new-openssl.cnf-tls.sh scipt."
echo -e "\nOPTIONS"
echo    "   NUMBERDAYS   number of days site CA is valid, default 730 days (two years)"
echo    "   USERHOME     location of admin home directory, default is /home/"
echo    "                Many sites have different home directories (/u/north-office/)"
echo    "   ADMTLSUSER   administration user creating TLS accounts, default is user"
echo    "                running script"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS"
echo -e "\nEXAMPLES\n   ${0} 365 /u/north-office/ uadmin\n\n   Create site private and public keys for one year in /u/north-office/ uadmin\n"
if ! [ "${LANG}" == "en_US.UTF-8" ] ; then
        echo -e "${NORMAL}${0} ${LINENO} [${BOLD}WARNING${NORMAL}]:     Your language, ${LANG}, is not supported.\n\tWould you like to help?\n" 1>&2
fi
}
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] || [ "$1" == "?" ] ; then
	display_help
	exit 0
fi
if [ "$1" == "--version" ] || [ "$1" == "-v" ] || [ "$1" == "version" ] ; then
        head -2 ${0} | awk {'print$2"\t"$3'}
        exit 0
fi
###		
NUMBERDAYS=${1:-730}
USERHOME=${2:-/home/}
ADMTLSUSER=${3:-${USER}}
if [ "${DEBUG}" == "1" ] ; then echo -e "> DEBUG ${LINENO}  NUMBERDAYS >${NUMBERDAYS}< USERHOME >${USERHOME}< ADMTLSUSER >${ADMTLSUSER}<" 1>&2 ; fi
#	Check if admin user has home directory on system
if [ ! -d ${USERHOME}${ADMTLSUSER} ] ; then
	display_help
	echo -e "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:	${ADMTLSUSER} does not have a home directory\n\ton this system or ${ADMTLSUSER} home directory is not ${USERHOME}${ADMTLSUSER}"	1>&2
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
	echo -e "${NORMAL}${0} ${LINENO} [${BOLD}WARN${NORMAL}]:	Site private key\n\t${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem\n\talready exists, renaming existing site private key."   1>&2
	mv ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem`date +%Y-%m-%d-%H-%M-%S-%Z`
fi
echo -e "${NORMAL}\n${0} ${LINENO} [${BOLD}INFO${NORMAL}]:	Creating private key with passphrase in ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private"	1>&2
openssl genrsa -aes256 -out ca-priv-key.pem 4096  || { echo -e "\n${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:   Pass phrase does not match." ; exit 1; }
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
        echo -e "${NORMAL}${0} ${LINENO} [${BOLD}WARN${NORMAL}]:	Site CA ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/ca.pem\n\talready exists, renaming existing site CA"   1>&2
	mv ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/ca.pem ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/ca.pem`date +%Y-%m-%d-%H-%M-%S-%Z`
fi
openssl req -x509 -days ${NUMBERDAYS} -sha256 -new -key .private/ca-priv-key.pem -out ca.pem || { echo -e "\n${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:   Incorrect pass phrase for .private/ca-priv-key.pem." ; exit 1; }
chmod 0444 ca.pem
echo -e "${NORMAL}\n${0} ${LINENO} [${BOLD}INFO${NORMAL}]:	These certificate\n\tare valid for ${NUMBERDAYS} days.\n"	1>&2
echo    "It would be prudent to document the date when to renew these certificates and"
echo    "set an operations or project management calendar entry about 15 days before"
echo -e "renewal as a reminder to schedule a new site certificate or open a work\nticket."
echo -e "${NORMAL}\n${0} ${LINENO} [${BOLD}INFO${NORMAL}]:	Done.\n"	1>&2
###
