#!/bin/bash
# 	docker-TLS/create-new-openssl.cnf-tls.sh  3.85.442  2018-12-04T23:33:42.816516-06:00 (CST)  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.84  
# 	   added DEBUG environment variable, include process ID in ERROR, INFO, WARN, DEBUG statements, display_help | more , shellcheck #30 
#
### create-new-openssl.cnf-tls.sh - Modify /etc/ssl/openssl.conf file
#       Order of precedence: environment variable, default code
if [ "${DEBUG}" == "" ] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
DEBUG=0                 # 0 = debug off, 1 = debug on
#	set -x
#	set -v
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
###
display_help() {
echo -e "\n${NORMAL}${0} - Modify /etc/ssl/openssl.conf file"
echo -e "\nUSAGE\n   sudo ${0}"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION\nThis script makes a change to openssl.cnf file which is required for"
echo    "create-user-tls.sh and create-host-tls.sh scripts.  It must be run as root."
echo -e "\nEnvironment Variables"
echo    "If using the bash shell, enter; 'export DEBUG=1' on the command line to set"
echo    "the DEBUG environment variable to '1' (0 = debug off, 1 = debug on).  Use the"
echo    "command, 'unset DEBUG' to remove the exported information from the DEBUG"
echo    "environment variable.  You are on your own defining environment variables if"
echo    "you are using other shells."
echo    "   DEBUG       (default '0')"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS"
echo -e "\nEXAMPLES\n   sudo ${0}\n"
#       After displaying help in english check for other languages
if ! [ "${LANG}" == "en_US.UTF-8" ] ; then
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  ${LANG}, is not supported, Would you like to help translate?" 1>&2
#       elif [ "${LANG}" == "fr_CA.UTF-8" ] ; then
#               get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Display help in ${LANG}" 1>&2
#       else
#               get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Your language, ${LANG}, is not supported.  Would you like to translate?" 1>&2
fi
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
BACKUPFILE=/etc/ssl/openssl.cnf-$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)
ORIGINALFILE=/etc/ssl/openssl.cnf
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  BACKUPFILE >${BACKUPFILE} ORIGINALFILE >${ORIGINALFILE}<" 1>&2 ; fi

#       Must be root to run this script
if ! [ $(id -u) = 0 ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Use sudo ${0}" 1>&2
	#	Help hint
	echo -e "\n>>	SCRIPT MUST BE RUN AS ROOT TO MODIFY THE ${ORIGINALFILE}	<<\n"	1>&2
        exit 1
fi

#	Check if ${ORIGINALFILE} file has previously been modified
if ! grep -Fxq 'extendedKeyUsage = clientAuth,serverAuth' ${ORIGINALFILE} ; then
	#	Help hint
	echo    "This script will make changes to ${ORIGINALFILE} file."
	echo    "These changes are required before creating user and host TLS keys for Docker."
	echo    "Run this script before running the user and host TLS scripts.  It is not"
	echo    "required to be run on hosts not creating TLS keys."
	echo -e "\nCreating backup file of ${ORIGINALFILE} and naming it ${BACKUPFILE}"
	cp ${ORIGINALFILE} ${BACKUPFILE}
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Adding the extended KeyUsage at the beginning of [ v3_ca ] section." 1>&2
	sed '/\[ v3_ca \]/a extendedKeyUsage = clientAuth,serverAuth' ${BACKUPFILE} > ${ORIGINALFILE}
else
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${ORIGINALFILE} file has previously been modified." 1>&2
fi

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
