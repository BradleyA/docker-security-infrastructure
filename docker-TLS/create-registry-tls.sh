#!/bin/bash
# 	docker-TLS/create-registry-tls.sh  3.134.546  2019-03-05T21:52:47.018544-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure-scripts.git  uadmin  six-rpi3b.cptx86.com 3.133  
# 	   updated display_help 
# 	docker-TLS/create-registry-tls.sh  3.132.544  2019-03-04T15:06:48.281280-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure-scripts.git  uadmin  six-rpi3b.cptx86.com 3.131  
# 	   finally ready to begin testing 
### create-registry-tls.sh - Create TLS for Private Registry V2
#       Copyright (c) 2019 Bradley Allen
#       License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
###

echo "	>>>	In test	<<<"

#   production standard 5
#       Order of precedence: environment variable, default code
if [ "${DEBUG}" == "" ] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
#	set -x
#	set -v
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
###
display_help() {
echo -e "\n{NORMAL}${0} - Create TLS for Private Registry V2"
echo -e "\nUSAGE\n   ${0} [<REGISTRY_HOST>] [<REGISTRY_PORT>]" 
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION"
#       Displaying help DESCRIPTION in English en_US.UTF-8
echo    "An administration user can run this script to create private registry"
echo    "certificates on any host in the directory;"
echo    "\${HOME}/.docker/registry-certs-<REGISTRY_HOST>-<REGISTRY_PORT>.  The"
echo    "<REGISTRY_PORT> number is not required when creating private registry"
echo    "certificates.  I use the <REGISTRY_PORT> number to keep track of multiple"
echo    "certificates for multiple private registries on the same host.  The"
echo    "<REGISTRY_HOST> and <REGISTRY_PORT> number is required when copying the ca.crt"
echo    "into /etc/docker/certs.d/<REGISTRY_HOST>:<REGISTRY_PORT>/ directory on each host."
echo -e "\nThe following illustrates a configuration with custom certificates:"
echo    "    /etc/docker/certs.d/                   <-- Certificate directory"
echo    "    └── <REGISTRY_HOST>:<REGISTRY_PORT>    <-- Hostname:port"
echo    "       ├── client.cert                     <-- Client certificate"
echo    "       ├── client.key                      <-- Client key"
echo    "       └── ca.crt                          <-- Certificate authority"
echo    "                                               that signed the"
echo    "                                               registry certificate"

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
echo    "   DEBUG           (default '0')"
echo    "   REGISTRY_HOST   Registry host (default 'local host')"
echo    "   REGISTRY_PORT   Registry port number (default '5000')"
echo -e "\nOPTIONS"
echo    "   REGISTRY_HOST   Registry host (default 'local host')"
echo    "   REGISTRY_PORT   Registry port number (default '5000')"
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
if [ $# -ge  1 ]  ; then REGISTRY_HOST=${1} ; elif [ "${REGISTRY_HOST}" == "" ] ; then REGISTRY_HOST=${LOCALHOST} ; fi
#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  2 ]  ; then REGISTRY_PORT=${2} ; elif [ "${REGISTRY_PORT}" == "" ] ; then REGISTRY_PORT="5000" ; fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... REGISTRY_HOST >${REGISTRY_HOST}< REGISTRY_PORT >${REGISTRY_PORT}<" 1>&2 ; fi

#	Check if user has home directory on system
if [ ! -d ${HOME} ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${USER} does not have a home directory on this system or ${USER} home directory is not ${HOME}" 1>&2
	exit 1
fi

#       Check if site directory on system
if [ ! -d ${HOME}/.docker/docker-registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT} ] ; then
	mkdir -p ${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}
	chmod 700 ${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}
fi

#	Change into working directory
cd ${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}

#	Check if domain.crt & domain.key already exist
if [ -e domain.crt ] ; then
	echo -e "\n\tdomain.crt already exists, renaming existing keys so new keys can be created.\n"
	mv domain.crt domain.crt-$(date +%Y-%m-%dT%H:%M:%S%:z)
	mv domain.key domain.key-$(date +%Y-%m-%dT%H:%M:%S%:z)
fi

#	Create Self-Signed Certificate Keys
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Create Self-Signed Certificate Keys" 1>&2 ; fi
openssl req -newkey rsa:4096 -nodes -sha256 -keyout domain.key -x509 -days 365 -out domain.crt -subj '/CN=${REGISTRY_HOST}'

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
