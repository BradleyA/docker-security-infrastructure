#!/bin/bash
# 	docker-TLS/create-host-tls.sh  3.282.749  2019-06-10T23:15:47.531120-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.281  
# 	   change DEFAULT_WORKING_DIRECTORY 
### production standard 3.0 shellcheck
### production standard 5.1.160 Copyright
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
DEFAULT_FQDN=$(hostname -f)    # local host
DEFAULT_NUMBER_DAYS="185"
DEFAULT_WORKING_DIRECTORY="$(echo ~)/.docker/docker-ca"
DEFAULT_CA_CERT="ca.pem"
DEFAULT_CA_PRIVATE_CERT="ca-priv-key.pem"
### production standard 8.0 --usage
display_usage() {
echo -e "\n{NORMAL}${0} - Create host public, private keys and CA"
echo -e "\nUSAGE"
echo    "   ${0} [<FQDN>]"
echo    "   ${0}  <FQDN> [<NUMBER_DAYS>]"
echo -e "   ${0}  <FQDN>  <NUMBER_DAYS> [<WORKING_DIRECTORY>]\n"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--usage | -usage | -u]"
echo    "   ${0} [--version | -version | -v]"
}
### production standard 0.1.160 --help
display_help() {
display_usage
#       Displaying help DESCRIPTION in English en_US.UTF-8
echo -e "\nDESCRIPTION"
echo    "An administration user runs this script to create host public, private keys and"
echo    "CA into the working directory (<WORKING_DIRECTORY>) on the site TLS server."
echo -e "\nThe scripts create-site-private-public-tls.sh and create-new-openssl.cnf-tls.sh"
echo    "are required to create a site TLS server.  Review the DOCUMENTATION for a"
echo    "complete understanding."
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
echo    "   DEBUG             (default off '0')"
echo    "   CA_CERT           File name of certificate (default ${DEFAULT_CA_CERT})"
echo    "   CA_PRIVATE_CERT   File name of private certificate"
echo    "                     (default ${DEFAULT_CA_PRIVATE_CERT})"
echo    "   WORKING_DIRECTORY Absolute path for working directory"
echo    "                     (default ${DEFAULT_WORKING_DIRECTORY})"
echo -e "\nOPTIONS"
echo    "   FQDN              Fully qualified domain name of host requiring new TLS keys"
echo    "                     (default ${DEFAULT_FQDN})"
echo    "   NUMBER_DAYS       Number of days host CA is valid"
echo    "                     (default ${DEFAULT_NUMBER_DAYS})"
echo    "   WORKING_DIRECTORY Absolute path for working directory"
echo    "                     (default ${DEFAULT_WORKING_DIRECTORY})"
### production standard 6.1.177 Architecture tree
echo -e "\nARCHITECTURE TREE"   # STORAGE & CERTIFICATION
echo    "<USER_HOME>/                               <-- Location of user home directory"
echo    "└── <USER-1>/.docker/                      <-- User docker cert directory"
echo    "    └── docker-ca/                         <-- Working directory to create certs"
echo -e "\nDOCUMENTATION"
echo    "   https://github.com/BradleyA/docker-security-infrastructure/tree/master/docker-TLS"
echo -e "\nEXAMPLES\n   Create host TLS for two.cptx86.com valid for 180 days in"
echo    "   /usr/local/north-office/certs"
echo -e "\t${BOLD}${0} two.cptx86.com 180 /usr/local/north-office/certs${NORMAL}"
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
FQDN=${1:-${DEFAULT_FQDN}}
NUMBER_DAYS=${2:-${DEFAULT_NUMBER_DAYS}}
#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  3 ]  ; then WORKING_DIRECTORY=${3} ; elif [ "${WORKING_DIRECTORY}" == "" ] ; then WORKING_DIRECTORY="${DEFAULT_WORKING_DIRECTORY}" ; fi
#       Order of precedence: environment variable, default code
if [ "${CA_CERT}" == "" ] ; then CA_CERT="${DEFAULT_CA_CERT}" ; fi
if [ "${CA_PRIVATE_CERT}" == "" ] ; then CA_PRIVATE_CERT="${DEFAULT_CA_PRIVATE_CERT}" ; fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  FQDN >${FQDN}< NUMBER_DAYS >${NUMBER_DAYS}< WORKING_DIRECTORY >${WORKING_DIRECTORY}< CA_CERT >${CA_CERT}< CA_PRIVATE_CERT >${CA_PRIVATE_CERT}<" 1>&2 ; fi

#	Check if ${WORKING_DIRECTORY} is on system
if [ ! -d "${WORKING_DIRECTORY}" ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${WORKING_DIRECTORY} does not exist on this system" 1>&2
	exit 1
fi

#       Check if site CA directory on system
if [ ! -d "${WORKING_DIRECTORY}/.private" ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Default directory, ${WORKING_DIRECTORY}/.private, not on system." 1>&2
	#	Help hint
	echo -e "\n\tRunning create-site-private-public-tls.sh will create directories"
	echo -e "\tand site private and public keys.  Then run sudo"
	echo -e "\tcreate-new-openssl.cnf-tls.sh to modify openssl.cnf file.  Then run"
	echo -e "\tcreate-host-tls.sh or create-user-tls.sh as many times as you want."
	exit 1
fi
cd "${WORKING_DIRECTORY}"

#       Check if ${CA_PRIVATE_CERT} file on system
if ! [ -e "${WORKING_DIRECTORY}/.private/${CA_PRIVATE_CERT}" ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Site private key ${WORKING_DIRECTORY}/.private/${CA_PRIVATE_CERT} is not in this location." 1>&2
	#	Help hint
	echo -e "\n\tEither move it from your site secure location to"
	echo -e "\t${WORKING_DIRECTORY}/.private/"
	echo -e "\tOr run create-site-private-public-tls.sh and sudo"
	echo -e "\tcreate-new-openssl.cnf-tls.sh to create a new one."
	exit 1
fi

#	Prompt for ${FQDN} if argement not entered
if [ -z "${FQDN}" ] ; then
	echo -e "\n\t${BOLD}Enter fully qualified domain name (FQDN) requiring new TLS keys:${NORMAL}"
	read FQDN
fi

#	Check if ${FQDN} string length is zero
if [ -z "${FQDN}" ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  A Fully Qualified Domain Name (FQDN) is required to create new host TLS keys." 1>&2
	exit 1
fi

#	Check if ${FQDN}-priv-key.pem file exists
if [ -e "${FQDN}-priv-key.pem" ] ; then
	echo -e "\n\t${FQDN}-priv-key.pem already exists,"
	echo -e "\trenaming existing keys so new keys can be created."
	mv "${FQDN}-priv-key.pem"  "${FQDN}-priv-key.pem_$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)"
	mv "${FQDN}-cert.pem"  "${FQDN}-cert.pem_$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)"
fi

#	Creating private key for host ${FQDN}
echo -e "\n\tCreating private key for host ${BOLD}${FQDN}${NORMAL}"
openssl genrsa -out "${FQDN}-priv-key.pem" 2048

#	Create CSR for host ${FQDN}
echo -e "\n\tGenerate a Certificate Signing Request (CSR) for"
echo -e "\thost ${BOLD}${FQDN}${NORMAL}"
openssl req -sha256 -new -key "${FQDN}-priv-key.pem" -subj "/CN=${FQDN}/subjectAltName=${FQDN}" -out "${FQDN}.csr"

#	Create and sign certificate for host ${FQDN}
echo -e "\n\tCreate and sign a ${BOLD}${NUMBER_DAYS}${NORMAL} day certificate for host"
echo -e "\t${BOLD}${FQDN}${NORMAL}"
openssl x509 -req -days "${NUMBER_DAYS}" -sha256 -in "${FQDN}.csr" -CA ${CA_CERT} -CAkey .private/${CA_PRIVATE_CERT} -CAcreateserial -out "${FQDN}-cert.pem" -extensions v3_req -extfile /usr/lib/ssl/openssl.cnf || { get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Wrong pass phrase for .private/${CA_PRIVATE_CERT}: " ; exit 1; }
openssl rsa -in "${FQDN}-priv-key.pem" -out "${FQDN}-priv-key.pem"
echo -e "\n\tRemoving certificate signing requests (CSR) and set file permissions"
echo -e "\tfor host ${BOLD}${FQDN}${NORMAL} key pairs."
rm "${FQDN}.csr"
chmod 0400 "${FQDN}-priv-key.pem"
chmod 0444 "${FQDN}-cert.pem"

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
