#!/bin/bash
# 	docker-TLS/check-user-tls.sh  3.517.1062  2019-12-03T01:39:06.844039-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.516  
# 	   Production standard 6.3.544  Architecture tree 
# 	docker-TLS/check-user-tls.sh  3.464.977  2019-10-16T22:28:28.323070-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.463  
# 	   docker-TLS/check-user-tls.sh    - upgrade Production standard #62 
# 	docker-TLS/check-user-tls.sh  3.455.955  2019-10-13T20:32:00.191462-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.454-3-g6f32d2b  
# 	   docker-TLS/check-user-tls.sh   #62  Production standard 2.3.529 log format, 8.3.530 --usage, 1.3.531 DEBUG variable 
# 	docker-TLS/check-user-tls.sh  3.448.938  2019-10-12T14:56:00.146490-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.447  
# 	   close #62   docker-TLS/check-user-tls.sh    - upgrade Production standard 
# 	docker-TLS/check-user-tls.sh  3.439.917  2019-09-07T13:52:54.148689-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.438  
# 	   docker-TLS/check-user-tls.sh  corrected incident with $(dirname "${HOME}") because it does not include an ending / 
# 	docker-TLS/check-user-tls.sh  3.436.914  2019-09-04T15:13:18.865841-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.435  
# 	   docker-TLS/check-user-tls.sh  upgrade to Production standard 1.3.496 DEBUG variable ; shellcheck version section corrected ; change DEFAULT_USER_HOME 
#86# docker-TLS/check-user-tls.sh - Check public, private keys, and CA for a user
###  Production standard 3.0 shellcheck
###  Production standard 5.1.160 Copyright
#    Copyright (c) 2019 Bradley Allen
#    MIT License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
###  Production standard 1.3.531 DEBUG variable
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
DEFAULT_TLS_USER="${USER}"
DEFAULT_USER_HOME=$(dirname "${HOME}")

###  Production standard 8.3.530 --usage
display_usage() {
COMMAND_NAME=$(echo "${0}" | sed 's/^.*\///')
echo -e "\n${NORMAL}${COMMAND_NAME}\n  Check public, private keys, and CA for a user"
echo -e "\n${BOLD}USAGE${NORMAL}"
echo    "   ${YELLOW}Positional Arguments${NORMAL}"
echo    "   ${COMMAND_NAME} [<TLS_USER>]"
echo -e "   ${COMMAND_NAME}  <TLS_USER> [<USER_HOME>]\n" # >>> use case for the need for USER_HOME ver using $(eval echo '~sam') (issues with ~ unquoted literal in order for tilde expansion to work) or echo ~sam (no quotes) or echo '~sam' or getent passwd sam | cut -d: -f6 or ; but the origin idea was to be able to use '*' for all uses on a system (NFS server might serve home directories for users)  need to open ticket to solve this ...  another challenge is if sam's home directory location is different on each system . . . also look at dirname ${HOME} >>>
echo    "   ${COMMAND_NAME} [--help | -help | help | -h | h | -?]"
echo    "   ${COMMAND_NAME} [--usage | -usage | -u]"
echo    "   ${COMMAND_NAME} [--version | -version | -v]"
}

###  Production standard 0.3.214 --help
display_help() {
display_usage
#    Displaying help DESCRIPTION in English en_US.UTF-8
echo -e "\n${BOLD}DESCRIPTION${NORMAL}"
echo    "Users can check their public, private keys, and CA in /home/ or other"
echo    "non-default home directories.  The file and directory permissions are also"
echo    "checked."
echo -e "\t${BOLD}${COMMAND_NAME}${NORMAL}"
echo -e "\nTo loop through a list of hosts in a cluster a user could use,"
echo    "https://github.com/BradleyA/Linux-admin/tree/master/cluster-command"
echo -e "\t${BOLD}cluster-command.sh special '${COMMAND_NAME}'${NORMAL}"
echo -e "\nAdministrators can check other users certificates by using"
echo -e "\t${BOLD}sudo ${COMMAND_NAME} <user-name>${NORMAL}"
echo -e "\nTo loop through a list of hosts in a cluster an administrators could use,"
echo -e "\t${BOLD}cluster-command.sh special 'sudo ${COMMAND_NAME} <user-name>'${NORMAL}"

###  Production standard 1.3.531 DEBUG variable
echo -e "\nThe DEBUG environment variable can be set to '', '0', '1', '2', '3', '4' or"
echo    "'5'.  The setting '' or '0' will turn off all DEBUG messages during execution of"
echo    "this script.  The setting '1' will print all DEBUG messages during execution of"
echo    "this script.  The setting '2' (set -x) will print a trace of simple commands"
echo    "before they are executed in this script.  The setting '3' (set -v) will print"
echo    "shell input lines as they are read.  The setting '4' (set -e) will exit"
echo    "immediately if non-zero exit status is recieved with some exceptions.  The"
echo    "setting '5' (set -e -o pipefail) will do setting '4' and exit if any command in"
echo    "a pipeline errors.  For more information about any of the set options, see"
echo    "man bash."

###  Production standard 4.3.534 Documentation Language
#    Displaying help DESCRIPTION in French fr_CA.UTF-8, fr_FR.UTF-8, fr_CH.UTF-8
if [[ "${LANG}" == "fr_CA.UTF-8" ]] || [[ "${LANG}" == "fr_FR.UTF-8" ]] || [[ "${LANG}" == "fr_CH.UTF-8" ]] ; then
  echo -e "\n--> ${LANG}"
  echo    "<votre aide va ici>" # your help goes here
  echo    "Souhaitez-vous traduire la section description?" # Do you want to translate the description section?
elif ! [[ "${LANG}" == "en_US.UTF-8" ]] ; then
  new_message "${LINENO}" "${YELLOW}INFO${WHITE}" "  Your language, ${LANG}, is not supported.  Would you like to translate the description section?" 1>&2
fi

echo -e "\n${BOLD}ENVIRONMENT VARIABLES${NORMAL}"
echo    "If using the bash shell, enter; 'export DEBUG=1' on the command line to set"
echo    "the environment variable DEBUG to '1' (0 = debug off, 1 = debug on).  Use the"
echo    "command, 'unset DEBUG' to remove the exported information from the environment"
echo    "variable DEBUG.  You are on your own defining environment variables if"
echo    "you are using other shells."
echo    "   DEBUG       (default off '0')"
echo    "   USER_HOME   Location of user home directory (default ${DEFAULT_USER_HOME})"

echo -e "\n${BOLD}OPTIONS${NORMAL}"
echo    "   TLS_USER    Administration user (default ${DEFAULT_TLS_USER})"
echo    "   USER_HOME   Location of user home directory (default ${DEFAULT_USER_HOME})"
echo    "               sites have different home directory locations (/u/north-office/)"

###  Production standard 6.3.544  Architecture tree
echo -e "\n${BOLD}ARCHITECTURE TREE${NORMAL}"  # STORAGE & CERTIFICATION
echo    "<USER_HOME>/                               <-- Location of user home directory"
echo    "└── <USER-1>/.docker/                      <-- User docker cert directory"
echo    "    ├── ca.pem                             <-- User tlscacert or symbolic link"
echo    "    ├── cert.pem                           <-- Symbolic link to user tlscert"
echo -e "    └── key.pem                            <-- Symbolic link to user tlskey\n"
echo    "/usr/local/data/                           <-- <DATA_DIR>"
echo    " ── <CLUSTER>/                             <-- <CLUSTER>"
echo    "    └── docker-accounts/                   <-- Docker TLS certs"
echo    "        ├── <HOST-1>/                      <-- Host in cluster"
echo    "        │   ├── <USER-1>/                  <-- User TLS certs directory"
echo    "        │   │   └── docker         FUTURE  <-- User tlscacert"
echo    "        │   │      ├── ca.pem      FUTURE  <-- User tlscacert"
echo    "        │   │      ├── cert.pem    FUTURE  <-- User tlscert"
echo    "        │   │      └── key.pem     FUTURE  <-- User tlskey"
echo    "        │   └── <USER-2>/                  <-- User TLS certs directory"
echo    "        └── <HOST-2>/                      <-- Host in cluster"

echo -e "\n${BOLD}DOCUMENTATION${NORMAL}"
echo    "   https://github.com/BradleyA/docker-security-infrastructure/blob/master/docker-TLS/README.md"

echo -e "\n${BOLD}EXAMPLES${NORMAL}"
echo -e "   User checking their certificates\n\t${BOLD}${COMMAND_NAME}${NORMAL}"
echo -e "   User sam checking their certificates in a non-default home directory\n\t${BOLD}${COMMAND_NAME} sam /u/north-office/${NORMAL}"
echo -e "   Administrator checks user bob certificates\n\t${BOLD}sudo ${COMMAND_NAME} bob${NORMAL}"
echo -e "   Administrator checks user sam certificates in a different home directory\n\t${BOLD}sudo ${COMMAND_NAME} sam /u/north-office/${NORMAL}"
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
SCRIPT_NAME=$(head -2 "${0}" | awk '{printf $2}')  #  Different from ${COMMAND_NAME}=$(echo "${0}" | sed 's/^.*\///'), SCRIPT_NAME = Git repository directory / COMMAND_NAME (for dev, test teams)
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

TLS_USER=${1:-${DEFAULT_TLS_USER}}
#    Order of precedence: CLI argument, environment variable, default code
if [[ $# -ge  2 ]]  ; then USER_HOME=${2} ; elif [[ "${USER_HOME}" == "" ]] ; then USER_HOME="${DEFAULT_USER_HOME}/" ; fi
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  TLS_USER >${TLS_USER}< USER_HOME >${USER_HOME}<" 1>&2 ; fi

#    Root is required to check other user certs
if [[ "${USER}" != "${TLS_USER}" ]] && [[ "${UID}" != 0 ]] ; then
  display_help | more
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Use ${YELLOW}${BOLD}sudo ${0} ${TLS_USER}${NORMAL}" 1>&2
#    Help hint
  echo -e "\n\t${BOLD}>>   SCRIPT MUST BE RUN AS ROOT TO CHECK A DIFFERENT USER  <<\n${NORMAL}"  1>&2
  exit 1
fi

#    Check if user has home directory on system
if [[ ! -d "${USER_HOME}${TLS_USER}" ]] ; then 
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  ${TLS_USER} does not have a home directory on this system, ${LOCALHOST}, or ${TLS_USER} home directory is not ${USER_HOME}${TLS_USER}." 1>&2
  exit 1
fi

#    Check if user has .docker directory
if [[ ! -d "${USER_HOME}${TLS_USER}/.docker" ]] ; then 
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  ${TLS_USER} does not have a .docker directory on this system, ${LOCALHOST}." 1>&2
  exit 1
fi

#    Check if user has .docker ca.pem file
if [[ ! -e "${USER_HOME}${TLS_USER}/.docker/ca.pem" ]] ; then 
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  ${TLS_USER} does not have a .docker/ca.pem file." 1>&2
#    Help hint
  echo -e "\n\tRunning create-user-tls.sh will create public and private keys."
  exit 1
fi

#    Check if user has .docker cert.pem file
if [[ ! -e "${USER_HOME}${TLS_USER}/.docker/cert.pem" ]] ; then 
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  ${TLS_USER} does not have a .docker/cert.pem file." 1>&2
#    Help hint
  echo -e "\n\tRunning create-user-tls.sh will create public and private keys."
  exit 1
fi

#    Check if user has .docker key.pem file
if [[ ! -e "${USER_HOME}${TLS_USER}/.docker/key.pem" ]] ; then 
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  ${TLS_USER} does not have a .docker/key.pem file." 1>&2
#    Help hint
  echo -e "\n\tRunning create-user-tls.sh will create public and private keys."
  exit 1
fi

#    Get currect date in seconds
CURRENT_DATE_SECONDS=$(date '+%s')

#    Get currect date in seconds add 30 days
CURRENT_DATE_SECONDS_PLUS_30_DAYS=$(date '+%s' -d '+30 days')
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  Variable... CURRENT_DATE_SECONDS >${CURRENT_DATE_SECONDS}< CURRENT_DATE_SECONDS_PLUS_30_DAYS >${CURRENT_DATE_SECONDS_PLUS_30_DAYS=}<" 1>&2 ; fi

#    View user certificate expiration date of ca.pem file
USER_EXPIRE_DATE=$(openssl x509 -in "${USER_HOME}${TLS_USER}/.docker/ca.pem" -noout -enddate | cut -d '=' -f 2)
USER_EXPIRE_SECONDS=$(date -d "${USER_EXPIRE_DATE}" '+%s')
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  Variable... USER_EXPIRE_DATE >${USER_EXPIRE_DATE}< USER_EXPIRE_SECONDS >${USER_EXPIRE_SECONDS}<" 1>&2 ; fi

#    Check if certificate has expired
if [[ "${USER_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS}" ]] ; then

#    Check if certificate will expire in the next 30 day
  if [[ "${USER_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS_PLUS_30_DAYS}" ]] ; then
    echo -e "\n\tCertificate on ${LOCALHOST}, ${USER_HOME}${TLS_USER}/.docker/${YELLOW}ca.pem${WHITE}: ${BOLD}${GREEN}PASS${NORMAL}  until ${BOLD}${YELLOW}${USER_EXPIRE_DATE}${NORMAL}"
  else
    new_message "${LINENO}" "${YELLOW}WARN${WHITE}" "  Certificate on ${LOCALHOST}, ${USER_HOME}${TLS_USER}/.docker/${YELLOW}ca.pem${WHITE},  ${BOLD}${YELLOW}EXPIRES${NORMAL}  on ${BOLD}${RED}${USER_EXPIRE_DATE}${NORMAL}" 1>&2
  fi
else
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Certificate on ${LOCALHOST},  ${USER_HOME}${TLS_USER}/.docker/${YELLOW}ca.pem${WHITE},  ${BOLD}${RED}HAS EXPIRED${NORMAL}  on ${BOLD}${YELLOW}${USER_EXPIRE_DATE}${NORMAL}" 1>&2
fi

#    View user certificate expiration date of cert.pem file
USER_EXPIRE_DATE=$(openssl x509 -in "${USER_HOME}${TLS_USER}/.docker/cert.pem" -noout -enddate  | cut -d '=' -f 2)
USER_EXPIRE_SECONDS=$(date -d "${USER_EXPIRE_DATE}" '+%s')
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  Variable... USER_EXPIRE_DATE >${USER_EXPIRE_DATE}< USER_EXPIRE_SECONDS >${USER_EXPIRE_SECONDS}<" 1>&2 ; fi

#    Check if certificate has expired
if [[ "${USER_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS}" ]] ; then

#    Check if certificate will expire in the next 30 day
  if [[ "${USER_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS_PLUS_30_DAYS}" ]] ; then
    echo -e "\n\tCertificate on ${LOCALHOST}, ${USER_HOME}${TLS_USER}/.docker/${YELLOW}cert.pem${WHITE}: ${BOLD}${GREEN}PASS${NORMAL}  until ${BOLD}${YELLOW}${USER_EXPIRE_DATE}${NORMAL}"
  else
    echo    " "  #  skip line
    new_message "${LINENO}" "${YELLOW}WARN${WHITE}" "  Certificate on ${LOCALHOST}, ${USER_HOME}${TLS_USER}/.docker/${YELLOW}cert.pem${WHITE},  ${BOLD}${RED}EXPIRES${NORMAL}  on ${BOLD}${YELLOW}${USER_EXPIRE_DATE}${NORMAL}" 1>&2
  fi
else
    new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Certificate on ${LOCALHOST}, ${USER_HOME}${TLS_USER}/.docker/${YELLOW}cert.pem${WHITE},  ${BOLD}${RED}HAS EXPIRED${NORMAL}  on ${BOLD}${YELLOW}${USER_EXPIRE_DATE}${NORMAL}" 1>&2
fi

#    View user certificate issuer data of the ca.pem file.
TEMP=$(openssl x509 -in "${USER_HOME}${TLS_USER}/.docker/ca.pem" -noout -issuer)
echo -e "\n\tView ${USER_HOME}${TLS_USER}/.docker certificate ${BOLD}issuer data of the ca.pem ${NORMAL}file:\n\t${BOLD}${TEMP}${NORMAL}"

#    View user certificate issuer data of the cert.pem file.
TEMP=$(openssl x509 -in "${USER_HOME}${TLS_USER}/.docker/cert.pem" -noout -issuer)
echo -e "\n\tView ${USER_HOME}${TLS_USER}/.docker certificate ${BOLD}issuer data of the cert.pem ${NORMAL}file:\n\t${BOLD}${TEMP}${NORMAL}"

#    Verify that user public key in your certificate matches the public portion of your private key.
echo -e "\n\tVerify that user public key in your certificate matches the public portion\n\tof your private key."
(cd "${USER_HOME}${TLS_USER}"/.docker ; openssl x509 -noout -modulus -in cert.pem | openssl md5 ; openssl rsa -noout -modulus -in key.pem | openssl md5 ) | uniq | wc -l > /tmp/foo
MATCH_KEY=$(cat /tmp/foo)
if [[ "${MATCH_KEY}" == 1 ]] ; then
  echo -e "\t[${BOLD}${GREEN}PASS${NORMAL}]  -> Public key does matches the public portion of private key.\n"
else
  echo -e "\t[${BOLD}${RED}ERROR${NORMAL}]  -> Public key does NOT matches the public portion of private key.\n"
fi

#    Verify that user certificate was issued by the CA.
echo -e "\t${NORMAL}Verify that user certificate was issued by the CA:${BOLD}${YELLOW}"
openssl verify -verbose -CAfile "${USER_HOME}${TLS_USER}/.docker/ca.pem" "${USER_HOME}${TLS_USER}/.docker/cert.pem"  || { new_message "${LINENO}" "${RED}ERROR${WHITE}" "  User certificate for ${TLS_USER} on ${LOCALHOST} was NOT issued by CA." ; exit 1; }
echo -n "${WHITE}"

#    Verify and correct file permissions for ${USER_HOME}${TLS_USER}/.docker/ca.pem
echo -e "\n\t${NORMAL}Verify and correct file permissions for ${USER_HOME}${TLS_USER}/.docker"
if [[ $(stat -Lc %a "${USER_HOME}${TLS_USER}/.docker/ca.pem") != 444 ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  File permissions for ${USER_HOME}${TLS_USER}/.docker/ca.pem are not 444.  Correcting $(stat -Lc %a ${USER_HOME}${TLS_USER}/.docker/ca.pem) to 0444 file permissions" 1>&2
  chmod 0444 "${USER_HOME}${TLS_USER}/.docker/ca.pem"
fi

#    Verify and correct file permissions for ${USER_HOME}${TLS_USER}/.docker/cert.pem
if [[ $(stat -Lc %a "${USER_HOME}${TLS_USER}/.docker/cert.pem") != 444 ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  File permissions for ${USER_HOME}${TLS_USER}/.docker/cert.pem are not 444.  Correcting $(stat -Lc %a ${USER_HOME}${TLS_USER}/.docker/cert.pem) to 0444 file permissions" 1>&2
  chmod 0444 "${USER_HOME}${TLS_USER}/.docker/cert.pem"
fi

#    Verify and correct file permissions for ${USER_HOME}${TLS_USER}/.docker/key.pem
if [[ $(stat -Lc %a "${USER_HOME}${TLS_USER}/.docker/key.pem") != 400 ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  File permissions for ${USER_HOME}${TLS_USER}/.docker/key.pem are not 400.  Correcting $(stat -Lc %a ${USER_HOME}${TLS_USER}/.docker/key.pem) to 0400 file permissions" 1>&2
  chmod 0400 "${USER_HOME}${TLS_USER}/.docker/key.pem"
fi

#    Verify and correct directory permissions for ${USER_HOME}${TLS_USER}/.docker directory
if [[ $(stat -Lc %a "${USER_HOME}${TLS_USER}/.docker") != 700 ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Directory permissions for ${USER_HOME}${TLS_USER}/.docker\n\tare not 700.  Correcting $(stat -Lc %a ${USER_HOME}${TLS_USER}/.docker) to 700 directory permissions" 1>&2
  chmod 700 "${USER_HOME}${TLS_USER}/.docker"
fi

#    Help hint
echo -e "\n\tUse script ${BOLD}${YELLOW}create-user-tls.sh${NORMAL} to update user TLS if user TLS certificate\n\thas expired."
 
# >>>	May want to create a version of this script that automates this process for SRE tools,
# >>>		but keep this script for users to run manually,
# >>>	open ticket and remove this comment

#
new_message "${LINENO}" "${YELLOW}INFO${WHITE}" "  Operation finished..." 1>&2
###
