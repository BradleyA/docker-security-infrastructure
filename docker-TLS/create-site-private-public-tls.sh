#!/bin/bash
# 	docker-TLS/create-site-private-public-tls.sh  3.76.433  2018-11-11T10:23:58.536245-06:00 (CST)  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.75  
# 	   move UID and GID function up a few link to allow DEBUG statement to use it 
# 	docker-TLS/create-site-private-public-tls.sh  3.71.428  2018-10-22T16:07:53.990192-05:00 (CDT)  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.70  
# 	   create-site-private-public-tls.sh Change echo or print DEBUG INFO WARNING ERROR closes #25 
#
###	create-site-private-public-tls.sh - Create site private and CA keys
DEBUG=0                 # 0 = debug off, 1 = debug on
#	set -x
#	set -v
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
###
display_help() {
echo -e "\n${NORMAL}${0} - Create site private and CA keys"
echo -e "\nUSAGE\n   ${0} [<NUMBERDAYS>] [<USERHOME>] [<ADMTLSUSER>]"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
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
#       After displaying help in english check for other languages
if ! [ "${LANG}" == "en_US.UTF-8" ] ; then
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[WARN]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Your language, ${LANG}, is not supported, Would you like to help translate?" 1>&2
#       elif [ "${LANG}" == "fr_CA.UTF-8" ] ; then
#               get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[WARN]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Display help in ${LANG}" 1>&2
#       else
#               get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[WARN]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Your language, ${LANG}, is not supported.\tWould you like to translate?" 1>&2
fi
}

#       Date and time function ISO 8601
get_date_stamp() {
DATE_STAMP=`date +%Y-%m-%dT%H:%M:%S.%6N%:z`
TEMP=`date +%Z`
DATE_STAMP=`echo "${DATE_STAMP} (${TEMP})"`
}

#       Fully qualified domain name FQDN hostname
LOCALHOST=`hostname -f`

#       Version
SCRIPT_NAME=`head -2 ${0} | awk {'printf$2'}`
SCRIPT_VERSION=`head -2 ${0} | awk {'printf$3'}`

#       UID and GID
USER_ID=`id -u`
GROUP_ID=`id -g`

#       Added line because USER is not defined in crobtab jobs
if ! [ "${USER}" == "${LOGNAME}" ] ; then  USER=${LOGNAME} ; fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  USER  >${USER}<  LOGNAME >${LOGNAME}<" 1>&2 ; fi

#       Default help and version arguments
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] ; then
        display_help
        exit 0
fi
if [ "$1" == "--version" ] || [ "$1" == "-version" ] || [ "$1" == "version" ] || [ "$1" == "-v" ] ; then
        echo "${SCRIPT_NAME} ${SCRIPT_VERSION}"
        exit 0
fi

#       INFO
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Begin" 1>&2

#       DEBUG
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Name_of_command >${0}< Name_of_arg1 >${1}<  Version of bash ${BASH_VERSION}" 1>&2 ; fi

###
NUMBERDAYS=${1:-730}
USERHOME=${2:-/home/}
ADMTLSUSER=${3:-${USER}}
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  NUMBERDAYS >${NUMBERDAYS}< USERHOME >${USERHOME}< ADMTLSUSER >${ADMTLSUSER}<" 1>&2 ; fi

#	Check if admin user has home directory on system
if [ ! -d ${USERHOME}${ADMTLSUSER} ] ; then
	display_help
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  ${ADMTLSUSER} does not have a home directory on this system or ${ADMTLSUSER} home directory is not ${USERHOME}${ADMTLSUSER}" 1>&2
	exit 1
fi
mkdir -p   ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private
chmod 0700 ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private
chmod 0700 ${USERHOME}${ADMTLSUSER}/.docker/docker-ca
chmod 0700 ${USERHOME}${ADMTLSUSER}/.docker
cd         ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private

#	Check if ca-priv-key.pem file exists
if [ -e ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Site private key ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem already exists, renaming existing site private key." 1>&2
	mv ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem`date +%Y-%m-%dT%H:%M:%S.%6N%:z`
fi

#	Create private key
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Creating private key with passphrase in ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private" 1>&2
openssl genrsa -aes256 -out ca-priv-key.pem 4096  || { get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Pass phrase does not match." ; exit 1; }
chmod 0400 ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem

#       Check if ca.pem file exists
cd ${USERHOME}${ADMTLSUSER}/.docker/docker-ca
if [ -e ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/ca.pem ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[WARN]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Site CA ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/ca.pem already exists, renaming existing site CA" 1>&2
	mv ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/ca.pem ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/ca.pem`date +%Y-%m-%dT%H:%M:%S.%6N%:z`
fi

#	Create public key
#	Help hint
echo -e "${NORMAL}\nOnce all the certificates and keys have been generated with this private key,"
echo    "it would be prudent to move the private key to a Universal Serial Bus (USB)"
echo    "memory stick.  Remove the private key from the system and store the USB memory"
echo    "stick in a locked fireproof location."
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
echo -e "\nCreating public key good for ${NUMBERDAYS} days in\n${USERHOME}${ADMTLSUSER}/.docker/docker-ca"	1>&2
openssl req -x509 -days ${NUMBERDAYS} -sha256 -new -key .private/ca-priv-key.pem -out ca.pem || { get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Incorrect pass phrase for .private/ca-priv-key.pem." ; exit 1; }
chmod 0444 ca.pem
#	Help hint
echo -e "\n\t${BOLD}These certificates are valid for ${NUMBERDAYS} days.${NORMAL}\n"
echo    "It would be prudent to document the date when to renew these certificates and"
echo    "set an operations or project management calendar entry about 15 days before"
echo -e "renewal as a reminder to schedule a new site certificate or open a work\nticket."

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Done." 1>&2
###
