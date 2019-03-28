#!/bin/bash
# 	docker-TLS/create-registry-tls.sh  3.159.573  2019-03-27T21:34:28.744051-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure-scripts.git  uadmin  six-rpi3b.cptx86.com 3.158  
# 	   docker-TLS/create-registry-tls.sh update tree #41 
# 	docker-TLS/create-registry-tls.sh  3.149.562  2019-03-09T08:08:07.812490-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure-scripts.git  uadmin  six-rpi3b.cptx86.com 3.148  
# 	   type create docker-TLS/create-registry-tls.sh close #41 
#
echo "In development            In developmen           In developmentt         In development          In development"
echo "          In development          In developmen           In developmentt         In development          In development"
# 
#   production standard 5
### create-registry-tls.sh - Create TLS for Private Registry V2
#       Copyright (c) 2019 Bradley Allen
#       License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
###
#       Order of precedence: environment variable, default code
if [ "${DEBUG}" == "" ] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
#	set -x
#	set -v
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
###
display_help() {
echo -e "\n{NORMAL}${0} - Create TLS for Private Registry V2"
echo -e "\nUSAGE\n   ${0} [<REGISTRY_PORT>]" 
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION"
#       Displaying help DESCRIPTION in English en_US.UTF-8
echo    "An administration user can run this script to create Docker private registry"
echo    "certificates on any host in the directory; ~/.docker/.  It will create"
echo    "a working directory, registry-certs-<REGISTRY_HOST>-<REGISTRY_PORT>.  The"
echo    "<REGISTRY_PORT> number is not required when creating private registry"
echo    "certificates.  I use the <REGISTRY_PORT> number to keep track of multiple"
echo    "certificates for multiple private registries on the same host."
#   production standard 4
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
echo    "   DEBUG           (default '0')"
echo    "   REGISTRY_PORT   Registry port number (default '5000')"
echo -e "\nOPTIONS"
echo    "   REGISTRY_PORT   Registry port number (default '5000')"
#   production standard 6
echo -e "\nCERTIFICATION ARCHITECTURE TREE"
echo    "~<USER-1>/.docker/                        <-- User docker cert directory"
echo    "   └── registry-certs-<REGISTRY_HOST>-<REGISTRY_PORT>/ <-- Working directory to"
echo    "       │                                      create registory certs"
echo    "       ├── ca.crt                         <-- Daemon registry domain cert"
echo    "       ├── domain.crt                     <-- Registry cert"
echo    "       └── domain.key                     <-- Registry private key"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-security-infrastructure"
echo -e "\nEXAMPLES\n   ${0} 17313\n"
echo    "   Create new certificates with 17313 port number reference"
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
#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  1 ]  ; then REGISTRY_PORT=${1} ; elif [ "${REGISTRY_PORT}" == "" ] ; then REGISTRY_PORT="5000" ; fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... REGISTRY_PORT >${REGISTRY_PORT}<" 1>&2 ; fi

#	Check if user has home directory on system
if [ ! -d ${HOME} ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${USER} does not have a home directory on this system or ${USER} home directory is not ${HOME}" 1>&2
	exit 1
fi

#       Check if .docker directory in $HOME
if [ ! -d ${HOME}/.docker ] ; then
	mkdir -p ${HOME}/.docker
	chmod 700 ${HOME}/.docker
fi

#	Create tmp working directory
mkdir ${HOME}/.docker/tmp-${0}
cd ${HOME}/.docker/tmp-${0}

#	Create Self-Signed Certificate Keys
echo -e "\n\t${BOLD}Create Self-Signed Certificate Keys in $(pwd) ${NORMAL}\n" 
openssl req -newkey rsa:4096 -nodes -sha256 -keyout domain.key -x509 -days 365 -out domain.crt

#	Set REGISTRY_HOST variable to host entered during the creation of certificates
REGISTRY_HOST=$(openssl x509 -in domain.crt -noout -issuer | cut -d '/' -f 7 | cut -d '=' -f 2)
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... REGISTRY_HOST >${REGISTRY_HOST}<" 1>&2 ; fi

#       Check if site directory on system
if [ ! -d ${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT} ] ; then
	mkdir -p ${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}
	chmod 700 ${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}
fi

#	Change into registry cert directory
cd ${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}
echo -e "\n\t${BOLD}Move Self-Signed Certificate Keys into $(pwd) ${NORMAL}\n" 

#	Check if domain.crt already exist
if [ -e domain.crt ] ; then
	echo -e "\n\t${BOLD}domain.crt${NORMAL} already exists, renaming existing keys so new keys can be created.\n"
	mv domain.crt domain.crt-$(date +%Y-%m-%dT%H:%M:%S%:z)
fi

#	Check if domain.key already exist
if [ -e domain.key ] ; then
	echo -e "\n\t${BOLD}domain.key${NORMAL} already exists, renaming existing keys so new keys can be created.\n"
	mv domain.key domain.key-$(date +%Y-%m-%dT%H:%M:%S%:z)
fi

#	Check if ca.crt already exist
if [ -e ca.crt ] ; then
	echo -e "\n\t${BOLD}ca.crt${NORMAL} already exists, renaming existing keys so new keys can be created.\n"
	mv ca.crt ca.crt-$(date +%Y-%m-%dT%H:%M:%S%:z)
fi

#	Copy Self-Signed Certificate Keys
cp -p ../tmp-${0}/domain.{crt,key} .
cp -p domain.crt ca.crt
chmod 0400 ca.crt domain.crt domain.key 
rm -rf ../tmp-${0}

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
