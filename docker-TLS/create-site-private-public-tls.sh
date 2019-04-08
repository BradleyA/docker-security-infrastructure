#!/bin/bash
# 	docker-TLS/create-site-private-public-tls.sh  3.193.628  2019-04-07T23:33:38.827693-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  six-rpi3b.cptx86.com 3.192  
# 	   update display_help 
# 	docker-TLS/create-site-private-public-tls.sh  3.192.627  2019-04-07T19:42:17.734355-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  six-rpi3b.cptx86.com 3.191-8-gc662f79  
# 	   changed License to MIT License 
### production standard 3.0 shellcheck
### production standard 5.3.160 Copyright
#       Copyright (c) 2019 Bradley Allen
#       MIT License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
### production standard 1.0 DEBUG variable
#       Order of precedence: environment variable, default code
if [ "${DEBUG}" == "" ] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
#	set -x
#	set -v
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
### production standard 7.0 Default variable value
DEFAULT_NUMBER_DAYS="730"
DEFAULT_USER_HOME="/home/"
DEFAULT_ADM_TLS_USER="${USER}"
### production standard 0.3.158 --help
display_help() {
echo -e "\n${NORMAL}${0} - Create site private and CA keys"
echo -e "\nUSAGE"
echo    "   ${0} [<NUMBER_DAYS>]"
echo    "   ${0}  <NUMBER_DAYS> [<USER_HOME>]"
echo    "   ${0}  <NUMBER_DAYS>  <USER_HOME> [<ADM_TLS_USER>]"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION"
#       Displaying help DESCRIPTION in English en_US.UTF-8
echo    "An administration user can run this script to create site private and CA"
echo    "keys.  Run this script first on your host that will be creating all your TLS"
echo    "keys for your site.  It creates the working directories"
echo    "${HOME}/.docker/docker-ca and ${HOME}/.docker/docker-ca/.private"
echo    "for your site private and CA keys.  If you later choose to use a different"
echo    "host to continue creating your user and host TLS keys, cp the"
echo    "${HOME}/.docker/docker-ca and ${HOME}/.docker/docker-ca/.private"
echo    "to the new host and run create-new-openssl.cnf-tls.sh scipt."
#       Displaying help DESCRIPTION in French fr_CA.UTF-8, fr_FR.UTF-8, fr_CH.UTF-8
if [ "${LANG}" == "fr_CA.UTF-8" ] || [ "${LANG}" == "fr_FR.UTF-8" ] || [ "${LANG}" == "fr_CH.UTF-8" ] ; then
        echo -e "\n--> ${LANG}"
        echo    "<votre aide va ici>" # your help goes here
        echo    "Souhaitez-vous traduire la section description?" # Do you want to translate the description section?
elif ! [ "${LANG}" == "en_US.UTF-8" ] ; then
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Your language, ${LANG}, is not supported.  Would you like to translate the description section?" 1>&2
fi
echo -e "\nEnvironment Variables"
echo    "If using the bash shell, enter; 'export DEBUG=1' on the command line to set"
echo    "the DEBUG environment variable to '1' (0 = debug off, 1 = debug on).  Use the"
echo    "command, 'unset DEBUG' to remove the exported information from the DEBUG"
echo    "environment variable.  You are on your own defining environment variables if"
echo    "you are using other shells."
echo    "   DEBUG       (default off '0')"
echo    "   USER_HOME   Location of user home directory (default ${DEFAULT_USER_HOME})"
echo -e "\nOPTIONS"
echo    "   NUMBER_DAYS Number of days host CA is valid (default ${DEFAULT_NUMBER_DAYS})"
echo    "   USER_HOME   Location of user home directory (default ${DEFAULT_USER_HOME})"
echo    "               Many sites have different home directories (/u/north-office/)"
echo    "   ADM_TLS_USER Administrator user creating TLS keys (default ${DEFAULT_ADM_TLS_USER})"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-security-infrastructure/tree/master/docker-TLS"
echo -e "\nEXAMPLES\n   Create site private and public keys for one year in /u/north-office/ uadmin\n\t${BOLD}${0} 365 /u/north-office/ uadmin${NORMAL}"
}

#       Date and time function ISO 8601
get_date_stamp() {
DATE_STAMP=$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)
TEMP=$(date +%Z)
DATE_STAMP="${DATE_STAMP} (${TEMP})"
}

#       Fully qualified domain name FQDN hostname
LOCALHOST=$(hostname -f)

#       Version
SCRIPT_NAME=$(head -2 "${0}" | awk {'printf $2'})
SCRIPT_VERSION=$(head -2 "${0}" | awk {'printf $3'})

#       UID and GID
USER_ID=$(id -u)
GROUP_ID=$(id -g)

#       Added line because USER is not defined in crobtab jobs
if ! [ "${USER}" == "${LOGNAME}" ] ; then  USER=${LOGNAME} ; fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Setting USER to support crobtab...  USER >${USER}<  LOGNAME >${LOGNAME}<" 1>&2 ; fi

#       Default help and version arguments
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] ; then
        display_help | more
        exit 0
fi
if [ "$1" == "--version" ] || [ "$1" == "-version" ] || [ "$1" == "version" ] || [ "$1" == "-v" ] ; then
        echo "${SCRIPT_NAME} ${SCRIPT_VERSION}"
        exit 0
fi

#       INFO
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Started..." 1>&2

#       DEBUG
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Name_of_command >${0}< Name_of_arg1 >${1}< Name_of_arg2 >${2}< Name_of_arg3 >${3}<  Version of bash ${BASH_VERSION}" 1>&2 ; fi

###
NUMBER_DAYS=${1:-${DEFAULT_NUMBER_DAYS}}
#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  2 ]  ; then USER_HOME=${2} ; elif [ "${USER_HOME}" == "" ] ; then USER_HOME="DEFAULT_USER_HOME" ; fi
ADM_TLS_USER=${3:-${DEFAULT_ADM_TLS_USER}}
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  NUMBER_DAYS >${NUMBER_DAYS}< USER_HOME >${USER_HOME}< ADM_TLS_USER >${ADM_TLS_USER}<" 1>&2 ; fi

#	Check if admin user has home directory on system
if [ ! -d ${USER_HOME}${ADM_TLS_USER} ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${ADM_TLS_USER} does not have a home directory on this system or ${ADM_TLS_USER} home directory is not ${USER_HOME}${ADM_TLS_USER}" 1>&2
	exit 1
fi
mkdir -p   ${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca/.private
chmod 0700 ${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca/.private
chmod 0700 ${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca
chmod 0700 ${USER_HOME}${ADM_TLS_USER}/.docker
cd         ${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca/.private

#	Check if ca-priv-key.pem file exists
if [ -e ${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca/.private/ca-priv-key.pem ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Site private key ${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca/.private/ca-priv-key.pem already exists, renaming existing site private key." 1>&2
	mv ${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca/.private/ca-priv-key.pem ${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca/.private/ca-priv-key.pem$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)
fi

#	Create private key
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Creating private key with passphrase in ${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca/.private" 1>&2
openssl genrsa -aes256 -out ca-priv-key.pem 4096  || { get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Pass phrase does not match." ; exit 1; }
chmod 0400 ${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca/.private/ca-priv-key.pem

#       Check if ca.pem file exists
cd ${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca
if [ -e ${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca/ca.pem ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Site CA ${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca/ca.pem already exists, renaming existing site CA" 1>&2
	mv ${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca/ca.pem ${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca/ca.pem$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)
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
echo -e "\nCreating public key good for ${NUMBER_DAYS} days in\n${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca"	1>&2
openssl req -x509 -days ${NUMBER_DAYS} -sha256 -new -key .private/ca-priv-key.pem -out ca.pem || { get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Incorrect pass phrase for .private/ca-priv-key.pem." ; exit 1; }
chmod 0444 ca.pem
#	Help hint
echo -e "\n\t${BOLD}These certificates are valid for ${NUMBER_DAYS} days.${NORMAL}\n"
echo    "It would be prudent to document the date when to renew these certificates and"
echo    "set an operations or project management calendar entry about 15 days before"
echo -e "renewal as a reminder to schedule a new site certificate or open a work\nticket."

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
