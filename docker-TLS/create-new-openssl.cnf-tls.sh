#!/bin/bash
# 	docker-TLS/create-new-openssl.cnf-tls.sh  3.486.1011  2019-11-10T21:51:01.001852-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.485  
# 	   docker-TLS/create-new-openssl.cnf-tls.sh  improve output by adding color 
# 	docker-TLS/create-new-openssl.cnf-tls.sh  3.473.993  2019-10-21T23:10:48.852953-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.472  
# 	   docker-TLS/create-new-openssl.cnf-tls.sh   added color output ; upgraded Production standard 4.3.534 Documentation Language 
# 	docker-TLS/create-new-openssl.cnf-tls.sh  3.459.966  2019-10-13T22:29:12.511725-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.458-1-g0f0c76f  
# 	   close #67  docker-TLS/create-new-openssl.cnf-tls.sh  Production standard 2.3.529 log format, 8.3.530 --usage, 1.3.531 DEBUG variable 
# 	docker-TLS/create-new-openssl.cnf-tls.sh  3.234.679  2019-04-10T23:30:18.635712-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  six-rpi3b.cptx86.com 3.233  
# 	   production standard 6.1.177 Architecture tree 
#86# docker-TLS/create-new-openssl.cnf-tls.sh - Modify /etc/ssl/openssl.conf file
### production standard 3.0 shellcheck
### production standard 5.1.160 Copyright
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
BACKUP_FILE="/etc/ssl/openssl.cnf-$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)"
ORIGINAL_FILE="/etc/ssl/openssl.cnf"

###  Production standard 8.3.530 --usage
display_usage() {
COMMAND_NAME=$(echo "${0}" | sed 's/^.*\///')
echo -e "\n${NORMAL}${COMMAND_NAME}\n   Modify /etc/ssl/openssl.conf file"
echo -e "\n${BOLD}USAGE${NORMAL}"
echo -e "   sudo ${COMMAND_NAME}\n"
echo    "   ${COMMAND_NAME} [--help | -help | help | -h | h | -?]"
echo    "   ${COMMAND_NAME} [--usage | -usage | -u]"
echo    "   ${COMMAND_NAME} [--version | -version | -v]"
}

###  Production standard 0.3.214 --help
display_help() {
display_usage
#    Displaying help DESCRIPTION in English en_US.UTF-8
echo -e "\n${BOLD}DESCRIPTION${NORMAL}"
echo    "This script makes a change to openssl.cnf file which is required for"
echo    "create-user-tls.sh and create-host-tls.sh scripts.  It must be run as root."

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

###  Production standard 6.1.177 Architecture tree
echo -e "\n${BOLD}ARCHITECTURE TREE${NORMAL}"  # STORAGE & CERTIFICATION
echo    "/etc/ "
echo -e "└── ssl/openssl.cnf                        <-- OpenSSL configuration file\n"

echo -e "\n${BOLD}DOCUMENTATION${NORMAL}"
echo    "   https://github.com/BradleyA/docker-security-infrastructure/blob/master/docker-TLS/README.md"

echo -e "\n${BOLD}EXAMPLES${NORMAL}"
echo -e "   Modify /etc/ssl/openssl.conf file\n\t${BOLD}sudo ${0}${NORMAL}"
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

#    Root is required to copy certs
if ! [[ "${UID}"  = 0 ]] ; then
  display_help | more
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Use sudo ${COMMAND_NAME}" 1>&2
#    Help hint
  echo -e "\n\t${BOLD}>>   SCRIPT MUST BE RUN AS ROOT   <<\n${NORMAL}"  1>&2
  exit 1
fi

###

if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  BACKUP_FILE >${BACKUP_FILE} ORIGINAL_FILE >${ORIGINAL_FILE}<" 1>&2 ; fi

#    Check if ${ORIGINAL_FILE} file has previously been modified
if ! grep -Fxq 'extendedKeyUsage = clientAuth,serverAuth' ${ORIGINAL_FILE} ; then
#    Help hint
  echo -e "\tThis script will make changes to ${ORIGINAL_FILE} file."
  echo -e "\tThese changes are required before creating user and host TLS keys for Docker."
  echo -e "\tRun this script before running the user and host TLS scripts.  It is not"
  echo -e "\trequired to be run on hosts not creating TLS keys."
  echo -e "\n\tCreating ${YELLOW}backup${NORMAL} file of ${ORIGINAL_FILE} and naming it ${YELLOW}${BACKUP_FILE}${NORMAL}"
  cp "${ORIGINAL_FILE}"  "${BACKUP_FILE}"
  new_message "${LINENO}" "${YELLOW}INFO${WHITE}" "  Adding the extended KeyUsage at the beginning of [ v3_ca ] section." 1>&2
  sed '/\[ v3_ca \]/a extendedKeyUsage = clientAuth,serverAuth' "${BACKUP_FILE}" > ${ORIGINAL_FILE}
else
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  ${ORIGINAL_FILE} file has previously been modified." 1>&2
fi

#
new_message "${LINENO}" "${YELLOW}INFO${WHITE}" "  Operation finished..." 1>&2
###
