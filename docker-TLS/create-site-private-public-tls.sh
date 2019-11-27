#!/bin/bash
# 	docker-TLS/create-site-private-public-tls.sh  3.514.1056  2019-11-26T22:45:24.284061-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.513  
# 	   Production standard 6.3.543  Architecture tree 
# 	docker-TLS/create-site-private-public-tls.sh  3.511.1051  2019-11-24T16:05:56.343289-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.510  
# 	   docker-TLS/create-site-private-public-tls.sh  update user hint, move files to sync with Production standard 6.3.539  Architecture tree, alot of debugging 
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
RED=$(tput    setaf 1)
YELLOW=$(tput setaf 3)
CYAN=$(tput   setaf 6)
WHITE=$(tput  setaf 7)

###  Production standard 7.0 Default variable value
DEFAULT_NUMBER_DAYS="730"
DEFAULT_CA_CERT="ca.pem"
DEFAULT_CA_PRIVATE_CERT="ca-priv-key.pem"
DEFAULT_WORKING_DIRECTORY=~/.docker/docker-ca

###  Production standard 8.3.541 --usage
COMMAND_NAME=$(echo "${0}" | sed 's/^.*\///')   # 3.541
display_usage() {
echo -e "\n${NORMAL}${COMMAND_NAME}\n   Create site CA and private keys"
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
echo    "key.  Run this script first on your host that will be creating all your TLS"
echo    "keys for your site.  It creates the working directories <WORKING_DIRECTORY>"
echo -e "(${DEFAULT_WORKING_DIRECTORY}) for your site.\n"
echo    "If you later choose to use a different host to continue creating your user"
echo    "and host TLS keys, cp the <WORKING_DIRECTORY> to the new host and run"
echo -e "\t${BOLD}${YELLOW}create-new-openssl.cnf-tls.sh scipt.${NORMAL}"

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
echo    "   CA_CERT           File name of certificate (default ${DEFAULT_CA_CERT})"
echo    "   CA_PRIVATE_CERT   File name of private certificate"
echo    "                     (default ${DEFAULT_CA_PRIVATE_CERT})"
echo    "   WORKING_DIRECTORY Absolute path for working directory"
echo    "                     (default ${DEFAULT_WORKING_DIRECTORY})"

echo -e "\n${BOLD}OPTIONS${NORMAL}"
echo -e "Order of precedence: CLI options, environment variable, default code.\n"
echo    "   NUMBER_DAYS       Number of days host CA is valid"
echo    "                     (default ${DEFAULT_NUMBER_DAYS})"
echo    "   CA_CERT           File name of certificate (default ${DEFAULT_CA_CERT})"
echo    "   WORKING_DIRECTORY Absolute path for working directory"
echo    "                     (default ${DEFAULT_WORKING_DIRECTORY})"

###  Production standard 6.3.543 Architecture tree
echo -e "\n${BOLD}ARCHITECTURE TREE${NORMAL}"  # STORAGE & CERTIFICATION
echo    "<USER_HOME>/                               <-- Location of user home directory"
echo    "└── <USER-1>/.docker/                      <-- User docker cert directory"
echo    "    └── docker-ca/                         <-- Working directory to create certs"
echo    "        ├── .private/                      "                                       # 3.539
echo    "        │   └── ca-priv-key.pem            <-- Current site CA Private Key"        # 3.539
echo    "        ├── ca.pem                         <-- Current site CA cert"               # 3.539
echo    "        ├── hosts/                         <-- Directory for hostnames"            # 3.539
echo    "        │   └── <HOST>/                    <-- Directory to store host certs"      # 3.539
echo    "        │      ├── ca.pem                  <-- CA Cert"                            # 3.542
echo    "        │      ├── cert.pem                <-- public key"                         # 3.543
echo    "        │      └── priv-key.pem            <-- private key"                        # 3.543
echo    "        ├── site/                          <-- Directory to store site certs"      # 3.539
echo    "        │   ├── ca.pem_20xx-...            <-- CA Cert"                            # 3.539
echo    "        │   └── ca-priv-key.pem_20xx-...   <-- CA Private Key"                     # 3.539
echo    "        └── users/                         <-- Directory for users"                # 3.539
echo    "            └── <USER>/                    <-- Directory to store user certs"      # 3.539

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

NUMBER_DAYS=${1:-${DEFAULT_NUMBER_DAYS}}
#    Order of precedence: CLI argument, environment variable, default code
if [[ $# -ge  2 ]]  ; then CA_CERT=${2} ; elif [[ "${CA_CERT}" == "" ]] ; then CA_CERT="${DEFAULT_CA_CERT}" ; fi
if [[ $# -ge  3 ]]  ; then WORKING_DIRECTORY=${3} ; elif [[ "${WORKING_DIRECTORY}" == "" ]] ; then WORKING_DIRECTORY="${DEFAULT_WORKING_DIRECTORY}" ; fi
#    Order of precedence: environment variable, default code
if [[ "${CA_PRIVATE_CERT}" == "" ]] ; then CA_PRIVATE_CERT="${DEFAULT_CA_PRIVATE_CERT}" ; fi
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  NUMBER_DAYS >${NUMBER_DAYS}< CA_CERT >${CA_CERT}< WORKING_DIRECTORY >${WORKING_DIRECTORY}< CA_PRIVATE_CERT >${CA_PRIVATE_CERT}<" 1>&2 ; fi

#    Test <NUMBER_DAYS> for integer
if ! [[ "${NUMBER_DAYS}" =~ ^[0-9]+$ ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  <NUMBER_DAYS> is not an interger.  <NUMBER_DAYS> is set to '${NUMBER_DAYS}'" 1>&2
  display_usage
  exit 1
fi

CERT_CREATE_DATE=$(date +%Y-%m-%dT%H:%M:%S-%Z)
mkdir -p   "${WORKING_DIRECTORY}/.private"
mkdir -p   "${WORKING_DIRECTORY}/site"
chmod 0700 "${WORKING_DIRECTORY}/.private" || { new_message "${LINENO}" "${RED}ERROR${WHITE}" "  You do not have permission to manage ${WORKING_DIRECTORY}/.private on this system" ; exit 1; }
chmod 0700 "${WORKING_DIRECTORY}" || { new_message "${LINENO}" "${RED}ERROR${WHITE}" "  You do not have permission to manage ${WORKING_DIRECTORY} on this system" ; exit 1; }
chmod 0700 "${WORKING_DIRECTORY}/site"
cd         "${WORKING_DIRECTORY}/.private"

#    Check if ${CA_PRIVATE_CERT}  link exists
if [[ -e "${CA_PRIVATE_CERT}" ]] ; then
  echo -e "\n${BOLD}${CYAN}"
  ls -l "${CA_PRIVATE_CERT}"
  echo -e "\n\t${NORMAL}Site private key ${WORKING_DIRECTORY}/.private/${CA_PRIVATE_CERT}\n\talready exists.  ${BOLD}${YELLOW}Do you want to use this site private key? (y/n)${NORMAL}?" 1>&2
  read ANSWER
  if ! [[ "${ANSWER}"  == "Y" || "${ANSWER}"  == "Yes" || "${ANSWER}"  == "y" || "${ANSWER}"  == "yes" ]] ; then
    rm -f "${CA_PRIVATE_CERT}"
    #    Create site private key
    echo -e "\tCreating private key and prompting for a new passphrase in ${BOLD}${YELLOW}${WORKING_DIRECTORY}/.private${NORMAL}" 1>&2
    openssl genrsa -aes256 -out "${CA_PRIVATE_CERT}--${CERT_CREATE_DATE}" 4096  || { new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Both pass phrases entered do not match each other." ; exit 1; }
    chmod 0400 "${CA_PRIVATE_CERT}--${CERT_CREATE_DATE}"
    mv     "${CA_PRIVATE_CERT}--${CERT_CREATE_DATE}"  "${WORKING_DIRECTORY}/site"
    ln -sf "../site/${CA_PRIVATE_CERT}--${CERT_CREATE_DATE}"  "../.private/${CA_PRIVATE_CERT}"
  else
    CERT_CREATE_DATE=$(ls -l "${CA_PRIVATE_CERT}" | sed -e 's/^.*--//')
  fi
else
  #    Create site private key
  echo -e "\tCreating private key and prompting for a new passphrase in ${BOLD}${YELLOW}${WORKING_DIRECTORY}/.private${NORMAL}" 1>&2
  openssl genrsa -aes256 -out "${CA_PRIVATE_CERT}--${CERT_CREATE_DATE}" 4096  || { new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Both pass phrases entered do not match each other." ; exit 1; }
  chmod 0400 "${CA_PRIVATE_CERT}--${CERT_CREATE_DATE}"
  mv     "${CA_PRIVATE_CERT}--${CERT_CREATE_DATE}"  "${WORKING_DIRECTORY}/site"
  ln -sf "../site/${CA_PRIVATE_CERT}--${CERT_CREATE_DATE}"  "../.private/${CA_PRIVATE_CERT}"
fi

#    Create site public key
#    Help hint
echo -e "\n\t${NORMAL}The following is a list of prompts and example answers are in parentheses."
echo -e "\tCountry Name (US), State or Province Name (Texas), Locality Name (Cedar"
echo -e "\tPark), Organization Name (Company Name), Organizational Unit Name (IT -"
echo -e "\tSRE Team Central US), Common Name (${LOCALHOST}), and Email Address"
echo -e "\n\tCreating public key good for  ${BOLD}${YELLOW}${NUMBER_DAYS}${NORMAL}  days in ${WORKING_DIRECTORY} directory.\n"	1>&2
openssl req -x509 -days "${NUMBER_DAYS}" -sha256 -new -key "${CA_PRIVATE_CERT}" -out "${CA_CERT}--${CERT_CREATE_DATE}" || { new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Incorrect pass phrase for ${WORKING_DIRECTORY}/.private/${CA_PRIVATE_CERT}" ; exit 1; }

#    Get certificate start and expiration date of ${CA_CERT} file
CA_CERT_START_DATE_TEMP=$(openssl x509 -in "${CA_CERT}--${CERT_CREATE_DATE}" -noout -startdate | cut -d '=' -f 2)
CA_CERT_START_DATE_2=$(date -u -d"${CA_CERT_START_DATE_TEMP}" +%g%m%d%H%M.%S)
CA_CERT_START_DATE=$(date -d"${CA_CERT_START_DATE_TEMP}" +%Y-%m-%dT%H:%M:%S-%Z)
CA_CERT_EXPIRE_DATE_TEMP=$(openssl x509 -in "${CA_CERT}--${CERT_CREATE_DATE}" -noout -enddate | cut -d '=' -f 2)
CA_CERT_EXPIRE_DATE=$(date -d"${CA_CERT_EXPIRE_DATE_TEMP}" +%Y-%m-%dT%H:%M:%S-%Z)
mv     "${CA_CERT}--${CERT_CREATE_DATE}"  "${CA_CERT}--${CERT_CREATE_DATE}---${CA_CERT_START_DATE}--${CA_CERT_EXPIRE_DATE}"
chmod 0444  "${CA_CERT}--${CERT_CREATE_DATE}---${CA_CERT_START_DATE}--${CA_CERT_EXPIRE_DATE}"
touch -m -t "${CA_CERT_START_DATE_2}"  "${CA_CERT}--${CERT_CREATE_DATE}---${CA_CERT_START_DATE}--${CA_CERT_EXPIRE_DATE}"
mv     "${CA_CERT}--${CERT_CREATE_DATE}---${CA_CERT_START_DATE}--${CA_CERT_EXPIRE_DATE}"  "${WORKING_DIRECTORY}/site"
ln -sf "site/${CA_CERT}--${CERT_CREATE_DATE}---${CA_CERT_START_DATE}--${CA_CERT_EXPIRE_DATE}"  "../${CA_CERT}"

#	Help hint
echo -e "\n\t${BOLD}These certificates are valid for  ${YELLOW}${NUMBER_DAYS}${WHITE}  days or until ${YELLOW}${CA_CERT_EXPIRE_DATE}${NORMAL}"
echo -e "${BOLD}${CYAN}"
ls -l "${CA_PRIVATE_CERT}"
cd ..
ls -l "${CA_CERT}"
echo -e "${NORMAL}\n\tNow that the certificate has been generated, it would be prudent to move"
echo -e "\tthe private key to a Universal Serial Bus (USB) memory stick after creating your"
echo -e "\tother host and user keys.  Remove the private key from the system and store the USB"
echo -e "\tmemory stick in a locked fireproof location.  Also document the date when to renew"
echo -e "\tthese certificates and set an operations or project management calendar or ticket"
echo -e "\tentry about 15 days before renewal as a reminder."

#
new_message "${LINENO}" "${YELLOW}INFO${WHITE}" "  Operation finished..." 1>&2
###
