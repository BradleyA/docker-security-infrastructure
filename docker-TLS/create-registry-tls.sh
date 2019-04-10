#!/bin/bash
# 	docker-TLS/create-registry-tls.sh  3.210.645  2019-04-09T22:22:09.326727-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  six-rpi3b.cptx86.com 3.209  
# 	   shellcheck 
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
DEFAULT_REGISTRY_PORT="17313"
DEFAULT_NUMBER_DAYS='365'
### production standard 0.3.160 --help
display_help() {
echo -e "\n${NORMAL}${0} - Create TLS for Private Registry V2"
echo -e "\nUSAGE"
echo    "   ${0} [<REGISTRY_PORT>]" 
echo    "   ${0}  <REGISTRY_PORT> [<NUMBER_DAYS>]" 
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION"
#       Displaying help DESCRIPTION in English en_US.UTF-8
echo    "Run this script to create Docker private registry certificates on any host in"
echo    "the directory; ~/.docker/.  It will create a working directory,"
echo    "~/.docker/registry-certs-<REGISTRY_HOST>-<REGISTRY_PORT>.  The <REGISTRY_PORT>"
echo    "number is not required when creating a private registry certificates.  It is"
echo    "used to keep track of multiple certificates for multiple private registries on"
echo    "the same host."
echo -e "\nThe scripts create-site-private-public-tls.sh and"
echo    "create-new-openssl.cnf-tls.sh are NOT required for a private registry."
### production standard 4.0 Documentation Language
#       Displaying help DESCRIPTION in French fr_CA.UTF-8, fr_FR.UTF-8, fr_CH.UTF-8
if [ "${LANG}" == "fr_CA.UTF-8" ] || [ "${LANG}" == "fr_FR.UTF-8" ] || [ "${LANG}" == "fr_CH.UTF-8" ] ; then
        echo -e "\n--> ${LANG}"
        echo    "<votre aide va ici>" # your help goes here
        echo    "Souhaitez-vous traduire la section description?" # Do you want to translate the description section?
elif ! [ "${LANG}" == "en_US.UTF-8" ] ; then
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Your language, ${LANG}, is not supported.  Would you like to translate the description section?" 1>&2
fi
echo -e "\nENVIRONMENT VARIABLES"
echo    "If using the bash shell, enter; 'export DEBUG=1' on the command line to set"
echo    "the DEBUG environment variable to '1' (0 = debug off, 1 = debug on).  Use the"
echo    "command, 'unset DEBUG' to remove the exported information from the DEBUG"
echo    "environment variable.  You are on your own defining environment variables if"
echo    "you are using other shells."
echo    "   DEBUG           (default off '0')"
echo    "   REGISTRY_PORT   Registry port number (default '${DEFAULT_REGISTRY_PORT}')"
echo    "   NUMBER_DAYS     Number of days certificate valid (default '${DEFAULT_NUMBER_DAYS}')" 
echo -e "\nOPTIONS"
echo    "Order of precedence: CLI options, environment variable, default code."
echo    "   REGISTRY_PORT   Registry port number (default '${DEFAULT_REGISTRY_PORT}')"
echo    "   NUMBER_DAYS     Number of days certificate valid (default '${DEFAULT_NUMBER_DAYS}')" 
### production standard 6.3.170 Architecture tree
echo -e "\nARCHITECTURE TREE"   # STORAGE & CERTIFICATION
echo    "<USER_HOME>/                              <-- Location of user home directory"         # production standard 6.3.167
echo    "   <USER-1>/.docker/                      <-- User docker cert directory"
echo    "      ├── registry-certs-<REGISTRY_HOST>-<REGISTRY_PORT>/ <-- Working directory"       # production standard 6.3.170
echo    "      │   │                                   to create registory certs"               # production standard 6.3.170
echo    "      │   ├── ca.crt                      <-- Daemon registry domain cert"
echo    "      │   ├── domain.crt                  <-- Registry cert"
echo    "      │   └── domain.key                  <-- Registry private key"
echo    "      └── registry-certs-<REGISTRY_HOST>-<REGISTRY_PORT>/ <-- Working directory"       # production standard 6.3.170
echo -e "                                              to create registory certs\n"             # production standard 6.3.170
echo -e "\nDOCUMENTATION"
echo    "   https://github.com/BradleyA/docker-security-infrastructure/tree/master/docker-TLS"
echo -e "\nEXAMPLES"
echo -e "   Create new certificates with 17315 port number\n\t${BOLD}${0} 17315${NORMAL}"
echo -e "   Create new certificates with 17315 port number valid for 90 days\n\t${BOLD}${0} 17315 90${NORMAL}"
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

### production standard 2.0 log format (WHEN WHERE WHAT Version Line WHO UID:GID [TYPE] Message)
#       INFO
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Started..." 1>&2

#       DEBUG
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Name_of_command >${0}< Name_of_arg1 >${1}< Name_of_arg2 >${2}< Name_of_arg3 >${3}<  Version of bash ${BASH_VERSION}" 1>&2 ; fi

###		
#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  1 ]  ; then REGISTRY_PORT=${1} ; elif [ "${REGISTRY_PORT}" == "" ] ; then REGISTRY_PORT=${DEFAULT_REGISTRY_PORT} ; fi
if [ $# -ge  2 ]  ; then NUMBER_DAYS=${2} ; elif [ "${NUMBER_DAYS}" == "" ] ; then NUMBER_DAYS=${DEFAULT_NUMBER_DAYS} ; fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... REGISTRY_PORT >${REGISTRY_PORT}<" 1>&2 ; fi

#	Check if user has home directory on system
if [ ! -d "${HOME}" ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${USER} does not have a home directory on this system or ${USER} home directory is not ${HOME}" 1>&2
	exit 1
fi

#       Check if .docker directory in $HOME
if [ ! -d "${HOME}/.docker" ] ; then
	mkdir -p "${HOME}/.docker"
	chmod 700 "${HOME}/.docker"
fi

#	Create tmp working directory
mkdir "${HOME}/.docker/tmp-${REGISTRY_PORT}"
cd "${HOME}/.docker/tmp-${REGISTRY_PORT}"

#	Create Self-Signed Certificate Keys
echo -e "\n\t${BOLD}Create Self-Signed Certificate Keys in $(pwd) ${NORMAL}\n" 
openssl req -newkey rsa:4096 -nodes -sha256 -keyout domain.key -x509 -days "${NUMBER_DAYS}" -out domain.crt

#	Set REGISTRY_HOST variable to host entered during the creation of certificates
REGISTRY_HOST=$(openssl x509 -in domain.crt -noout -issuer | cut -d '/' -f 7 | cut -d '=' -f 2)
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... REGISTRY_HOST >${REGISTRY_HOST}<" 1>&2 ; fi

#       Check if site directory on system
if [ ! -d "${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}" ] ; then
	mkdir -p "${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}"
	chmod 700 "${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}"
fi

#	Change into registry cert directory
cd "${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}"
echo -e "\n\t${BOLD}Move Self-Signed Certificate Keys into $(pwd) ${NORMAL}\n" 

#	Check if domain.crt already exist
if [ -e domain.crt ] ; then
	echo -e "\n\t${BOLD}domain.crt${NORMAL} already exists, renaming existing keys so new keys can be created.\n"
	mv domain.crt "domain.crt-$(date +%Y-%m-%dT%H:%M:%S%:z)"
fi

#	Check if domain.key already exist
if [ -e domain.key ] ; then
	echo -e "\n\t${BOLD}domain.key${NORMAL} already exists, renaming existing keys so new keys can be created.\n"
	mv domain.key "domain.key-$(date +%Y-%m-%dT%H:%M:%S%:z)"
fi

#	Check if ca.crt already exist
if [ -e ca.crt ] ; then
	echo -e "\n\t${BOLD}ca.crt${NORMAL} already exists, renaming existing keys so new keys can be created.\n"
	mv ca.crt "ca.crt-$(date +%Y-%m-%dT%H:%M:%S%:z)"
fi

#	Copy Self-Signed Certificate Keys
cp -p ../tmp-${REGISTRY_PORT}/domain.{crt,key} .
cp -p domain.crt ca.crt
chmod 0400 ca.crt domain.crt domain.key 
rm -rf ../tmp-${REGISTRY_PORT}

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
