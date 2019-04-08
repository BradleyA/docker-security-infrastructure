#!/bin/bash
# 	docker-TLS/create-user-tls.sh  3.192.627  2019-04-07T19:42:17.831499-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  six-rpi3b.cptx86.com 3.191-8-gc662f79  
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
###
display_help() {
echo -e "\n${NORMAL}${0} - Create user public and private key and CA"
echo -e "\nUSAGE\n   ${0} [<TLSUSER>] [<NUMBERDAYS>] [<USERHOME>] [<ADMTLSUSER>]"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION"
#       Displaying help DESCRIPTION in English en_US.UTF-8
echo    "Run this script any time a user requires a new Docker public and private"
echo    "TLS key."
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
echo    "   DEBUG       (default '0')"
echo    "   USERHOME    (default /home/)"
echo -e "\nOPTIONS "
echo    "   TLSUSER      user requiring new TLS keys, default is user running script"
echo    "   NUMBERDAYS   number of days user keys are valid, default 90 days"
echo    "   USERHOME     location of admin user directory, default is /home/"
echo    "                Many sites have different home directories (/u/north-office/)"
echo    "   ADMTLSUSER   administration user creating TLS accounts, default is user"
echo    "                running script"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS"
echo -e "\nEXAMPLES\n   ${0} bob 30 /u/north-office/ uadmin\n\n   Create TLS keys for user bob for 30 days in /u/north-office/ uadmin"
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
TLSUSER=${1:-${USER}}
NUMBERDAYS=${2:-90}
#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  3 ]  ; then USERHOME=${3} ; elif [ "${USERHOME}" == "" ] ; then USERHOME="/home/" ; fi
ADMTLSUSER=${4:-${USER}}
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  TLSUSER >${TLSUSER}< NUMBERDAYS >${NUMBERDAYS}< USERHOME >${USERHOME}< ADMTLSUSER >${ADMTLSUSER}<" 1>&2 ; fi

#	Check if admin user has home directory on system
if [ ! -d ${USERHOME}${ADMTLSUSER} ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}   ${ADMTLSUSER} does not have a home directory on this system or ${ADMTLSUSER} home directory is not ${USERHOME}${ADMTLSUSER}" 1>&2
	exit 1
fi

#	Check if site CA directory on system
if [ ! -d ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}   Default directory, ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private, not on system." 1>&2
	#	Help hint
	echo -e "\n\tRunning create-site-private-public-tls.sh will create directories"
	echo -e "\tand site private and public keys.  Then run sudo"
	echo -e "\tcreate-new-openssl.cnf-tls.sh to modify openssl.cnf file.  Then run"
	echo -e "\tcreate-host-tls.sh or create-user-tls.sh as many times as you want."
	exit 1
fi
cd ${USERHOME}${ADMTLSUSER}/.docker/docker-ca

#	Check if ca-priv-key.pem file on system
if ! [ -e ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}   Site private key ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem is not in this location." 1>&2
	#	Help hint
	echo -e "\n\tEither move it from your site secure location to"
	echo -e "\t${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/"
	echo -e "\tOr run create-site-private-public-tls.sh and sudo"
	echo -e "\tcreate-new-openssl.cnf-tls.sh to create a new one."
	exit 1
fi

#	Check if ${TLSUSER}-user-priv-key.pem file on system
if [ -e ${TLSUSER}-user-priv-key.pem ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}   ${TLSUSER}-user-priv-key.pem already exists, renaming existing keys so new keys can be created." 1>&2
	mv ${TLSUSER}-user-priv-key.pem ${TLSUSER}-user-priv-key.pem$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)
	mv ${TLSUSER}-user-cert.pem ${TLSUSER}-user-cert.pem$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)
fi

#	Creating private key for user ${TLSUSER}
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Creating private key for user ${TLSUSER}." 1>&2
openssl genrsa -out ${TLSUSER}-user-priv-key.pem 2048

#	Generate a Certificate Signing Request (CSR)
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Generate a Certificate Signing Request (CSR) for user ${TLSUSER}." 1>&2
openssl req -subj '/subjectAltName=client' -new -key ${TLSUSER}-user-priv-key.pem -out ${TLSUSER}-user.csr

#	Create and sign a ${NUMBERDAYS} day certificate
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Create and sign a ${NUMBERDAYS} day certificate for user ${TLSUSER}." 1>&2
openssl x509 -req -days ${NUMBERDAYS} -sha256 -in ${TLSUSER}-user.csr -CA ca.pem -CAkey .private/ca-priv-key.pem -CAcreateserial -out ${TLSUSER}-user-cert.pem || { get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Wrong pass phrase for .private/ca-priv-key.pem:" ; exit 1; }

#	Removing certificate signing requests (CSR)
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Removing certificate signing requests (CSR) and set file permissions for ${TLSUSER} key pairs." 1>&2
rm ${TLSUSER}-user.csr
chmod 0400 ${TLSUSER}-user-priv-key.pem
chmod 0444 ${TLSUSER}-user-cert.pem

#	Help hint
echo -e "\nUse script ${BOLD}copy-user-2-remote-host-tls.sh${NORMAL} to update remote host."

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
