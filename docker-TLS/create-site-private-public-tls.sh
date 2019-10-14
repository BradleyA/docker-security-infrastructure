#!/bin/bash
# 	docker-TLS/create-site-private-public-tls.sh  3.461.971  2019-10-13T23:28:11.915718-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.460-1-g12b7ce8  
# 	   close #60  docker-TLS/create-site-private-public-tls.sh  Production standard 2.3.529 log format, 8.3.530 --usage, 1.3.531 DEBUG variable 
# 	docker-TLS/create-site-private-public-tls.sh  3.281.748  2019-06-10T16:46:36.898604-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.280  
# 	   trying to reproduce docker-TLS/check-{host,user}-tls.sh - which one should check if the ca.pem match #49 
#86# docker-TLS/create-site-private-public-tls.sh - Create site private and CA keys
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
DEFAULT_NUMBER_DAYS="730"
DEFAULT_CA_CERT="ca.pem"
DEFAULT_CA_PRIVATE_CERT="ca-priv-key.pem"
DEFAULT_WORKING_DIRECTORY=~/.docker

###  Production standard 8.3.530 --usage
display_usage() {
COMMAND_NAME=$(echo "${0}" | sed 's/^.*\///')
echo -e "\n${NORMAL}${COMMAND_NAME}\n   Create site private and CA keys"
echo -e "\n${BOLD}USAGE${NORMAL}"
echo    "   ${YELLOW}Positional Arguments${NORMAL}"
echo    "   ${COMMAND_NAME} [<NUMBER_DAYS>]"
echo    "   ${COMMAND_NAME}  <NUMBER_DAYS> [<CA_CERT>]"
echo -e "   ${COMMAND_NAME}  <NUMBER_DAYS>  <CA_CERT> [<WORKING_DIRECTORY>]\n"
echo    "   ${COMMAND_NAME} [--help | -help | help | -h | h | -?]"
echo    "   ${COMMAND_NAME} [--usage | -usage | -u]"
echo    "   ${COMMAND_NAME} [--version | -version | -v]"
}

###  Production standard 0.3.214 --help
display_help() {
display_usage
#    Displaying help DESCRIPTION in English en_US.UTF-8
echo -e "\n${BOLD}DESCRIPTION${NORMAL}"
echo    "An administration user can run this script to create site private and CA"
echo    "keys.  Run this script first on your host that will be creating all your TLS"
echo    "keys for your site.  It creates the working directories"
echo    "<WORKING_DIRECTORY>/docker-ca and <WORKING_DIRECTORY>/docker-ca/.private"
echo -e "for your site private and CA keys. \n"
echo    "If you later choose to use a different host to continue creating your user"
echo    "and host TLS keys, cp the <WORKING_DIRECTORY>/docker-ca and"
echo    "<WORKING_DIRECTORY>/docker-ca/.private to the new host and run"
echo -e "\t${BOLD}create-new-openssl.cnf-tls.sh scipt.${NORMAL}"

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
echo    "   DEBUG             (default off '0')"
echo    "   CA_CERT           File name of certificate (default ${DEFAULT_CA_CERT})"
echo    "   CA_PRIVATE_CERT   File name of private certificate (default ${DEFAULT_CA_PRIVATE_CERT})"
echo    "   WORKING_DIRECTORY Absolute path for working directory"
echo    "                     (default ${DEFAULT_WORKING_DIRECTORY})"

echo -e "\n${BOLD}OPTIONS${NORMAL}"
echo -e "Order of precedence: CLI options, environment variable, default code.\n"
echo    "   NUMBER_DAYS       Number of days host CA is valid (default ${DEFAULT_NUMBER_DAYS})"
echo    "   CA_CERT           File name of certificate (default ${DEFAULT_CA_CERT})"
echo    "   WORKING_DIRECTORY Absolute path for working directory"
echo    "                     (default ${DEFAULT_WORKING_DIRECTORY})"

###  Production standard 6.1.177 Architecture tree
echo -e "\n${BOLD}ARCHITECTURE TREE${NORMAL}"  # STORAGE & CERTIFICATION
echo    "<USER_HOME>/                               <-- Location of user home directory"
echo    "└── <USER-1>/.docker/                      <-- User docker cert directory"
echo    "    └── docker-ca/                         <-- Working directory to create certs"

echo -e "\n${BOLD}DOCUMENTATION${NORMAL}"
echo    "   https://github.com/BradleyA/docker-security-infrastructure/blob/master/docker-TLS/README.md"

echo -e "\n${BOLD}EXAMPLES${NORMAL}"
echo -e "   Create site private and public keys for one year in /usr/local/north-office/certs\n\t${BOLD}${0} 365 ca.pem-north-office /usr/local/north-office/certs${NORMAL}"
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

NUMBER_DAYS=${1:-${DEFAULT_NUMBER_DAYS}}
#    Order of precedence: CLI argument, environment variable, default code
if [[ $# -ge  2 ]]  ; then CA_CERT=${2} ; elif [[ "${CA_CERT}" == "" ]] ; then CA_CERT="${DEFAULT_CA_CERT}" ; fi
if [[ $# -ge  3 ]]  ; then WORKING_DIRECTORY=${3} ; elif [[ "${WORKING_DIRECTORY}" == "" ]] ; then WORKING_DIRECTORY="${DEFAULT_WORKING_DIRECTORY}" ; fi
#    Order of precedence: environment variable, default code
if [[ "${CA_PRIVATE_CERT}" == "" ]] ; then CA_PRIVATE_CERT="${DEFAULT_CA_PRIVATE_CERT}" ; fi
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  NUMBER_DAYS >${NUMBER_DAYS}< CA_CERT >${CA_CERT}< WORKING_DIRECTORY >${WORKING_DIRECTORY}< CA_PRIVATE_CERT >${CA_PRIVATE_CERT}<" 1>&2 ; fi

#    Check if working directory is on system
if [[ ! -d "${WORKING_DIRECTORY}" ]] ; then
  new_message "${LINENO}" "ERROR" "  ${WORKING_DIRECTORY} does not exist on this system" 1>&2
  exit 1
fi
mkdir -p   "${WORKING_DIRECTORY}/docker-ca/.private"
chmod 0700 "${WORKING_DIRECTORY}/docker-ca/.private"
chmod 0700 "${WORKING_DIRECTORY}/docker-ca"
chmod 0700 "${WORKING_DIRECTORY}"
cd         "${WORKING_DIRECTORY}/docker-ca/.private"

#    Check if ${CA_PRIVATE_CERT}  file exists
if [[ -e "${WORKING_DIRECTORY}/docker-ca/.private/${CA_PRIVATE_CERT}" ]] ; then
  echo -e "\tSite private key ${WORKING_DIRECTORY}/docker-ca/.private/${CA_PRIVATE_CERT}\n\talready exists, renaming existing site private key to ${CA_PRIVATE_CERT}_$(date +%Y-%m-%dT%H:%M%:z)_backup" 1>&2
  mv "${WORKING_DIRECTORY}/docker-ca/.private/${CA_PRIVATE_CERT}"  "${WORKING_DIRECTORY}/docker-ca/.private/${CA_PRIVATE_CERT}_$(date +%Y-%m-%dT%H:%M%:z)_backup"
fi

#    Create site private key
echo -e "\tCreating private key and prompting for a passphrase in ${WORKING_DIRECTORY}/docker-ca/.private" 1>&2
openssl genrsa -aes256 -out ${CA_PRIVATE_CERT} 4096  || { new_message "${LINENO}" "ERROR" "  Pass phrase does not match." ; exit 1; }
chmod 0400 "${WORKING_DIRECTORY}/docker-ca/.private/${CA_PRIVATE_CERT}"

#    Check if ${CA_CERT} file exists
cd "${WORKING_DIRECTORY}/docker-ca"
if [[ -e "${CA_CERT}" ]] ; then
  echo -e "\tSite CA ${WORKING_DIRECTORY}/docker-ca/${CA_CERT} already exists, renaming existing site CA" 1>&2

#    Get certificate start and expiration date of ${CA_CERT} file
  CA_CERT_START_DATE=$(openssl x509 -in "${CA_CERT}" -noout -startdate | cut -d '=' -f 2)
  CA_CERT_START_DATE_2=$(date -u -d"${CA_CERT_START_DATE}" +%g%m%d%H%M.%S)
  CA_CERT_START_DATE=$(date -u -d"${CA_CERT_START_DATE}" +%Y-%m-%dT%H:%M:%S%z)
  CA_CERT_EXPIRE_DATE=$(openssl x509 -in "${CA_CERT}" -noout -enddate | cut -d '=' -f 2)
  CA_CERT_EXPIRE_DATE=$(date -u -d"${CA_CERT_EXPIRE_DATE}" +%Y-%m-%dT%H:%M:%S%z)
  mv -f "${CA_CERT}" "${CA_CERT}_${CA_CERT_START_DATE}_${CA_CERT_EXPIRE_DATE}"
  chmod 0444 "${CA_CERT}_${CA_CERT_START_DATE}_${CA_CERT_EXPIRE_DATE}"
  touch -m -t "${CA_CERT_START_DATE_2}" "${CA_CERT}_${CA_CERT_START_DATE}_${CA_CERT_EXPIRE_DATE}"
fi

#    Create site public key
#    Help hint
echo -e "${NORMAL}\n\tOnce all the certificates and keys have been generated with this private key,"
echo -e "\tit would be prudent to move the private key to a Universal Serial Bus (USB)"
echo -e "\tmemory stick.  Remove the private key from the system and store the USB memory"
echo -e "\tstick in a locked fireproof location."
echo -e "\n\tThe public key is copied to all systems in an environment so that those"
echo -e "\tsystems trust signed certificates.  The following is a list of prompts from"
echo -e "\tthe following command and example answers are in parentheses."
echo -e "\tCountry Name (US)"
echo -e "\tState or Province Name (Texas)"
echo -e "\tLocality Name (Cedar Park)"
echo -e "\tOrganization Name (Company Name)"
echo -e "\tOrganizational Unit Name (IT - SRE Team Central US)"
echo -e "\tCommon Name (two.cptx86.com)"
echo -e "\tEmail Address ()\n"
echo -e "\n\tCreating public key good for ${NUMBER_DAYS} days in ${WORKING_DIRECTORY}/docker-ca\n"	1>&2
openssl req -x509 -days "${NUMBER_DAYS}" -sha256 -new -key .private/${CA_PRIVATE_CERT} -out ${CA_CERT} || { new_message "${LINENO}" "ERROR" "  Incorrect pass phrase for .private/${CA_PRIVATE_CERT}" ; exit 1; }

#    Get certificate start and expiration date of ${CA_CERT} file
CA_CERT_START_DATE=$(openssl x509 -in "${CA_CERT}" -noout -startdate | cut -d '=' -f 2)
CA_CERT_START_DATE_2=$(date -u -d"${CA_CERT_START_DATE}" +%g%m%d%H%M.%S)
CA_CERT_START_DATE=$(date -u -d"${CA_CERT_START_DATE}" +%Y-%m-%dT%H:%M:%S%z)
CA_CERT_EXPIRE_DATE=$(openssl x509 -in "${CA_CERT}" -noout -enddate | cut -d '=' -f 2)
CA_CERT_EXPIRE_DATE=$(date -u -d"${CA_CERT_EXPIRE_DATE}" +%Y-%m-%dT%H:%M:%S%z)
cp -f -p "${CA_CERT}" "${CA_CERT}_${CA_CERT_START_DATE}_${CA_CERT_EXPIRE_DATE}"
chmod 0444 "${CA_CERT}" "${CA_CERT}_${CA_CERT_START_DATE}_${CA_CERT_EXPIRE_DATE}"
touch -m -t "${CA_CERT_START_DATE_2}" "${CA_CERT}_${CA_CERT_START_DATE}_${CA_CERT_EXPIRE_DATE}"

cp -f -p ".private/${CA_PRIVATE_CERT}" ".private/${CA_PRIVATE_CERT}_${CA_CERT_START_DATE}_${CA_CERT_EXPIRE_DATE}"
touch 0400 ".private/${CA_PRIVATE_CERT}_${CA_CERT_START_DATE}_${CA_CERT_EXPIRE_DATE}"

#	Help hint

echo -e "\n\t${BOLD}These certificates are valid for ${NUMBER_DAYS} days or until ${CA_CERT_EXPIRE_DATE}${NORMAL}\n"
echo -e "\tIt would be prudent to document the date when to renew these certificates and"
echo -e "\tset an operations or project management calendar entry about 15 days before"
echo -e "\trenewal as a reminder to schedule a new site certificate or open a work\n\tticket."

#
new_message "${LINENO}" "INFO" "  Operation finished..." 1>&2
###
