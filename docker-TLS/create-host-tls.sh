#!/bin/bash
# 	docker-TLS/create-host-tls.sh  3.497.1029  2019-11-20T16:54:53.261783-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.496-1-g39a5ece  
# 	   docker-TLS/create-host-tls.sh docker-TLS/create-user-tls.sh   testing 
#86# docker-TLS/create-host-tls.sh - Create host public, private keys and CA
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
DEFAULT_FQDN=$(hostname -f)    # local host
DEFAULT_NUMBER_DAYS="180"
DEFAULT_WORKING_DIRECTORY=~/.docker/docker-ca
DEFAULT_CA_CERT="ca.pem"
DEFAULT_CA_PRIVATE_CERT="ca-priv-key.pem"

###  Production standard 8.3.530 --usage
display_usage() {
COMMAND_NAME=$(echo "${0}" | sed 's/^.*\///')
echo -e "\n${NORMAL}${COMMAND_NAME}\n   Create host public, private keys and CA"
echo -e "\n${BOLD}USAGE${NORMAL}"
echo    "   ${YELLOW}Positional Arguments${NORMAL}"
echo    "   ${COMMAND_NAME} [<FQDN>]"
echo    "   ${COMMAND_NAME}  <FQDN> [<NUMBER_DAYS>]"
echo -e "   ${COMMAND_NAME}  <FQDN>  <NUMBER_DAYS> [<WORKING_DIRECTORY>]\n"
echo    "   ${COMMAND_NAME} [--help | -help | help | -h | h | -?]"
echo    "   ${COMMAND_NAME} [--usage | -usage | -u]"
echo    "   ${COMMAND_NAME} [--version | -version | -v]"
}

###  Production standard 0.3.214 --help
display_help() {
display_usage
#    Displaying help DESCRIPTION in English en_US.UTF-8
echo -e "\n${BOLD}DESCRIPTION${NORMAL}"
echo    "An administration user runs this script to create host public and private keys"
echo    "in the working directory (${DEFAULT_WORKING_DIRECTORY})"
echo    "on the site TLS server."
echo -e "\nThe scripts create-site-private-public-tls.sh and create-new-openssl.cnf-tls.sh"
echo    "are required to create a site TLS server.  Review the DOCUMENTATION for a"
echo    "complete understanding."

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
echo    "   FQDN              Fully qualified domain name of host requiring new TLS keys"
echo    "                     (default ${DEFAULT_FQDN})"
echo    "   NUMBER_DAYS       Number of days host keys are valid"
echo    "                     (default ${DEFAULT_NUMBER_DAYS})"
echo    "   WORKING_DIRECTORY Absolute path for working directory"
echo    "                     (default ${DEFAULT_WORKING_DIRECTORY})"

###  Production standard 6.3.539 Architecture tree
echo -e "\n${BOLD}ARCHITECTURE TREE${NORMAL}"  # STORAGE & CERTIFICATION
echo    "<USER_HOME>/                               <-- Location of user home directory"
echo    "└── <USER-1>/.docker/                      <-- User docker cert directory"
echo    "    └── docker-ca/                         <-- Working directory to create certs"
echo    "        ├── .private/                      "                                       # 3.539
echo    "        │   └── ca-priv-key.pem            <-- Current site CA Private Key"        # 3.539
echo    "        ├── ca.pem                         <-- Current site CA cert"               # 3.539
echo    "        ├── hosts/                         <-- Directory for hostnames"            # 3.539
echo    "        │   └── <HOST>/                    <-- Directory to store host certs"      # 3.539
echo    "        ├── site/                          <-- Directory to store site certs"      # 3.539
echo    "        │   ├── ca.pem_20xx-...            <-- CA Cert"                            # 3.539
echo    "        │   └── ca-priv-key.pem_20xx-...   <-- CA Private Key"                     # 3.539
echo    "        └── users/                         <-- Directory for users"                # 3.539
echo    "            └── <USER>/                    <-- Directory to store user certs"      # 3.539

echo -e "\n${BOLD}DOCUMENTATION${NORMAL}"
echo    "   https://github.com/BradleyA/docker-security-infrastructure/blob/master/docker-TLS/README.md"

echo -e "\n${BOLD}EXAMPLES${NORMAL}"
echo -e "   Create TLS keys for host three.cptx86.com for 30 days in /u/north-office/uadmin/.docker/docker-ca\n\t${BOLD}${0} three.cptx86.com 30 /u/north-office/uadmin/.docker/docker-ca${NORMAL}"
echo -e "   Create TLS keys for host zero.cptx86.com for 5 days in default working directory\n\t${BOLD}${0} zero.cptx86.com 5${NORMAL}"
echo -e "   Create TLS keys for host two.cptx86.com for default number of days in default working directory\n\t${BOLD}${0} two.cptx86.com${NORMAL}"
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

FQDN=${1:-${DEFAULT_FQDN}}
NUMBER_DAYS=${2:-${DEFAULT_NUMBER_DAYS}}
#    Order of precedence: CLI argument, environment variable, default code
if [[ $# -ge  3 ]]  ; then WORKING_DIRECTORY=${3} ; elif [[ "${WORKING_DIRECTORY}" == "" ]] ; then WORKING_DIRECTORY="${DEFAULT_WORKING_DIRECTORY}" ; fi
#    Order of precedence: environment variable, default code
if [[ "${CA_CERT}" == "" ]] ; then CA_CERT="${DEFAULT_CA_CERT}" ; fi
if [[ "${CA_PRIVATE_CERT}" == "" ]] ; then CA_PRIVATE_CERT="${DEFAULT_CA_PRIVATE_CERT}" ; fi
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  FQDN >${FQDN}< NUMBER_DAYS >${NUMBER_DAYS}< WORKING_DIRECTORY >${WORKING_DIRECTORY}< CA_CERT >${CA_CERT}< CA_PRIVATE_CERT >${CA_PRIVATE_CERT}<" 1>&2 ; fi

#    Check if ${WORKING_DIRECTORY} is on system
if [[ ! -d "${WORKING_DIRECTORY}" ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  ${WORKING_DIRECTORY} does not exist on this system.\n  Enter ${0} --help for more information." 1>&2
  exit 1
fi

#    Check if site CA directory on system
if [[ ! -d "${WORKING_DIRECTORY}/.private" ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Default directory, ${WORKING_DIRECTORY}/.private, not on system." 1>&2
#    Help hint
  echo -e "\n\tRunning ${YELLOW}create-site-private-public-tls.sh${WHITE} will create directories"
  echo -e "\tand site private and public keys.  Then run sudo"
  echo -e "\t${YELLOW}create-new-openssl.cnf-tls.sh${WHITE} to modify openssl.cnf file.  Then run"
  echo -e "\t${YELLOW}create-host-tls.sh${WHITE} or ${YELLOW}create-user-tls.sh${WHITE} as many times as you want."
  exit 1
fi
cd "${WORKING_DIRECTORY}"

#    Check if ${CA_PRIVATE_CERT} file on system
if ! [[ -e "${WORKING_DIRECTORY}/.private/${CA_PRIVATE_CERT}" ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Site private key ${WORKING_DIRECTORY}/.private/${CA_PRIVATE_CERT}\n  is not in this location.\n  Enter ${0} --help for more information." 1>&2
#    Help hint
  echo -e "\n\tEither move it from your site secure location to"
  echo -e "\t${WORKING_DIRECTORY}/.private/"
  echo -e "\tor run ${YELLOW}create-site-private-public-tls.sh${WHITE} and sudo"
  echo -e "\t${YELLOW}create-new-openssl.cnf-tls.sh${WHITE} to create a new one."
  exit 1
fi

#    Prompt for ${FQDN} if argement not entered
if [[ -z "${FQDN}" ]] ; then
  echo -e "\n\t${BOLD}Enter fully qualified domain name (FQDN) requiring new TLS keys:${NORMAL}"
  read FQDN
fi

#    Check if ${FQDN} string length is zero
if [[ -z "${FQDN}" ]] ; then
  display_help | more
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  A Fully Qualified Domain Name (FQDN) is required to create new host TLS keys." 1>&2
  exit 1
fi
mkdir -p "${FQDN}"

if [[ -e "${FQDN}-priv-key.pem" ]] ; then
  rm  -f "${FQDN}-priv-key.pem"
  rm  -f "${FQDN}-cert.pem"
fi

#    Creating private key for host ${FQDN}
echo -e "\n\tCreating private key for host ${BOLD}${YELLOW}${FQDN}${NORMAL}"
openssl genrsa -out "${FQDN}-priv-key.pem" 2048

#    Create CSR (Certificate Signing Request) for host ${FQDN}
echo -e "\n\tGenerate a Certificate Signing Request (CSR) for"
echo -e "\thost ${BOLD}${FQDN}${NORMAL}"
openssl req -sha256 -new -key "${FQDN}-priv-key.pem" -subj "/CN=${FQDN}/subjectAltName=${FQDN}" -out "${FQDN}.csr"

#    Create and sign a ${NUMBER_DAYS} day certificate for host ${FQDN}
echo -e "\n\tCreate and sign a  ${BOLD}${YELLOW}${NUMBER_DAYS}${NORMAL}  day certificate for host ${FQDN}."
echo -e "\t${BOLD}${FQDN}${NORMAL}"
openssl x509 -req -days "${NUMBER_DAYS}" -sha256 -in "${FQDN}.csr" -CA ${CA_CERT} -CAkey .private/${CA_PRIVATE_CERT} -CAcreateserial -out "${FQDN}-cert.pem" -extensions v3_req -extfile /usr/lib/ssl/openssl.cnf || { new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Wrong pass phrase for .private/${CA_PRIVATE_CERT}: " ; exit 1; }
openssl rsa -in "${FQDN}-priv-key.pem" -out "${FQDN}-priv-key.pem"

#    Removing certificate signing requests (CSR)
echo -e "\n\tRemoving certificate signing requests (CSR) and set file permissions"
echo -e "\tfor host ${BOLD}${FQDN}${NORMAL} key pairs."
rm    "${FQDN}.csr"
rm    ca.srl
chmod 0400 "${FQDN}-priv-key.pem"
chmod 0444 "${FQDN}-cert.pem"

#    Place a copy in ${WORKING_DIRECTORY}/${FQDN} directory
CERT_CREATE_DATE=$(date +%Y-%m-%dT%H:%M:%S-%Z)
CA_CERT_START_DATE_TEMP=$(openssl x509 -in "${CA_CERT}" -noout -startdate | cut -d '=' -f 2)
CA_CERT_START_DATE=$(date -d"${CA_CERT_START_DATE_TEMP}" +%Y-%m-%dT%H:%M:%S-%Z)
CA_CERT_EXPIRE_DATE_TEMP=$(openssl x509 -in "${CA_CERT}" -noout -enddate  | cut -d '=' -f 2)
CA_CERT_EXPIRE_DATE=$(date -d"${CA_CERT_EXPIRE_DATE_TEMP}" +%Y-%m-%dT%H:%M:%S-%Z)
cp -p ${CA_CERT}              "${FQDN}/${CA_CERT}--${CERT_CREATE_DATE}---${CA_CERT_START_DATE}--${CA_CERT_EXPIRE_DATE}"
CA_CERT_EXPIRE_DATE_TEMP=$(openssl x509 -in "${FQDN}-cert.pem" -noout -enddate  | cut -d '=' -f 2)
CA_CERT_EXPIRE_DATE=$(date -d"${CA_CERT_EXPIRE_DATE_TEMP}" +%Y-%m-%dT%H:%M:%S-%Z)
mv   "${FQDN}-cert.pem"       "${FQDN}/${FQDN}-cert.pem---${CERT_CREATE_DATE}--${CA_CERT_EXPIRE_DATE}"
mv   "${FQDN}-priv-key.pem"   "${FQDN}/${FQDN}-priv-key.pem---${CERT_CREATE_DATE}--${CA_CERT_EXPIRE_DATE}"
echo   "${BOLD}${CYAN}"
ls -1 "${FQDN}" | grep "${CERT_CREATE_DATE}"

#    Help hint
echo -e "\n\t${NORMAL}Use script ${BOLD}${YELLOW}copy-host-2-remote-host-tls.sh${NORMAL} to update remote host.\n"

#
new_message "${LINENO}" "${YELLOW}INFO${WHITE}" "  Operation finished..." 1>&2
###
