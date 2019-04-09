#!/bin/bash
# 	docker-TLS/check-user-tls.sh  3.199.634  2019-04-09T00:11:09.925555-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  six-rpi3b.cptx86.com 3.198  
# 	   update copy-host-2-remote-host-tls.sh 
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
DEFAULT_TLS_USER="${USER}"
DEFAULT_USER_HOME="/home/"
### production standard 0.3.158 --help
display_help() {
echo -e "\n${NORMAL}${0} - Check public, private keys, and CA for a user"
echo -e "\nUSAGE"
echo    "   ${0} [<TLS_USER>]"
echo    "   ${0}  <TLS_USER> [<USER_HOME>]"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION"
#       Displaying help DESCRIPTION in English en_US.UTF-8
echo    "Users can check their public, private keys, and CA in /home/ or other"
echo    "non-default home directories.  The file and directory permissions are also"
echo    "checked.  Administrators can check other users certificates by using"
echo -e "\t${BOLD}sudo ${0} <user-name>${NORMAL}"
echo    "To loop through a list of hosts in the cluster use,"
echo    "https://github.com/BradleyA/Linux-admin/tree/master/cluster-command"
echo -e "\t${BOLD}cluster-command.sh special 'sudo ${0} <user-name>'${NORMAL}"
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
echo -e "\nOPTIONS"
echo    "   TLS_USER    Administration user (default ${DEFAULT_TLS_USER})"
echo    "   USER_HOME   Location of user home directory (default ${DEFAULT_USER_HOME})"
echo    "               sites have different home directory locations (/u/north-office/)"
### production standard 6.3.163 Architecture tree
echo -e "\nARCHITECTURE TREE"   # STORAGE & CERTIFICATION
echo    "~<USER-1>/.docker/                        <-- User docker cert directory"
echo    "   ├── ca.pem                             <-- Symbolic link to user tlscacert"
echo    "   ├── cert.pem                           <-- Symbolic link to user tlscert"
echo -e "   └── key.pem                            <-- Symbolic link to user tlskey\n"
echo    "/usr/local/data/                          <-- <DATA_DIR>"
echo    "   <CLUSTER>/                             <-- <CLUSTER>"
echo    "   └── docker-accounts/                   <-- Docker TLS certs"
echo    "       ├── <HOST-1>/                      <-- Host in cluster"
echo    "       │   ├── <USER-1>/                  <-- User TLS certs directory"
echo    "       │   │   ├── ca.pem                 <-- User tlscacert"
echo    "       │   │   ├── cert.pem               <-- User tlscert"
echo    "       │   │   └── key.pem                <-- User tlskey"
echo    "       │   └── <USER-2>/                  <-- User TLS certs directory"
echo    "       └── <HOST-2>/                      <-- Host in cluster"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-security-infrastructure/tree/master/docker-TLS"
echo -e "\nEXAMPLES"
echo -e "   User can check their certificates\n\t${BOLD}${0}${NORMAL}"
echo -e "   User sam checks their certificates in a non-default home directory\n\t${BOLD}${0} sam /u/north-office/${NORMAL}"
echo -e "   Administrator user checks user bob certificates\n\t${BOLD}sudo ${0} bob${NORMAL}"
echo -e "   Administrator checks user sam certificates in a different home directory\n\t${BOLD}sudo ${0} sam /u/north-office/${NORMAL}"
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
TLS_USER=${1:-${DEFAULT_TLS_USER}}
#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  2 ]  ; then USER_HOME=${2} ; elif [ "${USER_HOME}" == "" ] ; then USER_HOME="${DEFAULT_USER_HOME}" ; fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  TLS_USER >${TLS_USER}< USER_HOME >${USER_HOME}<" 1>&2 ; fi

#	Root is required to check other users or user can check their own certs
if ! [ $(id -u) = 0 -o ${USER} = ${TLS_USER} ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Use sudo ${0}  ${TLS_USER}" 1>&2
#       Help hint
	echo -e "\n>>   ${BOLD}SCRIPT MUST BE RUN AS ROOT${NORMAL} <<"  1>&2
	exit 1
fi

#	Check if user has home directory on system
if [ ! -d "${USER_HOME}${TLS_USER}" ] ; then 
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${TLS_USER} does not have a home directory on this system, ${LOCALHOST}, or ${TLS_USER} home directory is not ${USER_HOME}${TLS_USER}." 1>&2
	exit 1
fi

#	Check if user has .docker directory
if [ ! -d "${USER_HOME}${TLS_USER}/.docker" ] ; then 
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${TLS_USER} does not have a .docker directory." 1>&2
	exit 1
fi

#	Check if user has .docker ca.pem file
if [ ! -e "${USER_HOME}${TLS_USER}/.docker/ca.pem" ] ; then 
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${TLS_USER} does not have a .docker/ca.pem file." 1>&2
#       Help hint
	echo -e "\n\tRunning create-user-tls.sh will create public and private keys."
	exit 1
fi

#	Check if user has .docker cert.pem file
if [ ! -e "${USER_HOME}${TLS_USER}/.docker/cert.pem" ] ; then 
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${TLS_USER} does not have a .docker/cert.pem file." 1>&2
#       Help hint
	echo -e "\n\tRunning create-user-tls.sh will create public and private keys."
	exit 1
fi

#	Check if user has .docker key.pem file
if [ ! -e "${USER_HOME}${TLS_USER}/.docker/key.pem" ] ; then 
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${TLS_USER} does not have a .docker/key.pem file." 1>&2
#       Help hint
	echo -e "\n\tRunning create-user-tls.sh will create public and private keys."
	exit 1
fi

#       Get currect date in seconds
CURRENT_DATE_SECONDS=$(date '+%s')

#       Get currect date in seconds add 30 days
CURRENT_DATE_SECONDS_PLUS_30_DAYS=$(date '+%s' -d '+30 days')
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... CURRENT_DATE_SECONDS >${CURRENT_DATE_SECONDS}< CURRENT_DATE_SECONDS_PLUS_30_DAYS >${CURRENT_DATE_SECONDS_PLUS_30_DAYS=}<" 1>&2 ; fi

#	View user certificate expiration date of ca.pem file
USER_EXPIRE_DATE=$(openssl x509 -in "${USER_HOME}${TLS_USER}/.docker/ca.pem" -noout -enddate | cut -d '=' -f 2)
USER_EXPIRE_SECONDS=$(date -d "${USER_EXPIRE_DATE}" '+%s')
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... USER_EXPIRE_DATE >${USER_EXPIRE_DATE}< USER_EXPIRE_SECONDS >${USER_EXPIRE_SECONDS}<" 1>&2 ; fi

#       Check if certificate has expired
if [ "${USER_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS}" ] ; then

#       Check if certificate will expire in the next 30 day
        if [ "${USER_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS_PLUS_30_DAYS}" ] ; then
                echo -e "\n\tCertificate on ${LOCALHOST}, ${USER_HOME}${TLS_USER}/.docker/ca.pem, is  ${BOLD}GOOD${NORMAL}  until ${USER_EXPIRE_DATE}"
        else
                get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Certificate on ${LOCALHOST}, ${USER_HOME}${TLS_USER}/.docker/ca.pem,  ${BOLD}EXPIRES${NORMAL}  on ${USER_EXPIRE_DATE}" 1>&2
#               Help hint
                echo -e "\n\t${BOLD}Use script  create-user-tls.sh  to update expired user TLS.${NORMAL}"
        fi
else
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Certificate on ${LOCALHOST},  ${USER_HOME}${TLS_USER}/.docker/ca.pem,  ${BOLD}HAS EXPIRED${NORMAL}  on ${USER_EXPIRE_DATE}" 1>&2
#       Help hint
        echo -e "\n\t${BOLD}Use script  create-user-tls.sh  to update expired user TLS.${NORMAL}"
fi

#	View user certificate expiration date of cert.pem file
USER_EXPIRE_DATE=$(openssl x509 -in "${USER_HOME}${TLS_USER}/.docker/cert.pem" -noout -enddate  | cut -d '=' -f 2)
USER_EXPIRE_SECONDS=$(date -d "${USER_EXPIRE_DATE}" '+%s')
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... USER_EXPIRE_DATE >${USER_EXPIRE_DATE}< USER_EXPIRE_SECONDS >${USER_EXPIRE_SECONDS}<" 1>&2 ; fi

#       Check if certificate has expired
if [ "${USER_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS}" ] ; then

#       Check if certificate will expire in the next 30 day
        if [ "${USER_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS_PLUS_30_DAYS}" ] ; then
                echo -e "\n\tCertificate on ${LOCALHOST}, ${USER_HOME}${TLS_USER}/.docker/cert.pem, is  ${BOLD}GOOD${NORMAL}  until ${USER_EXPIRE_DATE}"
        else
                get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Certificate on ${LOCALHOST}, ${USER_HOME}${TLS_USER}/.docker/cert.pem,  ${BOLD}EXPIRES${NORMAL}  on ${USER_EXPIRE_DATE}" 1>&2
#               Help hint
                echo -e "\n\t${BOLD}Use script  create-user-tls.sh  to update expired user TLS.${NORMAL}"
        fi
else
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Certificate on ${LOCALHOST}, ${USER_HOME}${TLS_USER}/.docker/cert.pem,  ${BOLD}HAS EXPIRED${NORMAL}  on ${USER_EXPIRE_DATE}" 1>&2
#       Help hint
        echo -e "\n\t${BOLD}Use script  create-user-tls.sh  to update expired user TLS.${NORMAL}"
fi

#	View user certificate issuer data of the ca.pem file.
TEMP=$(openssl x509 -in "${USER_HOME}${TLS_USER}/.docker/ca.pem" -noout -issuer)
echo -e "\n\tView ${USER_HOME}${TLS_USER}/.docker certificate ${BOLD}issuer data of the ca.pem ${NORMAL}file:\n\t${BOLD}${TEMP}${NORMAL}"

#	View user certificate issuer data of the cert.pem file.
TEMP=$(openssl x509 -in "${USER_HOME}${TLS_USER}/.docker/cert.pem" -noout -issuer)
echo -e "\n\tView ${USER_HOME}${TLS_USER}/.docker certificate ${BOLD}issuer data of the cert.pem ${NORMAL}file:\n\t${BOLD}${TEMP}${NORMAL}"

#	Verify that user public key in your certificate matches the public portion of your private key.
echo -e "\n\tVerify that user public key in your certificate matches the public portion\n\tof your private key."
(cd "${USER_HOME}${TLS_USER}/.docker" ; openssl x509 -noout -modulus -in cert.pem | openssl md5 ; openssl rsa -noout -modulus -in key.pem | openssl md5) | uniq
echo -e "\t${BOLD}[WARN]${NORMAL}  -> If ONLY ONE line of output is returned then the public key\n\tmatches the public portion of your private key.\n"

#	Verify that user certificate was issued by the CA.
echo -e "\t${NORMAL}Verify that user certificate was issued by the CA:${BOLD}\t"
openssl verify -verbose -CAfile "${USER_HOME}${TLS_USER}/.docker/ca.pem" "${USER_HOME}${TLS_USER}/.docker/cert.pem"  || { get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  User certificate for ${TLS_USER} on ${LOCALHOST} was NOT issued by CA." ; exit 1; }

#	Verify and correct file permissions for ${USER_HOME}${TLS_USER}/.docker/ca.pem
echo -e "\n\t${NORMAL}Verify and correct file permissions for ${USER_HOME}${TLS_USER}/.docker"
if [ $(stat -Lc %a "${USER_HOME}${TLS_USER}/.docker/ca.pem") != 444 ]; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File permissions for ${USER_HOME}${TLS_USER}/.docker/ca.pem are not 444.  Correcting $(stat -Lc %a ${USER_HOME}${TLS_USER}/.docker/ca.pem) to 0444 file permissions" 1>&2
	chmod 0444 "${USER_HOME}${TLS_USER}/.docker/ca.pem"
fi

#	Verify and correct file permissions for ${USER_HOME}${TLS_USER}/.docker/cert.pem
if [ $(stat -Lc %a "${USER_HOME}${TLS_USER}/.docker/cert.pem") != 444 ]; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File permissions for ${USER_HOME}${TLS_USER}/.docker/cert.pem are not 444.  Correcting $(stat -Lc %a ${USER_HOME}${TLS_USER}/.docker/cert.pem) to 0444 file permissions" 1>&2
	chmod 0444 "${USER_HOME}${TLS_USER}/.docker/cert.pem"
fi

#	Verify and correct file permissions for ${USER_HOME}${TLS_USER}/.docker/key.pem
if [ $(stat -Lc %a "${USER_HOME}${TLS_USER}/.docker/key.pem") != 400 ]; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File permissions for ${USER_HOME}${TLS_USER}/.docker/key.pem are not 400.  Correcting $(stat -Lc %a ${USER_HOME}${TLS_USER}/.docker/key.pem) to 0400 file permissions" 1>&2
	chmod 0400 "${USER_HOME}${TLS_USER}/.docker/key.pem"
fi

#	Verify and correct directory permissions for ${USER_HOME}${TLS_USER}/.docker directory
if [ $(stat -Lc %a "${USER_HOME}${TLS_USER}/.docker") != 700 ]; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Directory permissions for ${USER_HOME}${TLS_USER}/.docker\n\tare not 700.  Correcting $(stat -Lc %a ${USER_HOME}${TLS_USER}/.docker) to 700 directory permissions" 1>&2
	chmod 700 "${USER_HOME}${TLS_USER}/.docker"
fi

#	Help hint
echo -e "\n\tUse script ${BOLD}create-user-tls.sh${NORMAL} to update user TLS if user TLS certificate\n\thas expired."
 
# >>>	May want to create a version of this script that automates this process for SRE tools,
# >>>		but keep this script for users to run manually,
# >>>	open ticket and remove this comment

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
