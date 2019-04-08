#!/bin/bash
# 	docker-TLS/check-user-tls.sh  3.193.628  2019-04-07T23:33:38.178076-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  six-rpi3b.cptx86.com 3.192  
# 	   update display_help 
# 	docker-TLS/check-user-tls.sh  3.192.627  2019-04-07T19:42:17.244111-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  six-rpi3b.cptx86.com 3.191-8-gc662f79  
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
echo    "   sudo ${0} <user-name>."
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
echo    "   TLS_USER    Administration user (default ${DEFAULT_TLS_USER})"
echo    "   USER_HOME   Location of user home directory (default ${DEFAULT_USER_HOME})"
echo    "               sites have different home directory locations (/u/north-office/)"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-security-infrastructure/tree/master/docker-TLS"
echo -e "\nEXAMPLES\n   User can check their certificates\n\t${BOLD}${0}${NORMAL}"
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
if [ $# -ge  2 ]  ; then USER_HOME=${2} ; elif [ "${USER_HOME}" == "" ] ; then USER_HOME="/home/" ; fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  TLS_USER >${TLS_USER}< USER_HOME >${USER_HOME}<" 1>&2 ; fi

#	Root is required to check other users or user can check their own certs
if ! [ $(id -u) = 0 -o ${USER} = ${TLS_USER} ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Use sudo ${0}  ${TLS_USER}" 1>&2
	echo -e "${BOLD}\n>>   SCRIPT MUST BE RUN AS ROOT TO CHECK <another-user>/.docker DIRECTORY. <<\n${NORMAL}"	1>&2
	exit 1
fi

#	Check if user has home directory on system
if [ ! -d ${USER_HOME}${TLS_USER} ] ; then 
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${TLS_USER} does not have a home directory on this system or ${TLS_USER} home directory is not ${USER_HOME}${TLS_USER}." 1>&2
	exit 1
fi

#	Check if user has .docker directory
if [ ! -d ${USER_HOME}${TLS_USER}/.docker ] ; then 
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${TLS_USER} does not have a .docker directory." 1>&2
	exit 1
fi

#	Check if user has .docker ca.pem file
if [ ! -e ${USER_HOME}${TLS_USER}/.docker/ca.pem ] ; then 
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${TLS_USER} does not have a .docker/ca.pem file." 1>&2
	exit 1
fi

#	Check if user has .docker cert.pem file
if [ ! -e ${USER_HOME}${TLS_USER}/.docker/cert.pem ] ; then 
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${TLS_USER} does not have a .docker/cert.pem file." 1>&2
	exit 1
fi

#	Check if user has .docker key.pem file
if [ ! -e ${USER_HOME}${TLS_USER}/.docker/key.pem ] ; then 
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${TLS_USER} does not have a .docker/key.pem file." 1>&2
	exit 1
fi

#	View user certificate expiration date of ca.pem file
TEMP=$(openssl x509 -in  ${USER_HOME}${TLS_USER}/.docker/ca.pem -noout -enddate)
echo -e "\n\t${NORMAL}View ${USER_HOME}${TLS_USER}/.docker certificate ${BOLD}expiration date of ca.pem ${NORMAL}file:\n\t${BOLD}${TEMP}${NORMAL}"

#	View user certificate expiration date of cert.pem file
TEMP=$(openssl x509 -in ${USER_HOME}${TLS_USER}/.docker/cert.pem -noout -enddate)
echo -e "\n\tView ${USER_HOME}${TLS_USER}/.docker certificate ${BOLD}expiration date of cert.pem ${NORMAL}file:\n\t${BOLD}${TEMP}${NORMAL}"

#	View user certificate issuer data of the ca.pem file.
TEMP=$(openssl x509 -in ${USER_HOME}${TLS_USER}/.docker/ca.pem -noout -issuer)
echo -e "\n\tView ${USER_HOME}${TLS_USER}/.docker certificate ${BOLD}issuer data of the ca.pem ${NORMAL}file:\n\t${BOLD}${TEMP}${NORMAL}"

#	View user certificate issuer data of the cert.pem file.
TEMP=$(openssl x509 -in ${USER_HOME}${TLS_USER}/.docker/cert.pem -noout -issuer)
echo -e "\n\tView ${USER_HOME}${TLS_USER}/.docker certificate ${BOLD}issuer data of the cert.pem ${NORMAL}file:\n\t${BOLD}${TEMP}${NORMAL}"

#	Verify that user public key in your certificate matches the public portion of your private key.
echo -e "\n\tVerify that user public key in your certificate matches the public portion\n\tof your private key."
(cd ${USER_HOME}${TLS_USER}/.docker ; openssl x509 -noout -modulus -in cert.pem | openssl md5 ; openssl rsa -noout -modulus -in key.pem | openssl md5) | uniq
echo -e "\t${BOLD}[WARN]${NORMAL}  -> If ONLY ONE line of output is returned then the public key\n\tmatches the public portion of your private key.\n"

#	Verify that user certificate was issued by the CA.
echo -e "\t${NORMAL}Verify that user certificate was issued by the CA:${BOLD}\t"
openssl verify -verbose -CAfile ${USER_HOME}${TLS_USER}/.docker/ca.pem ${USER_HOME}${TLS_USER}/.docker/cert.pem  || { get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  User certificate for ${TLS_USER} on ${LOCALHOST} was NOT issued by CA." ; exit 1; }

#	Verify and correct file permissions for ${USER_HOME}${TLS_USER}/.docker/ca.pem
echo -e "\n\t${NORMAL}Verify and correct file permissions for ${USER_HOME}${TLS_USER}/.docker"
if [ $(stat -Lc %a ${USER_HOME}${TLS_USER}/.docker/ca.pem) != 444 ]; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File permissions for ${USER_HOME}${TLS_USER}/.docker/ca.pem are not 444.  Correcting $(stat -Lc %a ${USER_HOME}${TLS_USER}/.docker/ca.pem) to 0444 file permissions" 1>&2
	chmod 0444 ${USER_HOME}${TLS_USER}/.docker/ca.pem
fi

#	Verify and correct file permissions for ${USER_HOME}${TLS_USER}/.docker/cert.pem
if [ $(stat -Lc %a ${USER_HOME}${TLS_USER}/.docker/cert.pem) != 444 ]; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File permissions for ${USER_HOME}${TLS_USER}/.docker/cert.pem are not 444.  Correcting $(stat -Lc %a ${USER_HOME}${TLS_USER}/.docker/cert.pem) to 0444 file permissions" 1>&2
	chmod 0444 ${USER_HOME}${TLS_USER}/.docker/cert.pem
fi

#	Verify and correct file permissions for ${USER_HOME}${TLS_USER}/.docker/key.pem
if [ $(stat -Lc %a ${USER_HOME}${TLS_USER}/.docker/key.pem) != 400 ]; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File permissions for ${USER_HOME}${TLS_USER}/.docker/key.pem are not 400.  Correcting $(stat -Lc %a ${USER_HOME}${TLS_USER}/.docker/key.pem) to 0400 file permissions" 1>&2
	chmod 0400 ${USER_HOME}${TLS_USER}/.docker/key.pem
fi

#	Verify and correct directory permissions for ${USER_HOME}${TLS_USER}/.docker directory
if [ $(stat -Lc %a ${USER_HOME}${TLS_USER}/.docker) != 700 ]; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Directory permissions for ${USER_HOME}${TLS_USER}/.docker\n\tare not 700.  Correcting $(stat -Lc %a ${USER_HOME}${TLS_USER}/.docker) to 700 directory permissions" 1>&2
	chmod 700 ${USER_HOME}${TLS_USER}/.docker
fi

#	Help hint
echo -e "\n\tUse script ${BOLD}create-user-tls.sh${NORMAL} to update user TLS if user TLS certificate\n\thas expired."
 
# >>>	May want to create a version of this script that automates this process for SRE tools,
# >>>		but keep this script for users to run manually,
# >>>	open ticket and remove this comment

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
