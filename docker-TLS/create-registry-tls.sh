#!/bin/bash
# 	docker-TLS/create-registry-tls.sh  4.1.1211  2019-12-30T11:34:27.957184-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.565-13-g1455a67  
# 	   docker-TLS/*   New Release 4.1 
# 	docker-TLS/create-registry-tls.sh  3.564.1195  2019-12-29T21:00:22.229642-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.563-53-ge1a1e28 
# 	   docker-TLS/create-registry-tls.sh   correct incident chmod: cannot access 'domain.???- 
# 	docker-TLS/create-registry-tls.sh  3.559.1135  2019-12-22T18:44:18.902233-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.558-1-g8474618  
# 	   docker-TLS/create-registry-tls.sh   Production standard 5.3.550 Copyright  Production standard 0.3.550 --help  Production standard 4.3.550 Documentation Language  Production standard 1.3.550 DEBUG variable 
# 	docker-TLS/create-registry-tls.sh  3.543.1106  2019-12-13T16:20:52.770703-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.542  
# 	   Production standard 6.3.547  Architecture tree  Production standard 8.3.541 --usage 
# 	docker-TLS/create-registry-tls.sh  3.506.1040  2019-11-22T22:27:34.292738-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.505  
# 	   docker-TLS/create-registry-tls.sh   updated display_help, added cert duration dates & cert symbolic links 
#86# docker-TLS/create-registry-tls.sh - Create TLS for Private Registry V2
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
YELLOW=$(tput setaf 3)
CYAN=$(tput   setaf 6)
WHITE=$(tput  setaf 7)

### production standard 7.0 Default variable value
DEFAULT_REGISTRY_PORT="17313"
DEFAULT_NUMBER_DAYS='180'
DEFAULT_WORKING_DIRECTORY=~/.docker

###  Production standard 8.3.541 --usage
COMMAND_NAME=$(echo "${0}" | sed 's/^.*\///')   # 3.541
display_usage() {
echo -e "\n${NORMAL}${COMMAND_NAME}\n   Create TLS for Private Registry V2"
echo -e "\n${BOLD}USAGE${NORMAL}"
echo    "   ${YELLOW}Positional Arguments${NORMAL}"
echo    "   ${COMMAND_NAME} [<REGISTRY_PORT>]" 
echo    "   ${COMMAND_NAME}  <REGISTRY_PORT> [<NUMBER_DAYS>]"
echo -e "   ${COMMAND_NAME}  <REGISTRY_PORT>  <NUMBER_DAYS> [<WORKING_DIRECTORY>]\n"
echo    "   ${COMMAND_NAME} [--help | -help | help | -h | h | -?]"
echo    "   ${COMMAND_NAME} [--usage | -usage | -u]"
echo    "   ${COMMAND_NAME} [--version | -version | -v]"
}

###  Production standard 0.3.550 --help                                                     # 3.550
display_help() {
display_usage
#    Displaying help DESCRIPTION in English en_US.UTF-8, en.UTF-8, C.UTF-8                  # 3.550
echo -e "\n${BOLD}DESCRIPTION${NORMAL}"
echo    "Run this script to create Docker private registry certificates on any host in"
echo    "the <WORKING_DIRECTORY> (default ${DEFAULT_WORKING_DIRECTORY}).  It will create"
echo    "a directory, ${DEFAULT_WORKING_DIRECTORY}/registry-certs-<REGISTRY_HOST>-<REGISTRY_PORT>."
echo    "You will be prompted to enter the registory hostname during the creation of"
echo    "the certificates.  The <REGISTRY_PORT> number is not required when creating a"
echo    "private registry certificates.  It is used to keep track of multiple"
echo    "certificates for multiple private registries on the same host."
echo -e "\nThe scripts create-site-private-public-tls.sh and"
echo    "create-new-openssl.cnf-tls.sh are NOT required for private registry"
echo    "certificates."

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

echo    "   REGISTRY_PORT     Registry port number (default '${DEFAULT_REGISTRY_PORT}')"
echo    "   NUMBER_DAYS       Number of days certificate valid"
echo    "                     (default '${DEFAULT_NUMBER_DAYS}')" 
echo    "   WORKING_DIRECTORY Absolute path for working directory"
echo    "                     (default ${DEFAULT_WORKING_DIRECTORY})"

echo -e "\n${BOLD}OPTIONS${NORMAL}"
echo -e "Order of precedence: CLI options, environment variable, default code.\n"
echo    "   REGISTRY_PORT     Registry port number (default '${DEFAULT_REGISTRY_PORT}')"
echo    "   NUMBER_DAYS       Number of days certificate valid"
echo    "                     (default '${DEFAULT_NUMBER_DAYS}')" 
echo    "   WORKING_DIRECTORY Absolute path for working directory"
echo    "                     (default ${DEFAULT_WORKING_DIRECTORY})"

###  Production standard 6.3.547  Architecture tree
echo -e "\n${BOLD}ARCHITECTURE TREE${NORMAL}"  # STORAGE & CERTIFICATION
echo    "<USER_HOME>/                               <-- Location of user home directory"
echo    "└── <USER-1>/.docker/                      <-- User docker cert directory"
echo    "    ├── registry-certs-<REGISTRY_HOST>-<REGISTRY_PORT>/ <-- Working directory"
echo    "    │   │                                      to create registory certs"
echo    "    │   ├── ca.crt                         <-- Daemon registry domain cert"
echo    "    │   ├── domain.crt                     <-- Registry cert"
echo    "    │   └── domain.key                     <-- Registry private key"
echo    "    └── registry-certs-<REGISTRY_HOST>-<REGISTRY_PORT>/ <-- Working directory"
echo    "                                               to create registory certs"

echo -e "\n${BOLD}DOCUMENTATION${NORMAL}"
echo    "   https://github.com/BradleyA/docker-security-infrastructure/blob/master/docker-TLS/README.md"

echo -e "\n${BOLD}EXAMPLES${NORMAL}"
echo -e "   Create new certificates with 17315 port number\n\t${BOLD}${COMMAND_NAME} 17315${NORMAL}\n" # 3.550
echo -e "   Create new certificates with 17315 port number valid for 90 days\n\t${BOLD}${COMMAND_NAME} 17315 90${NORMAL}\n" # 3.550

echo -e "\n${BOLD}AUTHOR${NORMAL}"                                                          # 3.550
echo    "   ${COMMAND_NAME} was written by Bradley Allen <allen.bradley@ymail.com>"         # 3.550

echo -e "\n${BOLD}REPORTING BUGS${NORMAL}"                                                  # 3.550
echo    "   Report ${COMMAND_NAME} bugs https://github.com/BradleyA/docker-security-infrastructure/issues/new"  # 3.550

###  Production standard 5.3.550 Copyright                                                  # 3.550
echo -e "\n${BOLD}COPYRIGHT${NORMAL}"                                                       # 3.550
echo    "   Copyright (c) 2020 Bradley Allen"                                               # 3.550
echo    "   MIT License https://github.com/BradleyA/user-files/blob/master/LICENSE"         # 3.550

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

#    Order of precedence: CLI argument, environment variable, default code
if [[ $# -ge  1 ]]  ; then REGISTRY_PORT=${1} ; elif [[ "${REGISTRY_PORT}" == "" ]] ; then REGISTRY_PORT=${DEFAULT_REGISTRY_PORT} ; fi
if [[ $# -ge  2 ]]  ; then NUMBER_DAYS=${2} ; elif [[ "${NUMBER_DAYS}" == "" ]] ; then NUMBER_DAYS=${DEFAULT_NUMBER_DAYS} ; fi
#    Order of precedence: CLI argument, environment variable, default code
if [[ $# -ge  3 ]]  ; then WORKING_DIRECTORY=${3} ; elif [[ "${WORKING_DIRECTORY}" == "" ]] ; then WORKING_DIRECTORY="${DEFAULT_WORKING_DIRECTORY}" ; fi
if [ "${DEBUG}" == "1" ] ; then new_message "${LINENO}" "DEBUG" "  Variable... REGISTRY_PORT >${REGISTRY_PORT}< NUMBER_DAYS >${NUMBER_DAYS}< WORKING_DIRECTORY >${WORKING_DIRECTORY}<" 1>&2 ; fi

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

mkdir -p "${WORKING_DIRECTORY}"
chmod 700 "${WORKING_DIRECTORY}"

#    Create tmp working directory
mkdir "${WORKING_DIRECTORY}/tmp-${REGISTRY_PORT}"
cd    "${WORKING_DIRECTORY}/tmp-${REGISTRY_PORT}"

#    Create Self-Signed Certificate Keys
#	NOTE: User is prompted for the registory hostname during the creation of the keys
echo -e "\n\t${BOLD}Create Self-Signed Certificate Keys${NORMAL}\n" 
openssl req -newkey rsa:4096 -nodes -sha256 -keyout domain.key -x509 -days "${NUMBER_DAYS}" -out domain.crt
CA_CERT_EXPIRE_DATE_TEMP=$(openssl x509 -in "domain.crt" -noout -enddate  | cut -d '=' -f 2)
CA_CERT_EXPIRE_DATE=$(date -d"${CA_CERT_EXPIRE_DATE_TEMP}" +%Y-%m-%dT%H:%M:%S-%Z)

#    Set REGISTRY_HOST variable to host entered during the creation of certificates
REGISTRY_HOST=$(openssl x509 -in "domain.crt" -noout -issuer | cut -d '/' -f 7 | cut -d '=' -f 2)
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  Variable... REGISTRY_HOST >${REGISTRY_HOST}<" 1>&2 ; fi

#    Check if site directory on system
if [[ ! -d  "${WORKING_DIRECTORY}/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}" ]] ; then
  mkdir -p  "${WORKING_DIRECTORY}/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}"
  chmod 700 "${WORKING_DIRECTORY}/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}"
fi

#    Change into registry cert directory
cd   "${WORKING_DIRECTORY}/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}"
echo -e "\n\t${BOLD}Move ${YELLOW}${NUMBER_DAYS}${WHITE} day Self-Signed Certificate Keys into ${YELLOW} $(pwd) ${NORMAL}\n" 
rm -f domain.crt
rm -f domain.key
rm -f ca.crt

#    Copy Self-Signed Certificate Keys
CERT_CREATE_DATE=$(date +%Y-%m-%dT%H:%M:%S-%Z)
cp -p  "../tmp-${REGISTRY_PORT}/domain.crt"  "domain.crt---${CERT_CREATE_DATE}--${CA_CERT_EXPIRE_DATE}"
cp -p  "../tmp-${REGISTRY_PORT}/domain.key"  "domain.key---${CERT_CREATE_DATE}--${CA_CERT_EXPIRE_DATE}"
chmod 0400  "domain.crt---${CERT_CREATE_DATE}--${CA_CERT_EXPIRE_DATE}"
chmod 0400  "domain.key---${CERT_CREATE_DATE}--${CA_CERT_EXPIRE_DATE}"
ln -s  "domain.crt---${CERT_CREATE_DATE}--${CA_CERT_EXPIRE_DATE}"  ca.crt
ln -s  "domain.crt---${CERT_CREATE_DATE}--${CA_CERT_EXPIRE_DATE}"  domain.crt
ln -s  "domain.key---${CERT_CREATE_DATE}--${CA_CERT_EXPIRE_DATE}"  domain.key
rm -rf "../tmp-${REGISTRY_PORT}"
echo   "${BOLD}${CYAN}"
ls -1 | grep "${CERT_CREATE_DATE}"
echo -e "\n${NORMAL}"

#
new_message "${LINENO}" "${YELLOW}INFO${WHITE}" "  Operation finished..." 1>&2
###
