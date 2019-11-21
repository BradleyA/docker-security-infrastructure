#!/bin/bash
# 	docker-TLS/create-registry-tls.sh  3.498.1030  2019-11-20T22:56:23.692173-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.497  
# 	   testing 
# 	docker-TLS/create-registry-tls.sh  3.460.969  2019-10-13T23:02:54.182134-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.459-2-g8b8bcb3  
# 	   close #68  docker-TLS/create-registry-tls.sh  - upgrade Production standard 
# 	docker-TLS/create-registry-tls.sh  3.234.679  2019-04-10T23:30:18.738262-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  six-rpi3b.cptx86.com 3.233  
# 	   production standard 6.1.177 Architecture tree 
#86# docker-TLS/create-registry-tls.sh - Create TLS for Private Registry V2
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
YELLOW=$(tput setaf 3)
WHITE=$(tput  setaf 7)

### production standard 7.0 Default variable value
DEFAULT_REGISTRY_PORT="17313"
DEFAULT_NUMBER_DAYS='365'
DEFAULT_WORKING_DIRECTORY=~/.docker

###  Production standard 8.3.530 --usage
display_usage() {
COMMAND_NAME=$(echo "${0}" | sed 's/^.*\///')
echo -e "\n${NORMAL}${COMMAND_NAME}\n   Create TLS for Private Registry V2"
echo -e "\n${BOLD}USAGE${NORMAL}"
echo    "   ${YELLOW}Positional Arguments${NORMAL}"
echo    "   ${COMMAND_NAME} [<REGISTRY_PORT>]" 
echo -e "   ${COMMAND_NAME}  <REGISTRY_PORT> [<NUMBER_DAYS>]\n"
echo    "   ${COMMAND_NAME} [--help | -help | help | -h | h | -?]"
echo    "   ${COMMAND_NAME} [--usage | -usage | -u]"
echo    "   ${COMMAND_NAME} [--version | -version | -v]"
}

###  Production standard 0.3.214 --help
display_help() {
display_usage
#    Displaying help DESCRIPTION in English en_US.UTF-8
echo -e "\n${BOLD}DESCRIPTION${NORMAL}"
echo    "Run this script to create Docker private registry certificates on any host in"
echo    "the <WORKING_DIRECTORY> (default ${DEFAULT_WORKING_DIRECTORY}).  It will create"
echo    "a directory, ~/.docker/registry-certs-<REGISTRY_HOST>-<REGISTRY_PORT>."
echo    "The <REGISTRY_PORT> number is not required when creating a private registry"
echo    "certificates.  It is used to keep track of multiple certificates for multiple"
echo    "private registries on the same host."
echo -e "\nThe scripts create-site-private-public-tls.sh and"
echo    "create-new-openssl.cnf-tls.sh are NOT required for a private registry."

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
echo    "   DEBUG             (default off '0')"
echo    "   REGISTRY_PORT     Registry port number (default '${DEFAULT_REGISTRY_PORT}')"
echo    "   NUMBER_DAYS       Number of days certificate valid"
echo    "                     (default '${DEFAULT_NUMBER_DAYS}')" 
echo    "   WORKING_DIRECTORY Absolute path for working directory"
echo    "                     (default ${DEFAULT_WORKING_DIRECTORY})"

echo -e "\n${BOLD}OPTIONS${NORMAL}"
echo -e "Order of precedence: CLI options, environment variable, default code.\n"
echo    "   REGISTRY_PORT    Registry port number (default '${DEFAULT_REGISTRY_PORT}')"
echo    "   NUMBER_DAYS      Number of days certificate valid (default '${DEFAULT_NUMBER_DAYS}')" 

###  Production standard 6.1.177 Architecture tree
echo -e "\n${BOLD}ARCHITECTURE TREE${NORMAL}"  # STORAGE & CERTIFICATION
echo    "<USER_HOME>/                               <-- Location of user home directory"
echo    "└── <USER-1>/.docker/                      <-- User docker cert directory"
echo    "    ├── registry-certs-<REGISTRY_HOST>-<REGISTRY_PORT>/ <-- Working directory"
echo    "    │   │                                      to create registory certs"
echo    "    │   ├── ca.crt                         <-- Daemon registry domain cert"
echo    "    │   ├── domain.crt                     <-- Registry cert"
echo    "    │   └── domain.key                     <-- Registry private key"
echo    "    └── registry-certs-<REGISTRY_HOST>-<REGISTRY_PORT>/ <-- Working directory"
echo -e "                                               to create registory certs\n"

echo -e "\n${BOLD}DOCUMENTATION${NORMAL}"
echo    "   https://github.com/BradleyA/docker-security-infrastructure/blob/master/docker-TLS/README.md"

echo -e "\n${BOLD}EXAMPLES${NORMAL}"
echo -e "   Create new certificates with 17315 port number\n\t${BOLD}${COMMAND_NAME} 17315${NORMAL}"
echo -e "   Create new certificates with 17315 port number valid for 90 days\n\t${BOLD}${COMMAND_NAME} 17315 90${NORMAL}"
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
    *)  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Option, ${BOLD}${YELLOW}${1}${NORMAL}, entered on the command line is not supported." 1>&2 ; display_usage ; exit 1 ; ;;
  esac
done

###		

#    Order of precedence: CLI argument, environment variable, default code
if [[ $# -ge  1 ]]  ; then REGISTRY_PORT=${1} ; elif [[ "${REGISTRY_PORT}" == "" ]] ; then REGISTRY_PORT=${DEFAULT_REGISTRY_PORT} ; fi
if [[ $# -ge  2 ]]  ; then NUMBER_DAYS=${2} ; elif [[ "${NUMBER_DAYS}" == "" ]] ; then NUMBER_DAYS=${DEFAULT_NUMBER_DAYS} ; fi
if [ "${DEBUG}" == "1" ] ; then new_message "${LINENO}" "DEBUG" "  Variable... REGISTRY_PORT >${REGISTRY_PORT}<" 1>&2 ; fi

#    Test <REGISTRY_PORT> for integer
#    if ! [[ "${REGISTRY_PORT}" =~ ^[0-9]+$ ]]
if ! [[ "${REGISTRY_PORT}" =~ ^[0-9]+$ ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  <REGISTRY_PORT> is not an interger.  <REGISTRY_PORT> is set to '${REGISTRY_PORT}'" 1>&2
  display_usage
  exit 1
fi

#    Test <NUMBER_DAYS> for integer
if ! [[ "${NUMBER_DAYS}" =~ ^[0-9]+$ ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  <NUMBER_DAYS> is not an interger.  <NUMBER_DAYS> is set to '${NUMBER_DAYS}'" 1>&2
  display_usage
  exit 1
fi

#    Check if user has home directory on system
if [[ ! -d "${HOME}" ]] ; then
  display_help | more
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  ${USER} does not have a home directory on this system or ${USER} home directory is not ${HOME}" 1>&2
  exit 1
fi

#    Check if .docker directory in $HOME
if [[ ! -d "${HOME}/.docker" ]] ; then
  mkdir -p "${HOME}/.docker"
  chmod 700 "${HOME}/.docker"
fi

#    Create tmp working directory
mkdir "${HOME}/.docker/tmp-${REGISTRY_PORT}"
cd "${HOME}/.docker/tmp-${REGISTRY_PORT}"

#    Create Self-Signed Certificate Keys
echo -e "\n\t${BOLD}Create Self-Signed Certificate Keys in $(pwd) ${NORMAL}\n" 
openssl req -newkey rsa:4096 -nodes -sha256 -keyout domain.key -x509 -days "${NUMBER_DAYS}" -out domain.crt

#    Set REGISTRY_HOST variable to host entered during the creation of certificates
REGISTRY_HOST=$(openssl x509 -in domain.crt -noout -issuer | cut -d '/' -f 7 | cut -d '=' -f 2)
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  Variable... REGISTRY_HOST >${REGISTRY_HOST}<" 1>&2 ; fi

#    Check if site directory on system
if [[ ! -d "${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}" ]] ; then
  mkdir -p "${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}"
  chmod 700 "${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}"
fi

#    Change into registry cert directory
cd "${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}"
echo -e "\n\t${BOLD}Move Self-Signed Certificate Keys into $(pwd) ${NORMAL}\n" 

#    Check if domain.crt already exist
if [[ -e domain.crt ]] ; then
  echo -e "\n\t${BOLD}domain.crt${NORMAL} already exists, renaming existing keys so new keys can be created.\n"
  mv domain.crt "domain.crt-$(date +%Y-%m-%dT%H:%M:%S%:z)"
fi

#    Check if domain.key already exist
if [[ -e domain.key ]] ; then
  echo -e "\n\t${BOLD}domain.key${NORMAL} already exists, renaming existing keys so new keys can be created.\n"
  mv domain.key "domain.key-$(date +%Y-%m-%dT%H:%M:%S%:z)"
fi

#    Check if ca.crt already exist
if [[ -e ca.crt ]] ; then
  echo -e "\n\t${BOLD}ca.crt${NORMAL} already exists, renaming existing keys so new keys can be created.\n"
  mv ca.crt "ca.crt-$(date +%Y-%m-%dT%H:%M:%S%:z)"
fi

#    Copy Self-Signed Certificate Keys
cp -p ../tmp-${REGISTRY_PORT}/domain.{crt,key} .
cp -p domain.crt ca.crt
chmod 0400 ca.crt domain.crt domain.key 
rm -rf ../tmp-${REGISTRY_PORT}

#
new_message "${LINENO}" "${YELLOW}INFO${WHITE}" "  Operation finished..." 1>&2
###
