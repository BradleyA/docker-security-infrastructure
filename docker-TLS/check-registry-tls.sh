#!/bin/bash
# 	docker-TLS/check-registry-tls.sh  3.256.723  2019-06-07T21:05:02.596704-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.255  
# 	   docker-TLS/c* - added production standard 8.0 --usage #52 
# 	docker-TLS/check-registry-tls.sh  3.232.677  2019-04-10T23:04:43.569614-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  six-rpi3b.cptx86.com 3.231  
# 	   production standard 6.1.177 Architecture tree 
### production standard 3.0 shellcheck
### production standard 5.1.160 Copyright
#	Copyright (c) 2019 Bradley Allen
#	MIT License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
### production standard 1.0 DEBUG variable
#	Order of precedence: environment variable, default code
if [ "${DEBUG}" == "" ] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
#	set -x
#	set -v
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
### production standard 7.0 Default variable value
DEFAULT_REGISTRY_HOST=$(hostname -f)    # local host
DEFAULT_REGISTRY_PORT="5000"
DEFAULT_CLUSTER="us-tx-cluster-1/"
DEFAULT_DATA_DIR="/usr/local/data/"
### production standard 8.0 --usage
display_usage() {
echo -e "\n${NORMAL}${0} - Check certifications for private registry"
echo -e "\nUSAGE"
echo    "   ${0} [<REGISTRY_HOST>]"
echo    "   ${0}  <REGISTRY_HOST> [<REGISTRY_PORT>]"
echo    "   ${0}  <REGISTRY_HOST>  <REGISTRY_PORT> [<CLUSTER>]"
echo -e "   ${0}  <REGISTRY_HOST>  <REGISTRY_PORT>  <CLUSTER> [<DATA_DIR>]\n"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--usage | -usage | -u]"
echo    "   ${0} [--version | -version | -v]"
}
### production standard 0.1.158 --help
display_help() {
display_usage
#	Displaying help DESCRIPTION in English en_US.UTF-8
echo -e "\nDESCRIPTION"
echo    "This script has to be run as root to check daemon registry cert (ca.crt),"
echo    "registry cert (domain.crt), and registry private key (domain.key) in"
echo    "/etc/docker/certs.d/<REGISTRY_HOST>:<REGISTRY_PORT>/ and"
echo    "<DATA_DIR>/<CLUSTER>/docker-registry/<REGISTRY_HOST>-<REGISTRY_PORT>/certs/"
echo    "directories.  The certification files and directory permissions are also"
echo    "checked."
echo -e "\nThis script works for the local host only.  To use check-registry-tls.sh on a"
echo    "remote hosts (one-rpi3b.cptx86.com) with ssh port of 12323 as uadmin user;"
echo -e "\t${BOLD}ssh -tp 12323 uadmin@one-rpi3b.cptx86.com 'sudo check-registry-tls.sh two.cptx86.com 17313'${NORMAL}"
echo    "or"
echo -e "\t${BOLD}ssh -t uadmin@three-rpi3b.cptx86.com 'sudo check-registry-tls.sh two.cptx86.com 17313'${NORMAL}"
echo    "To loop through a list of hosts in the cluster use,"
echo    "https://github.com/BradleyA/Linux-admin/tree/master/cluster-command"
echo -e "\t${BOLD}cluster-command.sh special 'sudo check-registry-tls.sh two.cptx86.com 17313'${NORMAL}"
### production standard 4.0 Documentation Language
#	Displaying help DESCRIPTION in French fr_CA.UTF-8, fr_FR.UTF-8, fr_CH.UTF-8
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
echo    "   REGISTRY_HOST   Registry host (default '${DEFAULT_REGISTRY_HOST}')"
echo    "   REGISTRY_PORT   Registry port number (default '${DEFAULT_REGISTRY_PORT}')"
echo    "   CLUSTER         Cluster name (default '${DEFAULT_CLUSTER}')"
echo    "   DATA_DIR        Data directory (default '${DEFAULT_DATA_DIR}')"
echo -e "\nOPTIONS"
echo    "Order of precedence: CLI options, environment variable, default code."
echo    "   REGISTRY_HOST   Registry host (default '${DEFAULT_REGISTRY_HOST}')"
echo    "   REGISTRY_PORT   Registry port number (default '${DEFAULT_REGISTRY_PORT}')"
echo    "   CLUSTER         Cluster name (default '${DEFAULT_CLUSTER}')"
echo    "   DATA_DIR        Data directory (default '${DEFAULT_DATA_DIR}')"
### production standard 6.1.177 Architecture tree
echo -e "\nARCHITECTURE TREE"   # STORAGE & CERTIFICATION
echo    "/usr/local/data/                           <-- <DATA_DIR>"
echo    "└── <CLUSTER>/                             <-- <CLUSTER>"
echo    "    └── docker-registry/                   <-- Docker registry directory"
echo    "        ├── <REGISTRY_HOST>-<REGISTRY_PORT>/ < Registry container mount"
echo    "        │   ├── certs/                     <-- Registry cert directory"
echo    "        │   │   ├── domain.crt             <-- Registry cert"
echo    "        │   │   └── domain.key             <-- Registry private key"
echo    "        │   └── docker/                    <-- Registry storage directory"
echo    "        ├── <REGISTRY_HOST>-<REGISTRY_PORT>/ < Registry container mount"
echo -e "        └── <REGISTRY_HOST>-<REGISTRY_PORT>/ < Registry container mount\n"
echo    "/etc/ "
echo    "└── docker/ "
echo    "    └── certs.d/                           <-- Host docker cert directory"
echo    "        ├── <REGISTRY_HOST>:<REGISTRY_PORT>/ < Registry cert directory"
echo    "        │   └── ca.crt                     <-- Daemon registry domain cert"
echo    "        ├── <REGISTRY_HOST>:<REGISTRY_PORT>/ < Registry cert directory"
echo    "        └── <REGISTRY_HOST>:<REGISTRY_PORT>/ < Registry cert directory"
echo -e "\nDOCUMENTATION"
echo    "   https://github.com/BradleyA/docker-security-infrastructure/tree/master/docker-TLS"
echo -e "\nEXAMPLES"
echo -e "   Check local host certificates for <REGISTRY_HOST> (two.cptx86.com) using\n   <REGISTRY_PORT> (17313)\n	${BOLD}sudo ${0} two.cptx86.com 17313${NORMAL}"
echo -e "   Use cluster-command.sh script to loop through hosts in a cluster."
echo    "   Check each host certificates for <REGISTRY_HOST> (two.cptx86.com) using"
echo -e "   <REGISTRY_PORT> (17313)\n\t${BOLD}cluster-command.sh special 'sudo ${0} two.cptx86.com 17313${NORMAL}'"
}

#	Date and time function ISO 8601
get_date_stamp() {
DATE_STAMP=$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)
TEMP=$(date +%Z)
DATE_STAMP="${DATE_STAMP} (${TEMP})"
}

#	Fully qualified domain name FQDN hostname
LOCALHOST=$(hostname -f)

#	Version
SCRIPT_NAME=$(head -2 "${0}" | awk {'printf $2'})
SCRIPT_VERSION=$(head -2 "${0}" | awk {'printf $3'})

#	UID and GID
USER_ID=$(id -u)
GROUP_ID=$(id -g)

#	Added line because USER is not defined in crobtab jobs
if ! [ "${USER}" == "${LOGNAME}" ] ; then  USER=${LOGNAME} ; fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Setting USER to support crobtab...  USER >${USER}<  LOGNAME >${LOGNAME}<" 1>&2 ; fi

#	Default help, usage, and version arguments
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

### production standard 2.0 log format (WHEN WHERE WHAT Version Line WHO UID:GID [TYPE] Message)
#	INFO
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Started..." 1>&2

#	DEBUG
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Name_of_command >${0}< Name_of_arg1 >${1}< Name_of_arg2 >${2}< Name_of_arg3 >${3}<  Version of bash ${BASH_VERSION}" 1>&2 ; fi

###
#	Root is required to copy certs
if ! [ "$(id -u)" = 0 ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Use sudo ${0}" 1>&2
#	Help hint
	echo -e "\n\t${BOLD}>>   SCRIPT MUST BE RUN AS ROOT   <<\n${NORMAL}"    1>&2
	exit 1
fi

### production standard 7.0 Default variable value
#	Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  1 ]  ; then REGISTRY_HOST=${1} ; elif [ "${REGISTRY_HOST}" == "" ] ; then REGISTRY_HOST=${DEFAULT_REGISTRY_HOST} ; fi
if [ $# -ge  2 ]  ; then REGISTRY_PORT=${2} ; elif [ "${REGISTRY_PORT}" == "" ] ; then REGISTRY_PORT=${DEFAULT_REGISTRY_PORT} ; fi
if [ $# -ge  3 ]  ; then CLUSTER=${3} ; elif [ "${CLUSTER}" == "" ] ; then CLUSTER=${DEFAULT_CLUSTER} ; fi
if [ $# -ge  4 ]  ; then DATA_DIR=${4} ; elif [ "${DATA_DIR}" == "" ] ; then DATA_DIR=${DEFAULT_DATA_DIR} ; fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... REGISTRY_HOST >${REGISTRY_HOST}< REGISTRY_PORT >${REGISTRY_PORT}< CLUSTER >${CLUSTER}< DATA_DIR >${DATA_DIR}<" 1>&2 ; fi

#	Get currect date in seconds
CURRENT_DATE_SECONDS=$(date '+%s')

#	Get currect date in seconds add 30 days
CURRENT_DATE_SECONDS_PLUS_30_DAYS=$(date '+%s' -d '+30 days')
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... CURRENT_DATE_SECONDS >${CURRENT_DATE_SECONDS}< CURRENT_DATE_SECONDS_PLUS_30_DAYS >${CURRENT_DATE_SECONDS_PLUS_30_DAYS=}<" 1>&2 ; fi

#	Set REGISTRY_HOST_CERT variable to host entered during the creation of certificates
REGISTRY_HOST_CERT=$(openssl x509 -in "/etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt" -noout -issuer | cut -d '/' -f 7 | cut -d '=' -f 2)
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... REGISTRY_HOST >${REGISTRY_HOST}< REGISTRY_HOST_CERT >${REGISTRY_HOST_CERT}<" 1>&2 ; fi

#	Get registry certificate expiration date from ca.crt
REGISTRY_EXPIRE_DATE=$(openssl x509 -in "/etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt" -noout -enddate | cut -d '=' -f 2)
REGISTRY_EXPIRE_SECONDS=$(date -d "${REGISTRY_EXPIRE_DATE}" '+%s')
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... REGISTRY_EXPIRE_DATE >${REGISTRY_EXPIRE_DATE}< REGISTRY_EXPIRE_SECONDS >${REGISTRY_EXPIRE_SECONDS}<" 1>&2 ; fi

#	Check if ${REGISTRY_HOST_CERT} is NOT ${REGISTRY_HOST}
if ! [ "${REGISTRY_HOST_CERT}" == "${REGISTRY_HOST}" ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Certificate (/etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt) is for ${REGISTRY_HOST_CERT}  NOT  ${REGISTRY_HOST} " 1>&2
#	Help hint
	echo -e "\n\t${BOLD}Use script create-registry-tls.sh to correct registry TLS.${NORMAL}"
fi

#	Check if certificate has expired
if [ "${REGISTRY_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS}" ] ; then

#	Check if certificate will expire in the next 30 day
	if [ "${REGISTRY_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS_PLUS_30_DAYS}" ] ; then
		echo -e "\n\tCertificate on ${LOCALHOST}, /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt, is ${BOLD}GOOD${NORMAL} until ${REGISTRY_EXPIRE_DATE}"
	else
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Certificate on ${LOCALHOST}, /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt, ${BOLD}EXPIRES${NORMAL} on ${REGISTRY_EXPIRE_DATE}" 1>&2
#		Help hint
		echo -e "\n\t${BOLD}Use script create-registry-tls.sh to update expired registry TLS.${NORMAL}"
	fi
else
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Certificate on ${LOCALHOST}, /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt, ${BOLD}HAS EXPIRED${NORMAL} on ${REGISTRY_EXPIRE_DATE}" 1>&2
#	Help hint
	echo -e "\n\t${BOLD}Use script create-registry-tls.sh to update expired registry TLS.${NORMAL}"
fi

echo -e "\n\tVerify and correct file permissions."

#	Verify and correct file permissions for /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt
if [ $(stat -Lc %a "/etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt") != 400 ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File permissions for /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt are not 400.  Correcting $(stat -Lc %a /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt) to 0400 file permissions." 1>&2
	chmod 0400 "/etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt"
fi

#       Verify and correct directory permissions for /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ directory
if [ $(stat -Lc %a "/etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/") != 700 ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Directory permissions for /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ are not 700.  Correcting $(stat -Lc %a /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/) to 700 directory permissions." 1>&2
	chmod 700 "/etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/"
fi

###	${REGISTRY_HOST}
#	Check if ${LOCALHOST} is ${REGISTRY_HOST} running the private registry
if [ "${LOCALHOST}" == "${REGISTRY_HOST}" ] ; then

#	Check if private registry certificate directory
	if [ ! -d "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/" ] ; then
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]  Directory ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/ NOT found${NORMAL}" 1>&2
		exit 1
	fi

#	Check if domain.crt registry certificate exists and has size greater than zero
	if [ ! -s "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt" ] ; then
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]  File ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt does NOT exist or has file size equal to zero.${NORMAL}" 1>&2
#		Help hint
		echo -e "\n\t${BOLD}Use script create-registry-tls.sh to correct registry TLS.${NORMAL}"
		exit 1
	fi

#	Set REGISTRY_HOST_CERT variable to host entered during the creation of certificates
	REGISTRY_HOST_CERT=$(openssl x509 -in "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt" -noout -issuer | cut -d '/' -f 7 | cut -d '=' -f 2)
	if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... REGISTRY_HOST >${REGISTRY_HOST}< REGISTRY_HOST_CERT >${REGISTRY_HOST_CERT}<" 1>&2 ; fi
	if [ ! "${REGISTRY_HOST_CERT}" == "${REGISTRY_HOST}" ] ; then
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  The certificate, ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt, is for host ${REGISTRY_HOST_CERT} not ${REGISTRY_HOST}" 1>&2
#		Help hint
		echo -e "\n\t${BOLD}Use script create-registry-tls.sh to correct registry TLS.${NORMAL}"
		exit 1
	fi

#	Get registry certificate expiration date domain.crt
	REGISTRY_EXPIRE_DATE=$(openssl x509 -in "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt" -noout -enddate | cut -d '=' -f 2)
	REGISTRY_EXPIRE_SECONDS=$(date -d "${REGISTRY_EXPIRE_DATE}" '+%s')

#	Check if certificate has expired
	if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  REGISTRY_EXPIRE_DATE  >${REGISTRY_EXPIRE_DATE}<  REGISTRY_EXPIRE_SECONDS > CURRENT_DATE_SECONDS ${REGISTRY_EXPIRE_SECONDS} -gt ${CURRENT_DATE_SECONDS}" 1>&2 ; fi
	if [ "${REGISTRY_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS}" ] ; then
		echo -e "\n\tCertificate on ${LOCALHOST}, ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt, is ${BOLD}GOOD${NORMAL} until ${REGISTRY_EXPIRE_DATE}"
	else
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Certificate on ${LOCALHOST}, ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt, ${BOLD}HAS EXPIRED${NORMAL} on ${REGISTRY_EXPIRE_DATE}" 1>&2
#		Help hint
		echo -e "\n\t${BOLD}Use script create-registry-tls.sh to update expired registry TLS.${NORMAL}"
	fi

	echo -e "\n\tVerify and correct file permissions."

#	Verify and correct file permissions for ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt
	if [ $(stat -Lc %a "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt") != 400 ] ; then
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File permissions for ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt are not 400.  Correcting $(stat -Lc %a  ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt) to 0400 file permissions." 1>&2
		chmod 0400 "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt"
	fi

#	Verify and correct file permissions for ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key
	if [ $(stat -Lc %a "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key") != 400 ] ; then
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File permissions for ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key are not 400.  Correcting $(stat -Lc %a  ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key) to 0400 file permissions." 1>&2
		chmod 0400 "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key"
	fi

#       Verify and correct directory permissions for ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/ directory
	if [ $(stat -Lc %a "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/") != 700 ] ; then
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Directory permissions for ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/ are not 700.  Correcting $(stat -Lc %a ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/) to 700 directory permissions." 1>&2
		chmod 700 "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/"
	fi
fi

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
