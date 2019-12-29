#!/bin/bash
# 	docker-TLS/check-host-tls.sh  3.551.1119  2019-12-15T16:04:40.046301-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.550  
# 	   check-host-tls.sh   Production standard 5.3.550 Copyright  Production standard 0.3.550 --help  Production standard 4.3.550 Documentation Language  Production standard 1.3.550 DEBUG variable 
# 	docker-TLS/check-host-tls.sh  3.543.1106  2019-12-13T16:20:51.857535-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.542  
# 	   Production standard 6.3.547  Architecture tree  Production standard 8.3.541 --usage 
# 	docker-TLS/check-host-tls.sh  3.454.953  2019-10-13T16:00:06.942880-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.454-1-g4d6f510  
# 	   docker-TLS/check-host-tls.sh - upgrade Production standard #60 
# 	docker-TLS/check-host-tls.sh  3.283.750  2019-06-10T23:51:10.800496-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.282  
# 	   docker-TLS/check-ca-tls.sh - complete design - in development #56 
#86# docker-TLS/check-host-tls.sh - Check public, private keys, and CA for host
###  Production standard 3.0 shellcheck
###  Production standard 5.3.550 Copyright                                                  # 3.550
#    Copyright (c) 2020 Bradley Allen                                                       # 3.550
#    MIT License is online  https://github.com/BradleyA/user-files/blob/master/LICENSE      # 3.550
###  Production standard 1.3.550 DEBUG variable                                             # 3.550
#    Order of precedence: environment variable, default code
if [[ "${DEBUG}" == ""  ]] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
if [[ "${DEBUG}" == "2" ]] ; then set -x    ; fi   # Print trace of simple commands before they are executed
if [[ "${DEBUG}" == "3" ]] ; then set -v    ; fi   # Print shell input lines as they are read
if [[ "${DEBUG}" == "4" ]] ; then set -e    ; fi   # Exit immediately if non-zero exit status
if [[ "${DEBUG}" == "5" ]] ; then set -e -o pipefail ; fi   # Exit immediately if non-zero exit status and exit if any command in a pipeline errors
#
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
RED=$(tput    setaf 1)
GREEN=$(tput  setaf 2)
YELLOW=$(tput setaf 3)
WHITE=$(tput  setaf 7)

###  Production standard 7.0 Default variable value
DEFAULT_CERT_DAEMON_DIR="/etc/docker/certs.d/daemon/"

###  Production standard 8.3.541 --usage
COMMAND_NAME=$(echo "${0}" | sed 's/^.*\///')   # 3.541
display_usage() {
echo -e "\n${NORMAL}${COMMAND_NAME}\n   Check public, private keys, and CA for host"
echo -e "\n${BOLD}USAGE${NORMAL}"
echo -e "   sudo ${COMMAND_NAME} [<CERT_DAEMON_DIR>]\n"
echo    "   ${COMMAND_NAME} [--help | -help | help | -h | h | -?]"
echo    "   ${COMMAND_NAME} [--usage | -usage | -u]"
echo    "   ${COMMAND_NAME} [--version | -version | -v]"
}

###  Production standard 0.3.550 --help                                                     # 3.550
display_help() {
display_usage
#    Displaying help DESCRIPTION in English en_US.UTF-8, en.UTF-8, C.UTF-8                  # 3.550
echo -e "\n${BOLD}DESCRIPTION${NORMAL}"
echo    "This script has to be run as root to check public, private keys, and CA in"
echo    "/etc/docker/certs.d/daemon directory(<CERT_DAEMON_DIR>).  This directory was"
echo    "selected to place dockerd TLS certifications because docker registry"
echo    "stores it's TLS certifications in /etc/docker/certs.d.  The certification"
echo    "files and directory permissions are also checked."

###  Production standard 4.3.550 Documentation Language                                     # 3.550
#    Displaying help DESCRIPTION in French fr_CA.UTF-8, fr_FR.UTF-8, fr_CH.UTF-8
if [[ "${LANG}" == "fr_CA.UTF-8" ]] || [[ "${LANG}" == "fr_FR.UTF-8" ]] || [[ "${LANG}" == "fr_CH.UTF-8" ]] ; then
  echo -e "\n--> ${LANG}"
  echo    "<votre aide va ici>" # your help goes here
  echo    "Souhaitez-vous traduire la section description?" # Do you want to translate the description section?
elif ! [[ "${LANG}" == "en_US.UTF-8" ||  "${LANG}" == "en.UTF-8" || "${LANG}" == "C.UTF-8" ]] ; then  # 3.550
  new_message "${LINENO}" "${YELLOW}INFO${WHITE}" "  Your language, ${LANG}, is not supported.  Would you like to translate the description section?" 1>&2
fi

echo -e "\n${BOLD}ENVIRONMENT VARIABLES${NORMAL}"
echo    "If using the bash shell, enter; 'export DEBUG=1' on the command line to set"
echo    "the environment variable DEBUG to '1' (0 = debug off, 1 = debug on).  Use the"
echo    "command, 'unset DEBUG' to remove the exported information from the environment"
echo    "variable DEBUG.  You are on your own defining environment variables if"
echo    "you are using other shells."

###  Production standard 1.3.550 DEBUG variable                                             # 3.550
echo    "   DEBUG           (default off '0')  The DEBUG environment variable can be set"   # 3.550
echo    "                   to 0, 1, 2, 3, 4 or 5.  The setting '' or 0 will turn off"      # 3.550
echo    "                   all DEBUG messages during execution of this script.  The"       # 3.550
echo    "                   setting 1 will print all DEBUG messages during execution."      # 3.550
echo    "                   Setting 2 (set -x) will print a trace of simple commands"       # 3.550
echo    "                   before they are executed.  Setting 3 (set -v) will print"       # 3.550
echo    "                   shell input lines as they are read.  Setting 4 (set -e) will"   # 3.550
echo    "                   exit immediately if non-zero exit status is recieved with"      # 3.550
echo    "                   some exceptions.  Setting 5 (set -e -o pipefail) will do"       # 3.550
echo    "                   setting 4 and exit if any command in a pipeline errors.  For"   # 3.550
echo    "                   more information about the set options, see man bash."          # 3.550

echo -e "\n${BOLD}OPTIONS${NORMAL}"
echo    "   CERT_DAEMON_DIR     dockerd certification directory (default ${DEFAULT_CERT_DAEMON_DIR})"

###  Production standard 6.3.547  Architecture tree
echo -e "\n${BOLD}ARCHITECTURE TREE${NORMAL}"  # STORAGE & CERTIFICATION
echo    "/etc/ "
echo    "└── docker/ "
echo    "    └── certs.d/                           <-- Host docker cert directory"
echo    "        └── daemon/                        <-- Daemon cert directory"
echo    "            ├── ca.pem                     <-- CA Cert"                            # 3.542
echo    "            ├── <HOST>-cert.pem            <-- public key (default: cert.pem)"     # 3.547
echo    "            └── <HOST>-priv-key.pem        <-- private key (default: key.pem)"     # 3.547

echo -e "\n${BOLD}DOCUMENTATION${NORMAL}"
echo    "   https://github.com/BradleyA/docker-security-infrastructure/blob/master/docker-TLS/README.md"

echo -e "\n${BOLD}EXAMPLES${NORMAL}"
echo    "   Administration user checks local host TLS public, private keys,"
echo    "   CA, and file and directory permissions."
echo -e "\t${BOLD}sudo ${COMMAND_NAME}${NORMAL}\n"
echo    "   This script works for the local host only.  To use check-host-tls.sh on a"
echo    "   remote hosts (one-rpi3b.cptx86.com) with ssh port of 12323 as uadmin user;"
echo -e "\t${BOLD}ssh -tp 12323 uadmin@one-rpi3b.cptx86.com 'sudo check-host-tls.sh'${NORMAL}\n"
echo    "   To loop through a list of hosts in a cluster use,"
echo    "   https://github.com/BradleyA/Linux-admin/tree/master/cluster-command"
echo -e "\t${BOLD}cluster-command.sh special 'sudo check-host-tls.sh'${NORMAL}"

echo -e "\n${BOLD}SEE ALSO${NORMAL}"                                                        # 3.550
echo    "   cluster-command.sh (https://github.com/BradleyA/Linux-admin/tree/master/cluster-command)"  # 3.550

echo -e "\n${BOLD}AUTHOR${NORMAL}"                                                          # 3.550
echo    "   ${COMMAND_NAME} was written by Bradley Allen <allen.bradley@ymail.com>"         # 3.550

echo -e "\n${BOLD}REPORTING BUGS${NORMAL}"                                                  # 3.550
echo    "   Report ${COMMAND_NAME} bugs https://github.com/BradleyA/docker-security-infrastructure/issues/new"  # 3.550

###  Production standard 5.3.550 Copyright                                                  # 3.550
echo -e "\n${BOLD}COPYRIGHT${NORMAL}"                                                       # 3.550
echo    "   Copyright (c) 2020 Bradley Allen"                                               # 3.550
echo    "   MIT License https://github.com/BradleyA/docker-security-infrastructure/blob/master/LICENSE"  # 3.550

#	echo -e "\n${BOLD}HISTORY${NORMAL}"                                                         # 3.550
#	echo    "   As of . . .  "                                                                  # 3.550
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
SCRIPT_NAME=$(head -2 "${0}" | awk '{printf $2}')    #  Different from ${COMMAND_NAME}=$(echo "${0}" | sed 's/^.*\///'), SCRIPT_NAME = Git repository directory / COMMAND_NAME (for dev, test teams)
SCRIPT_VERSION=$(head -2 "${0}" | awk '{printf $3}')
if [[ "${SCRIPT_NAME}" == "" ]] ; then SCRIPT_NAME="${0}" ; fi
if [[ "${SCRIPT_VERSION}" == "" ]] ; then SCRIPT_VERSION="v?.?" ; fi

#    GID
GROUP_ID=$(id -g)

###  Production standard 2.3.529 log format (WHEN WHERE WHAT Version Line WHO UID:GID [TYPE] Message)
new_message() {  #  $1="${LINENO}"  $2="DEBUG INFO ERROR WARN"  $3="message"
  get_date_stamp
  echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${SCRIPT_NAME}[$$] ${SCRIPT_VERSION} ${1} ${USER} ${UID}:${GROUP_ID} ${BOLD}[${2}]${NORMAL}  ${3}"
}

#    INFO
new_message "${LINENO}" "${YELLOW}INFO${WHITE}" "  Started..." 1>&2

#    Added following code because USER is not defined in crobtab jobs
if ! [[ "${USER}" == "${LOGNAME}" ]] ; then  USER=${LOGNAME} ; fi
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  Setting USER to support crobtab...  USER >${USER}<  LOGNAME >${LOGNAME}<" 1>&2 ; fi

#    DEBUG
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  Name_of_command >${SCRIPT_NAME}< Name_of_arg1 >${1}< Name_of_arg2 >${2}< Name_of_arg3 >${3}<  Version of bash ${BASH_VERSION}" 1>&2 ; fi

###  Production standard 9.3.513 Parse CLI options and arguments
while [[ "${#}" -gt 0 ]] ; do
  case "${1}" in
    --help|-help|help|-h|h|-\?)  display_help | more ; exit 0 ;;
    --usage|-usage|usage|-u)  display_usage ; exit 0  ;;
    --version|-version|version|-v)  echo "${SCRIPT_NAME} ${SCRIPT_VERSION}" ; exit 0  ;;
    *) break ;;
  esac
done

### 

CERT_DAEMON_DIR=${1:-${DEFAULT_CERT_DAEMON_DIR}}
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  CERT_DAEMON_DIR >${CERT_DAEMON_DIR}<<" 1>&2 ; fi

#    Root is required to copy certs
if ! [[ "${UID}"  = 0 ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Use sudo ${SCRIPT_NAME}" 1>&2
#    Help hint
  echo -e "\n\t${BOLD}>>   ${YELLOW}SCRIPT MUST BE RUN AS ROOT${WHITE}   <<\n${NORMAL}"  1>&2
  exit 1
fi

#    Check for ${CERT_DAEMON_DIR} directory
if [[ ! -d "${CERT_DAEMON_DIR}" ]] ; then
  display_help | more
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  ${CERT_DAEMON_DIR} does not exist" 1>&2
  exit 1
fi

#    Get currect date in seconds
CURRENT_DATE_SECONDS=$(date '+%s')

#    Get currect date in seconds add 30 days
CURRENT_DATE_SECONDS_PLUS_30_DAYS=$(date '+%s' -d '+30 days')
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  Variable... CURRENT_DATE_SECONDS >${CURRENT_DATE_SECONDS}< CURRENT_DATE_SECONDS_PLUS_30_DAYS >${CURRENT_DATE_SECONDS_PLUS_30_DAYS=}<" 1>&2 ; fi

#    View dockerd daemon certificate expiration date of ca.pem file
HOST_EXPIRE_DATE=$(openssl x509 -in "${CERT_DAEMON_DIR}/ca.pem" -noout -enddate  | cut -d '=' -f 2)
HOST_EXPIRE_SECONDS=$(date -d "${HOST_EXPIRE_DATE}" '+%s')
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  Variable... HOST_EXPIRE_DATE >${HOST_EXPIRE_DATE}< HOST_EXPIRE_SECONDS >${HOST_EXPIRE_SECONDS}<" 1>&2 ; fi

#    Check if certificate has expired
if [[ "${HOST_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS}" ]] ; then
#    Check if certificate will expire in the next 30 day
  if [[ "${HOST_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS_PLUS_30_DAYS}" ]] ; then
    echo -e "\n\tCertificate on ${LOCALHOST}, ${CERT_DAEMON_DIR}/${YELLOW}ca.pem${NORMAL}: ${BOLD}${GREEN}PASS${NORMAL}  until ${BOLD}${YELLOW}${HOST_EXPIRE_DATE}${NORMAL}"
  else
    new_message "${LINENO}" "${YELLOW}WARN${WHITE}" "  Certificate on ${LOCALHOST}, ${CERT_DAEMON_DIR}/${YELLOW}ca.pem${NORMAL}:  ${BOLD}${YELLOW}EXPIRES${NORMAL}  on ${BOLD}${YELLOW}${HOST_EXPIRE_DATE}${NORMAL}" 1>&2
  fi
else
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Certificate on ${LOCALHOST},  ${CERT_DAEMON_DIR}/${YELLOW}ca.pem${NORMAL}:  ${BOLD}${RED}HAS EXPIRED${NORMAL}  on ${BOLD}${YELLOW}${HOST_EXPIRE_DATE}${NORMAL}" 1>&2
fi

#    View dockerd daemon certificate expiration date of cert.pem file
HOST_EXPIRE_DATE=$(openssl x509 -in "${CERT_DAEMON_DIR}/cert.pem" -noout -enddate  | cut -d '=' -f 2)
HOST_EXPIRE_SECONDS=$(date -d "${HOST_EXPIRE_DATE}" '+%s')
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  Variable... HOST_EXPIRE_DATE >${HOST_EXPIRE_DATE}< HOST_EXPIRE_SECONDS >${HOST_EXPIRE_SECONDS}<" 1>&2 ; fi

#    Check if certificate has expired
if [[ "${HOST_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS}" ]] ; then

#    Check if certificate will expire in the next 30 day
  if [[ "${HOST_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS_PLUS_30_DAYS}" ]] ; then
    echo -e "\n\tCertificate on ${LOCALHOST}, ${CERT_DAEMON_DIR}/${YELLOW}cert.pem${NORMAL}: ${BOLD}${GREEN}PASS${NORMAL}  until ${BOLD}${YELLOW}${HOST_EXPIRE_DATE}${NORMAL}"
  else
    new_message "${LINENO}" "${YELLOW}WARN${WHITE}" "  Certificate on ${LOCALHOST}, ${CERT_DAEMON_DIR}/${YELLOW}cert.pem${NORMAL}:  ${BOLD}${YELLOW}EXPIRES${NORMAL}  on ${BOLD}${YELLOW}${HOST_EXPIRE_DATE}${NORMAL}" 1>&2
  fi
else
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Certificate on ${LOCALHOST},  ${CERT_DAEMON_DIR}/${YELLOW}cert.pem${NORMAL}:  ${BOLD}${RED}HAS EXPIRED${NORMAL}  on ${BOLD}${YELLOW}${HOST_EXPIRE_DATE}${NORMAL}" 1>&2
fi

#    View dockerd daemon certificate issuer data of the ca.pem file
TEMP=$(openssl x509 -in "${CERT_DAEMON_DIR}/ca.pem" -noout -issuer)
echo -e "\n\tView dockerd daemon certificate issuer data of the ca.pem file:\n\t${BOLD}${TEMP}${NORMAL}"

#    View dockerd daemon certificate issuer data of the cert.pem file
TEMP=$(openssl x509 -in "${CERT_DAEMON_DIR}/cert.pem" -noout -issuer)
echo -e "\n\tView dockerd daemon certificate issuer data of the cert.pem file:\n\t${BOLD}${TEMP}${NORMAL}"

#    Verify that dockerd daemon certificate was issued by the CA.
TEMP=$(openssl verify -verbose -CAfile "${CERT_DAEMON_DIR}/ca.pem" "${CERT_DAEMON_DIR}cert.pem")
echo -e "\n\tVerify that dockerd daemon certificate was issued by the CA:\n\t${BOLD}${YELLOW}${TEMP}${NORMAL}"

echo -e "\n\tVerify and correct file permissions."

#    Verify and correct file permissions for ${CERT_DAEMON_DIR}/ca.pem
if [[ "$(stat -Lc %a "${CERT_DAEMON_DIR}/ca.pem")" != 444 ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  File permissions for ${CERT_DAEMON_DIR}ca.pem are not 444.  Correcting $(stat -Lc %a ${CERT_DAEMON_DIR}/ca.pem) to 0444 file permissions." 1>&2
  chmod 0444 "${CERT_DAEMON_DIR}ca.pem"
fi

#    Verify and correct file permissions for ${CERT_DAEMON_DIR}cert.pem
if [[ "$(stat -Lc %a "${CERT_DAEMON_DIR}/cert.pem")" != 444 ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  File permissions for ${CERT_DAEMON_DIR}cert.pem are not 444.  Correcting $(stat -Lc %a ${CERT_DAEMON_DIR}/cert.pem) to 0444 file permissions." 1>&2
  chmod 0444 "${CERT_DAEMON_DIR}/cert.pem"
fi

#    Verify and correct file permissions for ${CERT_DAEMON_DIR}/key.pem
if [[ "$(stat -Lc %a "${CERT_DAEMON_DIR}/key.pem")" != 400 ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  File permissions for ${CERT_DAEMON_DIR}key.pem are not 400.  Correcting $(stat -Lc %a ${CERT_DAEMON_DIR}/key.pem) to 0400 file permissions." 1>&2
  chmod 0400 "${CERT_DAEMON_DIR}/key.pem"
fi

#    Verify and correct directory permissions for ${CERT_DAEMON_DIR} directory
if [[ "$(stat -Lc %a "${CERT_DAEMON_DIR}")" != 700 ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Directory permissions for ${CERT_DAEMON_DIR} are not 700.  Correcting $(stat -Lc %a ${CERT_DAEMON_DIR}) to 700 directory permissions." 1>&2
  chmod 700 "${CERT_DAEMON_DIR}"
fi

#    Help hint
echo -e "\n\t${BOLD}Use script  ${YELLOW}create-host-tls.sh${WHITE}  to update host TLS on your\n\tsite TLS server.\n${NORMAL}"
 
#    May want to create a version of this script that automates this process for SRE tools,
#    but keep this script for users to run manually,
#    open ticket and remove this comment

#
new_message "${LINENO}" "${YELLOW}INFO${NORMAL}" "  Operation finished..." 1>&2
###
