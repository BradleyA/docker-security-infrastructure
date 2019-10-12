#!/bin/bash
# 	docker-TLS/check-registry-tls.sh  3.451.945  2019-10-12T18:45:13.024119-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.450-1-g7ebe3d6  
# 	   close #61   docker-TLS/check-registry-tls.sh  - upgrade Production standard 
#86# docker-TLS/check-registry-tls.sh - Check certifications for private registry
###  Production standard 3.0 shellcheck
###  Production standard 5.1.160 Copyright
#    Copyright (c) 2019 Bradley Allen
#    MIT License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
###  Production standard 1.3.516 DEBUG variable
#    Order of precedence: environment variable, default code
if [[ "${DEBUG}" == ""  ]] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
if [[ "${DEBUG}" == "2" ]] ; then set -x    ; fi   # Print trace of simple commands before they are executed
if [[ "${DEBUG}" == "3" ]] ; then set -v    ; fi   # Print shell input lines as they are read
if [[ "${DEBUG}" == "4" ]] ; then set -e    ; fi   # Exit immediately if non-zero exit status
#
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
YELLOW=$(tput setaf 3)

###  Production standard 7.0 Default variable value
DEFAULT_REGISTRY_HOST=$(hostname -f)    # local host
DEFAULT_REGISTRY_PORT="5000"
DEFAULT_CLUSTER="us-tx-cluster-1/"
DEFAULT_DATA_DIR="/usr/local/data/"

###  Production standard 8.3.214 --usage
display_usage() {
COMMAND_NAME=$(echo "${0}" | sed 's/^.*\///')
echo -e "\n${NORMAL}${COMMAND_NAME}\n   - Check certifications for private registry"
echo -e "\n${BOLD}USAGE${NORMAL}"
echo    "   ${COMMAND_NAME} [<REGISTRY_HOST>]"
echo    "   ${COMMAND_NAME}  <REGISTRY_HOST> [<REGISTRY_PORT>]"
echo    "   ${COMMAND_NAME}  <REGISTRY_HOST>  <REGISTRY_PORT> [<CLUSTER>]"
echo -e "   ${COMMAND_NAME}  <REGISTRY_HOST>  <REGISTRY_PORT>  <CLUSTER> [<DATA_DIR>]\n"
echo    "   ${COMMAND_NAME} [--help | -help | help | -h | h | -?]"
echo    "   ${COMMAND_NAME} [--usage | -usage | -u]"
echo    "   ${COMMAND_NAME} [--version | -version | -v]"
}

###  Production standard 0.3.214 --help
display_help() {
display_usage
#    Displaying help DESCRIPTION in English en_US.UTF-8
echo -e "\n${BOLD}DESCRIPTION${NORMAL}"
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

###  Production standard 1.3.516 DEBUG variable
echo -e "\nThe DEBUG environment variable can be set to '', '0', '1', '2', '3', or '4'."
echo    "The setting '' or '0' will turn off all DEBUG messages during execution of this"
echo    "script.  The setting '1' will print all DEBUG messages during execution of this"
echo    "script.  The setting '2' (set -x) will print a trace of simple commands before"
echo    "they are executed in this script.  The setting '3' (set -v) will print shell"
echo    "input lines as they are read.  The setting '4' (set -e) will exit immediately"
echo    "if non-zero exit status is recieved with some exceptions.  For more information"
echo    "about any of the set options, see man bash."

###  Production standard 4.0 Documentation Language
#    Displaying help DESCRIPTION in French fr_CA.UTF-8, fr_FR.UTF-8, fr_CH.UTF-8
if [[ "${LANG}" == "fr_CA.UTF-8" ]] || [[ "${LANG}" == "fr_FR.UTF-8" ]] || [[ "${LANG}" == "fr_CH.UTF-8" ]] ; then
  echo -e "\n--> ${LANG}"
  echo    "<votre aide va ici>" # your help goes here
  echo    "Souhaitez-vous traduire la section description?" # Do you want to translate the description section?
elif ! [[ "${LANG}" == "en_US.UTF-8" ]] ; then
  new_message "${SCRIPT_NAME}" "${LINENO}" "INFO" "  Your language, ${LANG}, is not supported.  Would you like to translate the description section?" 1>&2
fi

echo -e "\n${BOLD}ENVIRONMENT VARIABLES${NORMAL}"
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
echo -e "\n${BOLD}OPTIONS${NORMAL}"
echo    "Order of precedence: CLI options, environment variable, default code."
echo    "   REGISTRY_HOST   Registry host (default '${DEFAULT_REGISTRY_HOST}')"
echo    "   REGISTRY_PORT   Registry port number (default '${DEFAULT_REGISTRY_PORT}')"
echo    "   CLUSTER         Cluster name (default '${DEFAULT_CLUSTER}')"
echo    "   DATA_DIR        Data directory (default '${DEFAULT_DATA_DIR}')"

###  Production standard 6.1.177 Architecture tree
echo -e "\n${BOLD}ARCHITECTURE TREE${NORMAL}"  # STORAGE & CERTIFICATION
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

echo -e "\n${BOLD}DOCUMENTATION${NORMAL}"
echo    "   https://github.com/BradleyA/docker-security-infrastructure/blob/master/docker-TLS/README.md"

echo -e "\n${BOLD}EXAMPLES${NORMAL}"
echo -e "   Check local host certificates for <REGISTRY_HOST> (two.cptx86.com) using\n   <REGISTRY_PORT> (17313)\n\t${BOLD}sudo ${0} two.cptx86.com 17313${NORMAL}"
echo -e "   Use cluster-command.sh script to loop through hosts in a cluster."
echo    "   Check each host certificates for <REGISTRY_HOST> (two.cptx86.com) using"
echo -e "   <REGISTRY_PORT> (17313)\n\t${BOLD}cluster-command.sh special 'sudo ${0} two.cptx86.com 17313${NORMAL}'"
}

#    Date and time function ISO 8601
get_date_stamp() {
  DATE_STAMP=$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)
  TEMP=$(date +%Z)
  DATE_STAMP="${DATE_STAMP} (${TEMP})"
}

#    Fully qualified domain name FQDN hostname
LOCALHOST=$(hostname -f)

#    Version
#    Assumptions for the next two lines of code:  The second line in this script includes the script path & name as the second item and
#    the script version as the third item separated with space(s).  The tool I use is called 'markit'. See example line below:
#       template/template.sh  3.517.783  2019-09-13T18:20:42.144356-05:00 (CDT)  https://github.com/BradleyA/user-files.git  uadmin  one-rpi3b.cptx86.com 3.516  
SCRIPT_NAME=$(head -2 "${0}" | awk '{printf $2}')
SCRIPT_VERSION=$(head -2 "${0}" | awk '{printf $3}')
if [[ "${SCRIPT_NAME}" == "" ]] ; then SCRIPT_NAME="${0}" ; fi
if [[ "${SCRIPT_VERSION}" == "" ]] ; then SCRIPT_VERSION="v?.?" ; fi

#    UID and GID
USER_ID=$(id -u)
GROUP_ID=$(id -g)

###  Production standard 2.3.512 log format (WHEN WHERE WHAT Version Line WHO UID:GID [TYPE] Message)
new_message() {  #  $1="${SCRIPT_NAME}"  $2="${LINENO}"  $3="DEBUG INFO ERROR WARN"  $4="message"
  get_date_stamp
  echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${1}[$$] ${SCRIPT_VERSION} ${2} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[${3}]${NORMAL}  ${4}"
}

#    INFO
new_message "${SCRIPT_NAME}" "${LINENO}" "INFO" "  Started..." 1>&2

#    Added following code because USER is not defined in crobtab jobs
if ! [[ "${USER}" == "${LOGNAME}" ]] ; then  USER=${LOGNAME} ; fi
if [[ "${DEBUG}" == "1" ]] ; then new_message "${SCRIPT_NAME}" "${LINENO}" "DEBUG" "  Setting USER to support crobtab...  USER >${USER}<  LOGNAME >${LOGNAME}<" 1>&2 ; fi

#    DEBUG
if [[ "${DEBUG}" == "1" ]] ; then new_message "${SCRIPT_NAME}" "${LINENO}" "DEBUG" "  Name_of_command >${SCRIPT_NAME}< Name_of_arg1 >${1}< Name_of_arg2 >${2}< Name_of_arg3 >${3}<  Version of bash ${BASH_VERSION}" 1>&2 ; fi

###  Production standard 9.3.513 Parse CLI options and arguments
while [[ "${#}" -gt 0 ]] ; do
  case "${1}" in
    --help|-help|help|-h|h|-\?)  display_help | more ; exit 0 ;;
    --usage|-usage|usage|-u)  display_usage ; exit 0  ;;
    --version|-version|version|-v)  echo "${SCRIPT_NAME} ${SCRIPT_VERSION}" ; exit 0  ;;
    *)  new_message "${SCRIPT_NAME}" "${LINENO}" "ERROR" "  Option, ${BOLD}${YELLOW}${1}${NORMAL}, entered on the command line is not supported." 1>&2 ; display_usage ; exit 1 ; ;;
  esac
done
if [[ "${DEBUG}" == "1" ]] ; then new_message "${SCRIPT_NAME}" "${LINENO}" "DEBUG" "  Variable... ADMUSER >${ADMUSER}< CLUSTER >${CLUSTER}< DATA_DIR >${DATA_DIR}< FILE_NAME >${FILE_NAME}< SSH_USER >${SSH_USER}< USER_HOME >${USER_HOME}<" 1>&2 ; fi

#    Root is required to copy certs
if ! [[ "$(id -u)" = 0 ]] ; then
  display_help | more
  new_message "${SCRIPT_NAME}" "${LINENO}" "ERROR" "  Use sudo ${0}" 1>&2
#    Help hint
  echo -e "\n\t${BOLD}>>   SCRIPT MUST BE RUN AS ROOT   <<\n${NORMAL}"  1>&2
  exit 1
fi

###

###  Production standard 7.0 Default variable value
#    Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  1 ]  ; then REGISTRY_HOST=${1} ; elif [ "${REGISTRY_HOST}" == "" ] ; then REGISTRY_HOST=${DEFAULT_REGISTRY_HOST} ; fi
if [ $# -ge  2 ]  ; then REGISTRY_PORT=${2} ; elif [ "${REGISTRY_PORT}" == "" ] ; then REGISTRY_PORT=${DEFAULT_REGISTRY_PORT} ; fi
if [ $# -ge  3 ]  ; then CLUSTER=${3} ; elif [ "${CLUSTER}" == "" ] ; then CLUSTER=${DEFAULT_CLUSTER} ; fi
if [ $# -ge  4 ]  ; then DATA_DIR=${4} ; elif [ "${DATA_DIR}" == "" ] ; then DATA_DIR=${DEFAULT_DATA_DIR} ; fi
if [ "${DEBUG}" == "1" ] ; then new_message "${SCRIPT_NAME}" "${LINENO}" "DEBUG" "  Variable... REGISTRY_HOST >${REGISTRY_HOST}< REGISTRY_PORT >${REGISTRY_PORT}< CLUSTER >${CLUSTER}< DATA_DIR >${DATA_DIR}<" 1>&2 ; fi

#    Get currect date in seconds
CURRENT_DATE_SECONDS=$(date '+%s')

#    Get currect date in seconds add 30 days
CURRENT_DATE_SECONDS_PLUS_30_DAYS=$(date '+%s' -d '+30 days')
if [ "${DEBUG}" == "1" ] ; then new_message "${SCRIPT_NAME}" "${LINENO}" "DEBUG" "  Variable... CURRENT_DATE_SECONDS >${CURRENT_DATE_SECONDS}< CURRENT_DATE_SECONDS_PLUS_30_DAYS >${CURRENT_DATE_SECONDS_PLUS_30_DAYS=}<" 1>&2 ; fi

#    Set REGISTRY_HOST_CERT variable to host entered during the creation of certificates
REGISTRY_HOST_CERT=$(openssl x509 -in "/etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt" -noout -issuer | cut -d '/' -f 7 | cut -d '=' -f 2)
if [ "${DEBUG}" == "1" ] ; then new_message "${SCRIPT_NAME}" "${LINENO}" "DEBUG" "  Variable... REGISTRY_HOST >${REGISTRY_HOST}< REGISTRY_HOST_CERT >${REGISTRY_HOST_CERT}<" 1>&2 ; fi

#    Get registry certificate expiration date from ca.crt
REGISTRY_EXPIRE_DATE=$(openssl x509 -in "/etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt" -noout -enddate | cut -d '=' -f 2)
REGISTRY_EXPIRE_SECONDS=$(date -d "${REGISTRY_EXPIRE_DATE}" '+%s')
if [ "${DEBUG}" == "1" ] ; then new_message "${SCRIPT_NAME}" "${LINENO}" "DEBUG" "  Variable... REGISTRY_EXPIRE_DATE >${REGISTRY_EXPIRE_DATE}< REGISTRY_EXPIRE_SECONDS >${REGISTRY_EXPIRE_SECONDS}<" 1>&2 ; fi

#    Check if ${REGISTRY_HOST_CERT} is NOT ${REGISTRY_HOST}
if ! [ "${REGISTRY_HOST_CERT}" == "${REGISTRY_HOST}" ] ; then
  new_message "${SCRIPT_NAME}" "${LINENO}" "WARN" "  Certificate (/etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt) is for ${REGISTRY_HOST_CERT}  NOT  ${REGISTRY_HOST} " 1>&2
#    Help hint
  echo -e "\n\t${BOLD}Use script create-registry-tls.sh to correct registry TLS.${NORMAL}"
fi

#    Check if certificate has expired
if [ "${REGISTRY_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS}" ] ; then

#    Check if certificate will expire in the next 30 day
  if [ "${REGISTRY_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS_PLUS_30_DAYS}" ] ; then
    echo -e "\n\tCertificate on ${LOCALHOST}, /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt, is ${BOLD}GOOD${NORMAL} until ${REGISTRY_EXPIRE_DATE}"
  else
    new_message "${SCRIPT_NAME}" "${LINENO}" "WARN" "  Certificate on ${LOCALHOST}, /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt, ${BOLD}EXPIRES${NORMAL} on ${REGISTRY_EXPIRE_DATE}" 1>&2
#    Help hint
    echo -e "\n\t${BOLD}Use script create-registry-tls.sh to update expired registry TLS.${NORMAL}"
  fi
else
  new_message "${SCRIPT_NAME}" "${LINENO}" "ERROR" "  Certificate on ${LOCALHOST}, /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt, ${BOLD}HAS EXPIRED${NORMAL} on ${REGISTRY_EXPIRE_DATE}" 1>&2
#    Help hint
  echo -e "\n\t${BOLD}Use script create-registry-tls.sh to update expired registry TLS.${NORMAL}"
fi

echo -e "\n\tVerify and correct file permissions."

#    Verify and correct file permissions for /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt
if [ "$(stat -Lc %a "/etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt")" != 400 ] ; then
  new_message "${SCRIPT_NAME}" "${LINENO}" "ERROR" "  File permissions for /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt are not 400.  Correcting $(stat -Lc %a /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt) to 0400 file permissions." 1>&2
  chmod 0400 "/etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt"
fi

#    Verify and correct directory permissions for /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ directory
if [ "$(stat -Lc %a "/etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/")" != 700 ] ; then
  new_message "${SCRIPT_NAME}" "${LINENO}" "ERROR" "  Directory permissions for /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ are not 700.  Correcting $(stat -Lc %a /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/) to 700 directory permissions." 1>&2
  chmod 700 "/etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/"
fi

###  ${REGISTRY_HOST}
#    Check if ${LOCALHOST} is ${REGISTRY_HOST} running the private registry
if [ "${LOCALHOST}" == "${REGISTRY_HOST}" ] ; then

#    Check if private registry certificate directory
  if [ ! -d "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/" ] ; then
    new_message "${SCRIPT_NAME}" "${LINENO}" "ERROR" "  Directory ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/ NOT found${NORMAL}" 1>&2
    exit 1
  fi

#    Check if domain.crt registry certificate exists and has size greater than zero
  if [ ! -s "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt" ] ; then
    new_message "${SCRIPT_NAME}" "${LINENO}" "ERROR" "  File ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt does NOT exist or has file size equal to zero.${NORMAL}" 1>&2
#    Help hint
    echo -e "\n\t${BOLD}Use script create-registry-tls.sh to correct registry TLS.${NORMAL}"
    exit 1
  fi

#    Set REGISTRY_HOST_CERT variable to host entered during the creation of certificates
  REGISTRY_HOST_CERT=$(openssl x509 -in "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt" -noout -issuer | cut -d '/' -f 7 | cut -d '=' -f 2)
  if [ "${DEBUG}" == "1" ] ; then new_message "${SCRIPT_NAME}" "${LINENO}" "DEBUG" "  Variable... REGISTRY_HOST >${REGISTRY_HOST}< REGISTRY_HOST_CERT >${REGISTRY_HOST_CERT}<" 1>&2 ; fi
  if [ ! "${REGISTRY_HOST_CERT}" == "${REGISTRY_HOST}" ] ; then
    new_message "${SCRIPT_NAME}" "${LINENO}" "ERROR" "  The certificate, ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt, is for host ${REGISTRY_HOST_CERT} not ${REGISTRY_HOST}" 1>&2
#    Help hint
    echo -e "\n\t${BOLD}Use script create-registry-tls.sh to correct registry TLS.${NORMAL}"
    exit 1
  fi

#    Get registry certificate expiration date domain.crt
  REGISTRY_EXPIRE_DATE=$(openssl x509 -in "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt" -noout -enddate | cut -d '=' -f 2)
  REGISTRY_EXPIRE_SECONDS=$(date -d "${REGISTRY_EXPIRE_DATE}" '+%s')

#    Check if certificate has expired
  if [ "${DEBUG}" == "1" ] ; then new_message "${SCRIPT_NAME}" "${LINENO}" "DEBUG" "  REGISTRY_EXPIRE_DATE  >${REGISTRY_EXPIRE_DATE}<  REGISTRY_EXPIRE_SECONDS > CURRENT_DATE_SECONDS ${REGISTRY_EXPIRE_SECONDS} -gt ${CURRENT_DATE_SECONDS}" 1>&2 ; fi
  if [ "${REGISTRY_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS}" ] ; then
    echo -e "\n\tCertificate on ${LOCALHOST}, ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt, is ${BOLD}GOOD${NORMAL} until ${REGISTRY_EXPIRE_DATE}"
  else
    new_message "${SCRIPT_NAME}" "${LINENO}" "ERROR" "  Certificate on ${LOCALHOST}, ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt, ${BOLD}HAS EXPIRED${NORMAL} on ${REGISTRY_EXPIRE_DATE}" 1>&2
#    Help hint
    echo -e "\n\t${BOLD}Use script create-registry-tls.sh to update expired registry TLS.${NORMAL}"
  fi

  echo -e "\n\tVerify and correct file permissions."

#    Verify and correct file permissions for ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt
  if [ "$(stat -Lc %a "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt")" != 400 ] ; then
    new_message "${SCRIPT_NAME}" "${LINENO}" "ERROR" "  File permissions for ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt are not 400.  Correcting $(stat -Lc %a  ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt) to 0400 file permissions." 1>&2
    chmod 0400 "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt"
  fi

#    Verify and correct file permissions for ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key
  if [ "$(stat -Lc %a "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key")" != 400 ] ; then
    new_message "${SCRIPT_NAME}" "${LINENO}" "ERROR" "  File permissions for ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key are not 400.  Correcting $(stat -Lc %a  ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key) to 0400 file permissions." 1>&2
    chmod 0400 "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key"
  fi

#    Verify and correct directory permissions for ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/ directory
  if [ "$(stat -Lc %a "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/")" != 700 ] ; then
    new_message "${SCRIPT_NAME}" "${LINENO}" "ERROR" "  Directory permissions for ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/ are not 700.  Correcting $(stat -Lc %a ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/) to 700 directory permissions." 1>&2
    chmod 700 "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/"
  fi
fi

#
new_message "${SCRIPT_NAME}" "${LINENO}" "INFO" "  Operation finished..." 1>&2
###
