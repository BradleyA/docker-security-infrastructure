#!/bin/bash
# 	docker-TLS/check-host-tls.sh  3.195.630  2019-04-08T14:09:38.415315-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  six-rpi3b.cptx86.com 3.194  
# 	   update help hints #38 
# 	docker-TLS/check-host-tls.sh  3.194.629  2019-04-08T13:53:32.011184-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  six-rpi3b.cptx86.com 3.193  
# 	   update display_help, add new user messaging 
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
DEFAULT_CERTDIR="/etc/docker/certs.d/daemon/"
### production standard 0.3.158 --help
display_help() {
echo -e "\n${NORMAL}${0} - Check public, private keys, and CA for host"
echo -e "\nUSAGE"
echo    "   sudo ${0} [<CERTDIR>]"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION"
#       Displaying help DESCRIPTION in English en_US.UTF-8
echo    "This script has to be run as root to check public, private keys, and CA in"
echo    "/etc/docker/certs.d/daemon directory.  This directory was selected to place"
echo    "dockerd TLS certifications because docker registry stores it's TLS"
echo    "certifications in /etc/docker/certs.d.  The certification files and"
echo    "directory permissions are also checked."
echo -e "\nThis script works for the local host only.  To use check-host-tls.sh on a"
echo    "remote hosts (one-rpi3b.cptx86.com) with ssh port of 12323 as uadmin user;"
echo -e "\t${BOLD}ssh -tp 12323 uadmin@one-rpi3b.cptx86.com 'sudo check-host-tls.sh'${NORMAL}"
echo    "To loop through a list of hosts in the cluster use,"
echo    "https://github.com/BradleyA/Linux-admin/tree/master/cluster-command"
echo -e "\t${BOLD}cluster-command.sh special 'sudo check-host-tls.sh'${NORMAL}"
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
echo -e "\nOPTIONS"
echo -e "   CERTDIR     dockerd certification directory (default ${DEFAULT_CERTDIR})"
### production standard 6.3.163 Architecture tree
echo -e "\nARCHITECTURE TREE"   # STORAGE & CERTIFICATION
echo    "/etc/ "
echo    "   docker/ "
echo    "   └── certs.d/                           <-- Host docker cert directory"
echo    "       └── daemon/                        <-- Daemon cert directory"
echo    "           ├── ca.pem                     <-- Daemon tlscacert"
echo    "           ├── cert.pem                   <-- Daemon tlscert"
echo    "           └── key.pem                    <-- Daemon tlskey"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-security-infrastructure/tree/master/docker-TLS"
echo -e "\nEXAMPLES"
echo    "   Administration user checks local host TLS public, private keys,"
echo    "   CA, and file and directory permissions."
echo -e "\t${BOLD}sudo ${0}${NORMAL}"
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
CERTDIR=${1:-${DEFAULT_CERTDIR}}
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  CERTDIR >${CERTDIR}<<" 1>&2 ; fi
#	Must be root to run this script
if ! [ $(id -u) = 0 ] ; then
	display_help | more
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Use sudo ${0}" 1>&2
#	Help hint
	echo -e "\n\t${BOLD}>>   SCRIPT MUST BE RUN AS ROOT   <<\n${NORMAL}"  1>&2
	exit 1
fi
#	Check for ${CERTDIR} directory
if [ ! -d ${CERTDIR} ] ; then
	display_help | more
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${CERTDIR} does not exist" 1>&2
	exit 1
fi

#	Get currect date in seconds
CURRENT_DATE_SECONDS=$(date '+%s')

#	Get currect date in seconds add 30 days
CURRENT_DATE_SECONDS_PLUS_30_DAYS=$(date '+%s' -d '+30 days')
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... CURRENT_DATE_SECONDS >${CURRENT_DATE_SECONDS}< CURRENT_DATE_SECONDS_PLUS_30_DAYS >${CURRENT_DATE_SECONDS_PLUS_30_DAYS=}<" 1>&2 ; fi

get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Checking ${BOLD}${REMOTEHOST}${NORMAL} TLS certifications and directory permissions." 1>&2

#	View dockerd daemon certificate expiration date of ca.pem file
HOST_EXPIRE_DATE=$(openssl x509 -in "${CERTDIR}/ca.pem" -noout -enddate  | cut -d '=' -f 2)
HOST_EXPIRE_SECONDS=$(date -d "${HOST_EXPIRE_DATE}" '+%s')
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... HOST_EXPIRE_DATE >${HOST_EXPIRE_DATE}< HOST_EXPIRE_SECONDS >${HOST_EXPIRE_SECONDS}<" 1>&2 ; fi

#	Check if certificate has expired
if [ "${HOST_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS}" ] ; then

#	Check if certificate will expire in the next 30 day
	if [ "${HOST_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS_PLUS_30_DAYS}" ] ; then
		echo -e "\n\tCertificate on ${LOCALHOST}, ${CERTDIR}/ca.pem, is  ${BOLD}GOOD${NORMAL}  until ${HOST_EXPIRE_DATE}"
	else
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Certificate on ${LOCALHOST}, ${CERTDIR}/ca.pem,  ${BOLD}EXPIRES${NORMAL}  on ${HOST_EXPIRE_DATE}" 1>&2
#		Help hint
		echo -e "\n\t${BOLD}Use script  create-site-private-public-tls.sh  to update expired host TLS.${NORMAL}"
	fi
else
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Certificate on ${LOCALHOST},  ${CERTDIR}/ca.pem,  ${BOLD}HAS EXPIRED${NORMAL}  on ${HOST_EXPIRE_DATE}" 1>&2
#	Help hint
	echo -e "\n\t${BOLD}Use script  create-site-private-public-tls.sh  to update expired host TLS.${NORMAL}"
fi


#	View dockerd daemon certificate expiration date of cert.pem file
HOST_EXPIRE_DATE=$(openssl x509 -in "${CERTDIR}/cert.pem" -noout -enddate  | cut -d '=' -f 2)
HOST_EXPIRE_SECONDS=$(date -d "${HOST_EXPIRE_DATE}" '+%s')
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... HOST_EXPIRE_DATE >${HOST_EXPIRE_DATE}< HOST_EXPIRE_SECONDS >${HOST_EXPIRE_SECONDS}<" 1>&2 ; fi

#	Check if certificate has expired
if [ "${HOST_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS}" ] ; then

#	Check if certificate will expire in the next 30 day
	if [ "${HOST_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS_PLUS_30_DAYS}" ] ; then
		echo -e "\n\tCertificate on ${LOCALHOST}, ${CERTDIR}/cert.pem, is  ${BOLD}GOOD${NORMAL}  until ${HOST_EXPIRE_DATE}"
	else
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Certificate on ${LOCALHOST}, ${CERTDIR}/cert.pem,  ${BOLD}EXPIRES${NORMAL}  on ${HOST_EXPIRE_DATE}" 1>&2
#		Help hint
		echo -e "\n\t${BOLD}Use script  create-host-tls.sh  to update expired host TLS.${NORMAL}"
	fi
else
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Certificate on ${LOCALHOST},  ${CERTDIR}/cert.pem,  ${BOLD}HAS EXPIRED${NORMAL}  on ${HOST_EXPIRE_DATE}" 1>&2
#	Help hint
	echo -e "\n\t${BOLD}Use script  create-host-tls.sh  to update expired host TLS.${NORMAL}"

#	View dockerd daemon certificate issuer data of the ca.pem file
TEMP=$(openssl x509 -in ${CERTDIR}/ca.pem -noout -issuer)
echo -e "\nView dockerd daemon certificate issuer data of the ca.pem file:\n\t${BOLD}${TEMP}${NORMAL}"

#	View dockerd daemon certificate issuer data of the cert.pem file
TEMP=$(openssl x509 -in ${CERTDIR}/cert.pem -noout -issuer)
echo -e "\nView dockerd daemon certificate issuer data of the cert.pem file:\n\t${BOLD}${TEMP}${NORMAL}"

#	Verify that dockerd daemon certificate was issued by the CA.
TEMP=$(openssl verify -verbose -CAfile ${CERTDIR}/ca.pem ${CERTDIR}cert.pem)
echo -e "\nVerify that dockerd daemon certificate was issued by the CA:\n\t${BOLD}${TEMP}${NORMAL}"

echo -e "\nVerify and correct file permissions."

#	Verify and correct file permissions for ${CERTDIR}/ca.pem
if [ $(stat -Lc %a ${CERTDIR}/ca.pem) != 444 ]; then
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File permissions for ${CERTDIR}ca.pem are not 444.  Correcting $(stat -Lc %a ${CERTDIR}/ca.pem) to 0444 file permissions." 1>&2
	chmod 0444 ${CERTDIR}ca.pem
fi

#	Verify and correct file permissions for ${CERTDIR}cert.pem
if [ $(stat -Lc %a ${CERTDIR}/cert.pem) != 444 ]; then
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File permissions for ${CERTDIR}cert.pem are not 444.  Correcting $(stat -Lc %a ${CERTDIR}/cert.pem) to 0444 file permissions." 1>&2
	chmod 0444 ${CERTDIR}/cert.pem
fi

#	Verify and correct file permissions for ${CERTDIR}/key.pem
if [ $(stat -Lc %a ${CERTDIR}/key.pem) != 400 ]; then
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File permissions for ${CERTDIR}key.pem are not 400.  Correcting $(stat -Lc %a ${CERTDIR}/key.pem) to 0400 file permissions." 1>&2
	chmod 0400 ${CERTDIR}/key.pem
fi

#	Verify and correct directory permissions for ${CERTDIR} directory
if [ $(stat -Lc %a ${CERTDIR}) != 700 ]; then
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Directory permissions for ${CERTDIR} are not 700.  Correcting $(stat -Lc %a ${CERTDIR}) to 700 directory permissions." 1>&2
	chmod 700 ${CERTDIR}
fi

#	Help hint
echo -e "\nUse script ${BOLD}create-host-tls.sh${NORMAL} to update host TLS if host TLS certificate has expired."
 
#	May want to create a version of this script that automates this process for SRE tools,
#	but keep this script for users to run manually,
#	open ticket and remove this comment

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
