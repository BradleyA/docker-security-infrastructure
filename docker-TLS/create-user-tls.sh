#!/bin/bash
# 	docker-TLS/create-user-tls.sh  3.462.974  2019-10-15T14:41:43.959971-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.461-2-g62bc2de  
# 	   close #70   docker-TLS/create-user-tls.sh   - upgrade Production standard 
#86# docker-TLS/create-user-tls.sh - Create user public and private key and CA
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
YELLOW=$(tput setaf 3)

###  Production standard 7.0 Default variable value
DEFAULT_TLS_USER="${USER}"
DEFAULT_NUMBER_DAYS="90"
DEFAULT_USER_HOME=$(dirname "${HOME}")
DEFAULT_ADM_TLS_USER="${USER}"

###  Production standard 8.3.530 --usage
display_usage() {
COMMAND_NAME=$(echo "${0}" | sed 's/^.*\///')
echo -e "\n${NORMAL}${COMMAND_NAME}\n   Create user public and private key and CA"
echo -e "\n${BOLD}USAGE${NORMAL}"
echo    "   ${YELLOW}Positional Arguments${NORMAL}"
echo    "   ${0} [<TLS_USER>]"
echo    "   ${0}  <TLS_USER> [<NUMBER_DAYS>]"
echo    "   ${0}  <TLS_USER>  <NUMBER_DAYS> [<USER_HOME>]"
echo -e "   ${0}  <TLS_USER>  <NUMBER_DAYS>  <USER_HOME> [<ADM_TLS_USER>]\n"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--usage | -usage | -u]"
echo    "   ${0} [--version | -version | -v]"
}

###  Production standard 0.3.214 --help
display_help() {
display_usage
#    Displaying help DESCRIPTION in English en_US.UTF-8
echo -e "\n${BOLD}DESCRIPTION${NORMAL}"
echo    "An administration user runs this script to create user public, private keys and"
echo    "CA in the working directory (<USER_HOME>/<ADM_TLS_USER>/.docker/docker-ca).  If"
echo    "the directory is not found the script will create the working directory."
echo -e "\nThe scripts create-site-private-public-tls.sh and"
echo    "create-new-openssl.cnf-tls.sh are required to be run once on a system before"
echo    "using this script.  Review the documentation for a complete understanding."

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

###  Production standard 4.0 Documentation Language
#    Displaying help DESCRIPTION in French fr_CA.UTF-8, fr_FR.UTF-8, fr_CH.UTF-8
if [[ "${LANG}" == "fr_CA.UTF-8" ]] || [[ "${LANG}" == "fr_FR.UTF-8" ]] || [[ "${LANG}" == "fr_CH.UTF-8" ]] ; then
  echo -e "\n--> ${LANG}"
  echo    "<votre aide va ici>" # your help goes here
  echo    "Souhaitez-vous traduire la section description?" # Do you want to translate the description section?
elif ! [[ "${LANG}" == "en_US.UTF-8" ]] ; then
  new_message "${LINENO}" "INFO" "  Your language, ${LANG}, is not supported.  Would you like to translate the description section?" 1>&2
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
echo -e "Order of precedence: CLI options, environment variable, default code.\n"
echo    "   TLS_USER    User requiring new TLS keys (default ${DEFAULT_TLS_USER})"
echo    "   TLS_USER    Administration user (default ${DEFAULT_TLS_USER})"
echo    "   NUMBER_DAYS Number of days host CA is valid (default ${DEFAULT_NUMBER_DAYS})"
echo    "   USER_HOME   Location of user home directory (default ${DEFAULT_USER_HOME})"
echo    "               sites have different home directories (/u/north-office/)"
echo    "   ADM_TLS_USER Administrator user creating TLS keys (default ${DEFAULT_ADM_TLS_USER})"

###  Production standard 6.1.177 Architecture tree
echo -e "\n${BOLD}ARCHITECTURE TREE${NORMAL}"  # STORAGE & CERTIFICATION
echo    "<USER_HOME>/                               <-- Location of user home directory"
echo    "└── <USER-1>/.docker/                      <-- User docker cert directory"
echo    "    ├── ca.pem                             <-- User tlscacert or symbolic link"
echo    "    ├── cert.pem                           <-- Symbolic link to user tlscert"
echo    "    ├── key.pem                            <-- Symbolic link to user tlskey"
echo    "    └── docker-ca/                         <-- Working directory to create certs"

echo -e "\n${BOLD}DOCUMENTATION${NORMAL}"
echo    "   https://github.com/BradleyA/docker-security-infrastructure/blob/master/docker-TLS/README.md"

echo -e "\n${BOLD}EXAMPLES${NORMAL}"
echo -e "   Create TLS keys for user bob for 30 days in /u/north-office/ uadmin\n\t${BOLD}${0} bob 30 /u/north-office/ uadmin${NORMAL}"
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
new_message "${LINENO}" "INFO" "  Started..." 1>&2

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
    *)  new_message "${LINENO}" "ERROR" "  Option, ${BOLD}${YELLOW}${1}${NORMAL}, entered on the command line is not supported." 1>&2 ; display_usage ; exit 1 ; ;;
  esac
done

###

TLS_USER=${1:-${DEFAULT_TLS_USER}}
NUMBER_DAYS=${2:-${DEFAULT_NUMBER_DAYS}}
#    Order of precedence: CLI argument, environment variable, default code
if [[ $# -ge  3 ]]  ; then USER_HOME=${3} ; elif [[ "${USER_HOME}" == "" ]] ; then USER_HOME="${DEFAULT_USER_HOME}/" ; fi
ADM_TLS_USER=${4:-${DEFAULT_ADM_TLS_USER}}
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  TLS_USER >${TLS_USER}< NUMBER_DAYS >${NUMBER_DAYS}< USER_HOME >${USER_HOME}< ADM_TLS_USER >${ADM_TLS_USER}<" 1>&2 ; fi

#    Check if admin user has home directory on system
if [[ ! -d "${USER_HOME}${ADM_TLS_USER}" ]] ; then
  new_message "${LINENO}" "ERROR" "  ${ADM_TLS_USER} does not have a home directory on this system or ${ADM_TLS_USER} home directory is not ${USER_HOME}${ADM_TLS_USER}" 1>&2
  exit 1
fi

#    Check if site CA directory on system
if [[ ! -d "${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca/.private" ]] ; then
  new_message "${LINENO}" "ERROR" "  Default directory, ${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca/.private, not on system." 1>&2
#    Help hint
  echo -e "\n\tRunning create-site-private-public-tls.sh will create directories"
  echo -e "\tand site private and public keys.  Then run sudo"
  echo -e "\tcreate-new-openssl.cnf-tls.sh to modify openssl.cnf file.  Then run"
  echo -e "\tcreate-host-tls.sh or create-user-tls.sh as many times as you want."
  exit 1
fi
cd "${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca"

#    Check if ca-priv-key.pem file on system
if ! [[ -e "${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca/.private/ca-priv-key.pem" ]] ; then
  display_help | more
  new_message "${LINENO}" "ERROR" "  Site private key ${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca/.private/ca-priv-key.pem is not in this location." 1>&2
#    Help hint
  echo -e "\n\tEither move it from your site secure location to"
  echo -e "\t${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca/.private/"
  echo -e "\tOr run create-site-private-public-tls.sh and sudo"
  echo -e "\tcreate-new-openssl.cnf-tls.sh to create a new one."
  exit 1
fi

#    Check if ${TLS_USER}-user-priv-key.pem file on system
if [[ -e "${TLS_USER}-user-priv-key.pem" ]] ; then
  new_message "${LINENO}" "WARN" "  ${TLS_USER}-user-priv-key.pem already exists, renaming existing keys so new keys can be created." 1>&2
  mv "${TLS_USER}-user-priv-key.pem"  "${TLS_USER}-user-priv-key.pem$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)"
  mv "${TLS_USER}-user-cert.pem"      "${TLS_USER}-user-cert.pem$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)"
fi

#    Creating private key for user ${TLS_USER}
new_message "${LINENO}" "INFO" "  Creating private key for user ${TLS_USER}." 1>&2
openssl genrsa -out "${TLS_USER}-user-priv-key.pem" 2048

#    Generate a Certificate Signing Request (CSR)
new_message "${LINENO}" "INFO" "  Generate a Certificate Signing Request (CSR) for user ${TLS_USER}." 1>&2
openssl req -subj '/subjectAltName=client' -new -key "${TLS_USER}-user-priv-key.pem" -out "${TLS_USER}-user.csr"

#    Create and sign a ${NUMBER_DAYS} day certificate
new_message "${LINENO}" "INFO" "  Create and sign a ${NUMBER_DAYS} day certificate for user ${TLS_USER}." 1>&2
openssl x509 -req -days "${NUMBER_DAYS}" -sha256 -in "${TLS_USER}-user.csr" -CA ca.pem -CAkey .private/ca-priv-key.pem -CAcreateserial -out "${TLS_USER}-user-cert.pem" || { new_message "${LINENO}" "ERROR" "  Wrong pass phrase for .private/ca-priv-key.pem:" ; exit 1; }

#    Removing certificate signing requests (CSR)
new_message "${LINENO}" "INFO" "  Removing certificate signing requests (CSR) and set file permissions for ${TLS_USER} key pairs." 1>&2
rm    "${TLS_USER}-user.csr"
chmod 0400  "${TLS_USER}-user-priv-key.pem"
chmod 0444  "${TLS_USER}-user-cert.pem"

#    Help hint
echo -e "\nUse script ${BOLD}copy-user-2-remote-host-tls.sh${NORMAL} to update remote host."

#
new_message "${LINENO}" "INFO" "  Operation finished..." 1>&2
###
