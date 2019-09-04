#!/bin/bash
# 	docker-TLS/create-user-tls.sh  3.435.913  2019-09-04T15:08:35.633546-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.434  
# 	   create-user-tls.sh  upgrade to Production standard 1.3.496 DEBUG variable ; shellcheck version section corrected ; change DEFAULT_USER_HOME 
# 	docker-TLS/create-user-tls.sh  3.295.762  2019-07-21T10:32:24.381804-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.294  
# 	   updated ARCHITECTURE TREE <USER_HOME>/<USER-1>/.docker/ca.pem 
# 	docker-TLS/create-user-tls.sh  3.272.739  2019-06-08T21:26:08.695535-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.271  
# 	   docker-TLS/c{} - change DEFAULT_USER_HOME="/home/" to ~ #54 
# 	docker-TLS/create-user-tls.sh  3.265.732  2019-06-07T21:37:34.570312-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.264  
# 	   docker-TLS/c* - added production standard 8.0 --usage #52 
#86# docker-TLS/create-user-tls.sh - Create user public and private key and CA
###  Production standard 3.0 shellcheck
###  Production standard 5.1.160 Copyright
#    Copyright (c) 2019 Bradley Allen
#    MIT License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
###  Production standard 1.3.496 DEBUG variable
#    Order of precedence: environment variable, default code
if [[ "${DEBUG}" == ""  ]] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
if [[ "${DEBUG}" == "2" ]] ; then set -x    ; fi   # Print trace of simple commands before they are executed
if [[ "${DEBUG}" == "3" ]] ; then set -v    ; fi   # Print shell input lines as they are read
if [[ "${DEBUG}" == "4" ]] ; then set -e    ; fi   # Exit command has a non-zero exit status
#
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
###  Production standard 7.0 Default variable value
DEFAULT_TLS_USER="${USER}"
DEFAULT_NUMBER_DAYS="90"
DEFAULT_USER_HOME=$(dirname "${HOME}")
DEFAULT_ADM_TLS_USER="${USER}"
###  Production standard 8.0 --usage
display_usage() {
echo -e "\n${NORMAL}${0} - Create user public and private key and CA"
echo -e "\nUSAGE"
echo    "   ${0} [<TLS_USER>]"
echo    "   ${0}  <TLS_USER> [<NUMBER_DAYS>]"
echo    "   ${0}  <TLS_USER>  <NUMBER_DAYS> [<USER_HOME>]"
echo -e "   ${0}  <TLS_USER>  <NUMBER_DAYS>  <USER_HOME> [<ADM_TLS_USER>]\n"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--usage | -usage | -u]"
echo    "   ${0} [--version | -version | -v]"
}
###  Production standard 0.1.160 --help
display_help() {
display_usage
#    Displaying help DESCRIPTION in English en_US.UTF-8
echo -e "\nDESCRIPTION"
echo    "An administration user runs this script to create user public, private keys and"
echo    "CA in the working directory (<USER_HOME>/<ADM_TLS_USER>/.docker/docker-ca).  If"
echo    "the directory is not found the script will create the working directory."
echo -e "\nThe scripts create-site-private-public-tls.sh and"
echo    "create-new-openssl.cnf-tls.sh are required to be run once on a system before"
echo    "using this script.  Review the documentation for a complete understanding."
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
echo    "   DEBUG       (default off '0')"
echo    "   USER_HOME   Location of user home directory (default ${DEFAULT_USER_HOME})"
echo -e "\nOPTIONS "
echo    "   TLS_USER    User requiring new TLS keys (default ${DEFAULT_TLS_USER})"
echo    "   TLS_USER    Administration user (default ${DEFAULT_TLS_USER})"
echo    "   NUMBER_DAYS Number of days host CA is valid (default ${DEFAULT_NUMBER_DAYS})"
echo    "   USER_HOME   Location of user home directory (default ${DEFAULT_USER_HOME})"
echo    "               sites have different home directories (/u/north-office/)"
echo    "   ADM_TLS_USER Administrator user creating TLS keys (default ${DEFAULT_ADM_TLS_USER})"
### production standard 6.1.177 Architecture tree
echo -e "\nARCHITECTURE TREE"   # STORAGE & CERTIFICATION
echo    "<USER_HOME>/                               <-- Location of user home directory"
echo    "└── <USER-1>/.docker/                      <-- User docker cert directory"
echo    "    ├── ca.pem                             <-- User tlscacert or symbolic link"
echo    "    ├── cert.pem                           <-- Symbolic link to user tlscert"
echo    "    ├── key.pem                            <-- Symbolic link to user tlskey"
echo    "    └── docker-ca/                         <-- Working directory to create certs"
echo -e "\nDOCUMENTATION"
echo    "   https://github.com/BradleyA/docker-security-infrastructure/tree/master/docker-TLS"
echo -e "\nEXAMPLES"
echo -e "   Create TLS keys for user bob for 30 days in /u/north-office/ uadmin\n\t${BOLD}${0} bob 30 /u/north-office/ uadmin${NORMAL}"
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
SCRIPT_NAME=$(head -2 "${0}" | awk '{printf $2}')
SCRIPT_VERSION=$(head -2 "${0}" | awk '{printf $3}')

#       UID and GID
USER_ID=$(id -u)
GROUP_ID=$(id -g)

#       Added line because USER is not defined in crobtab jobs
if ! [ "${USER}" == "${LOGNAME}" ] ; then  USER=${LOGNAME} ; fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Setting USER to support crobtab...  USER >${USER}<  LOGNAME >${LOGNAME}<" 1>&2 ; fi

#       Default help, usage, and version arguments
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] ; then
        display_help | more
        exit 0
fi
if [ "$1" == "--usage" ] || [ "$1" == "-usage" ] || [ "$1" == "usage" ] || [ "$1" == "-u" ] ; then
        display_usage | more
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
TLS_USER=${1:-${DEFAULT_TLS_USER}}
NUMBER_DAYS=${2:-${DEFAULT_NUMBER_DAYS}}
#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  3 ]  ; then USER_HOME=${3} ; elif [ "${USER_HOME}" == "" ] ; then USER_HOME="${DEFAULT_USER_HOME}" ; fi
ADM_TLS_USER=${4:-${DEFAULT_ADM_TLS_USER}}
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  TLS_USER >${TLS_USER}< NUMBER_DAYS >${NUMBER_DAYS}< USER_HOME >${USER_HOME}< ADM_TLS_USER >${ADM_TLS_USER}<" 1>&2 ; fi

#	Check if admin user has home directory on system
if [ ! -d "${USER_HOME}${ADM_TLS_USER}" ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}   ${ADM_TLS_USER} does not have a home directory on this system or ${ADM_TLS_USER} home directory is not ${USER_HOME}${ADM_TLS_USER}" 1>&2
	exit 1
fi

#	Check if site CA directory on system
if [ ! -d "${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca/.private" ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}   Default directory, ${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca/.private, not on system." 1>&2
	#	Help hint
	echo -e "\n\tRunning create-site-private-public-tls.sh will create directories"
	echo -e "\tand site private and public keys.  Then run sudo"
	echo -e "\tcreate-new-openssl.cnf-tls.sh to modify openssl.cnf file.  Then run"
	echo -e "\tcreate-host-tls.sh or create-user-tls.sh as many times as you want."
	exit 1
fi
cd "${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca"

#	Check if ca-priv-key.pem file on system
if ! [ -e "${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca/.private/ca-priv-key.pem" ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}   Site private key ${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca/.private/ca-priv-key.pem is not in this location." 1>&2
	#	Help hint
	echo -e "\n\tEither move it from your site secure location to"
	echo -e "\t${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca/.private/"
	echo -e "\tOr run create-site-private-public-tls.sh and sudo"
	echo -e "\tcreate-new-openssl.cnf-tls.sh to create a new one."
	exit 1
fi

#	Check if ${TLS_USER}-user-priv-key.pem file on system
if [ -e "${TLS_USER}-user-priv-key.pem" ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}   ${TLS_USER}-user-priv-key.pem already exists, renaming existing keys so new keys can be created." 1>&2
	mv "${TLS_USER}-user-priv-key.pem"  "${TLS_USER}-user-priv-key.pem$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)"
	mv "${TLS_USER}-user-cert.pem"  "${TLS_USER}-user-cert.pem$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)"
fi

#	Creating private key for user ${TLS_USER}
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Creating private key for user ${TLS_USER}." 1>&2
openssl genrsa -out "${TLS_USER}-user-priv-key.pem" 2048

#	Generate a Certificate Signing Request (CSR)
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Generate a Certificate Signing Request (CSR) for user ${TLS_USER}." 1>&2
openssl req -subj '/subjectAltName=client' -new -key "${TLS_USER}-user-priv-key.pem" -out "${TLS_USER}-user.csr"

#	Create and sign a ${NUMBER_DAYS} day certificate
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Create and sign a ${NUMBER_DAYS} day certificate for user ${TLS_USER}." 1>&2
openssl x509 -req -days "${NUMBER_DAYS}" -sha256 -in "${TLS_USER}-user.csr" -CA ca.pem -CAkey .private/ca-priv-key.pem -CAcreateserial -out "${TLS_USER}-user-cert.pem" || { get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Wrong pass phrase for .private/ca-priv-key.pem:" ; exit 1; }

#	Removing certificate signing requests (CSR)
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Removing certificate signing requests (CSR) and set file permissions for ${TLS_USER} key pairs." 1>&2
rm "${TLS_USER}-user.csr"
chmod 0400 "${TLS_USER}-user-priv-key.pem"
chmod 0444 "${TLS_USER}-user-cert.pem"

#	Help hint
echo -e "\nUse script ${BOLD}copy-user-2-remote-host-tls.sh${NORMAL} to update remote host."

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
