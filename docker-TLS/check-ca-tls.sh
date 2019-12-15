#!/bin/bash
# 	docker-TLS/check-ca-tls.sh  3.547.1114  2019-12-14T23:22:01.979282-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.546  
# 	   docker-TLS/check-ca-tls.sh  begin testing Production standard 0.3.550 --help 
# 	docker-TLS/check-ca-tls.sh  3.546.1113  2019-12-14T16:57:25.372870-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.545-3-ga1fbf5a  
# 	   docker-TLS/check-ca-tls.sh  update output and display_help 
# 	docker-TLS/check-ca-tls.sh  3.543.1106  2019-12-13T16:20:51.645739-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.542  
# 	   Production standard 6.3.547  Architecture tree  Production standard 8.3.541 --usage 
# 	docker-TLS/check-ca-tls.sh  3.466.981  2019-10-21T21:43:30.920833-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.465-1-g5db421c  
# 	   docker-TLS/check-ca-tls.sh   add color output ; Production standard 4.3.534 Documentation Language 
# 	docker-TLS/check-ca-tls.sh  3.454.951  2019-10-13T15:24:56.576980-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.453  
# 	   docker-TLS/check-ca-tls.sh docker-TLS/check-registry-tls.sh  #59 #61  updated Production standard 2.3.529 log format, 8.3.530 --usage, 1.3.531 DEBUG variable 
# 	docker-TLS/check-ca-tls.sh  3.293.760  2019-07-20T19:51:00.914284-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.292  
# 	   complete, release to production close #56 
#86# docker-TLS/check-ca-tls.sh - shell script start and end dates of ${DEFAULT_CERT_DIR}/${DEFAULT_CA_CERT}
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
CYAN=$(tput   setaf 6)
WHITE=$(tput  setaf 7)

###  Production standard 7.0 Default variable value
DEFAULT_CERT_DIR="${HOME}/.docker"
DEFAULT_CA_CERT="ca.pem"

###  Production standard 8.3.541 --usage
COMMAND_NAME=$(echo "${0}" | sed 's/^.*\///')   # 3.541
display_usage() {
echo -e "\n${NORMAL}${COMMAND_NAME}\n   print start and end dates of ${DEFAULT_CERT_DIR}/${DEFAULT_CA_CERT}"
echo -e "\n${BOLD}USAGE${NORMAL}"
echo    "   ${YELLOW}Positional Arguments${NORMAL}"
echo    "   ${COMMAND_NAME} [<CERT_DIR>]"
echo -e "   ${COMMAND_NAME}  <CERT_DIR> [<CA_CERT>]\n"
echo    "   ${COMMAND_NAME} [--help | -help | help | -h | h | -?]"
echo    "   ${COMMAND_NAME} [--usage | -usage | -u]"
echo    "   ${COMMAND_NAME} [--version | -version | -v]"
}

###  Production standard 0.3.214 --help
display_help() {
display_usage
#    Displaying help DESCRIPTION in English en_US.UTF-8
echo -e "\n${BOLD}DESCRIPTION${NORMAL}"
echo    "Print start and end dates of a Docker CA in <CERT_DIR> (default:"
echo    "${DEFAULT_CERT_DIR})."
echo -e "\nAn administrator may receive password and/or passphrase prompts from a"
echo    "remote systen; running the following may stop the prompts in your cluster."
echo -e "\t${BOLD}ssh-copy-id <TLS_USER>@<REMOTE_HOST>${NORMAL}"
echo    "or"
echo -e "\t${BOLD}ssh-copy-id <TLS_USER>@<192.168.x.x>${NORMAL}"
echo    "If that does not resolve the prompting challenge then review the man pages for"
echo    "ssh-agent and ssh-add before entering the following in a terminal window."
echo -e "\t${BOLD}eval \$(ssh-agent)${NORMAL}"
echo -e "\t${BOLD}ssh-add${NORMAL}"

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
echo    "   DEBUG           (default off '0')"
echo    "   CERT_DIR        Certification directory (default '${DEFAULT_CERT_DIR}')"
echo    "   CA_CERT         Name of CA certificate (default '${DEFAULT_CA_CERT}')"

echo -e "\n${BOLD}OPTIONS${NORMAL}"
echo -e "Order of precedence: CLI options, environment variable, default code.\n"
echo    "   CERT_DIR        Certification directory (default '${DEFAULT_CERT_DIR}')"
echo    "   CA_CERT         Name of CA certificate (default '${DEFAULT_CA_CERT}')"

###  Production standard 6.3.547  Architecture tree
echo -e "\n${BOLD}ARCHITECTURE TREE${NORMAL}"  # STORAGE & CERTIFICATION
echo    "<USER_HOME>/                               <-- Location of user home directory"
echo    "└── <USER-1>/.docker/                      <-- User docker cert directory"
echo -e "    └── ca.pem                             <-- User tlscacert or symbolic link\n"
echo    "/etc/ "
echo    "└── docker/ "
echo    "    └── certs.d/                           <-- Host docker cert directory"
echo    "        ├── daemon/                        <-- Daemon cert directory"
echo    "        │   └── ca.pem                     <-- CA Cert"                            # 3.542
echo    "        └── <REGISTRY_HOST>:<REGISTRY_PORT>/ < Registry cert directory"
echo    "            └── ca.crt                     <-- Daemon registry domain cert"

echo -e "\n${BOLD}DOCUMENTATION${NORMAL}"
echo    "   https://github.com/BradleyA/docker-security-infrastructure/blob/master/docker-TLS/README.md"

echo -e "\n${BOLD}EXAMPLES${NORMAL}"
echo    "   User checking start and end dates of their Docker CA in \$HOME/.docker."
echo -e "\t${BOLD}${COMMAND_NAME}${NORMAL}\n"
echo    "   User checking start and end dates of their Docker CA in ."
echo -e "\t${BOLD}cd ~/.docker ; ${COMMAND_NAME} . ca.pem${NORMAL}\n"
echo    "   To loop through a list of hosts in a cluster a user could use,"
echo    "(https://github.com/BradleyA/Linux-admin/tree/master/cluster-command)"
echo -e "\t${BOLD}cluster-command.sh special '${COMMAND_NAME}'${NORMAL}\n"
echo    "   Administrator checking start and end dates of other certificates by using:"
echo -e "\t${BOLD}sudo ${COMMAND_NAME} ~sam/.docker ca.pem${NORMAL}\n"
echo    "   To loop through a list of hosts in a cluster an administrator could check the"
echo    "   start and end dates of Docker CA for user sam in /home/sam/.docker."
echo -e "\t${BOLD}cluster-command.sh special 'sudo ${COMMAND_NAME} /home/sam/.docker ca.pem'${NORMAL}\n"
echo    "   Administrator checking a Docker daemon CA by including sudo.  To use"
echo    "   ${COMMAND_NAME} on a remote hosts (one-rpi3b.cptx86.com) with ssh port"
echo    "   of 12323 as uadmin user;"
echo -e "\t${BOLD}ssh -tp 12323 uadmin@one-rpi3b.cptx86.com 'sudo ${COMMAND_NAME} /etc/docker/certs.d/daemon ca.pem'${NORMAL}\n"
echo -e "   Administrator checking a Docker private registry CA by including sudo.  To"
echo    "   use ${COMMAND_NAME} on a remote hosts (two-rpi3b.cptx86.com) with"
echo    "   default ssh port as uadmin user;"
echo -e "\t${BOLD}ssh -t uadmin@two-rpi3b.cptx86.com 'sudo ${COMMAND_NAME} /etc/docker/certs.d/two.cptx86.com:17315 ca.crt'${NORMAL}\n"

echo -e "\n${BOLD}SEE ALSO${NORMAL}"                                                          # 3.550
echo    "   cluster-command.sh (https://github.com/BradleyA/Linux-admin/tree/master/cluster-command)"  # 3.550

echo -e "\n${BOLD}AUTHOR${NORMAL}"                                                            # 3.550
echo    "   ${COMMAND_NAME} was written by Bradley Allen <allen.bradley@ymail.com>"           # 3.550

echo -e "\n${BOLD}REPORTING BUGS${NORMAL}"                                                    # 3.550
echo    "   Report ${COMMAND_NAME} bugs https://github.com/BradleyA/docker-security-infrastructure/issues/new"  # 3.550

###  Production standard 5.3.550 Copyright                                                    # 3.550
echo -e "\n${BOLD}COPYRIGHT${NORMAL}"                                                         # 3.550
echo    "   Copyright (c) 2020 Bradley Allen"                                                 # 3.550
echo    "   MIT License https://github.com/BradleyA/docker-security-infrastructure/blob/master/LICENSE"  # 3.550

#    echo -e "\n${BOLD}HISTORY${NORMAL}"                                                           # 3.550
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
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  Variable... CERT_DIR >${CERT_DIR}< CA_CERT >${CA_CERT}<" 1>&2 ; fi

###  Production standard 7.0 Default variable value
#    Order of precedence: CLI argument, environment variable, default code
if [[ $# -ge  1 ]]  ; then CERT_DIR=${1} ; elif [[ "${CERT_DIR}" == "" ]] ; then CERT_DIR=${DEFAULT_CERT_DIR} ; fi
if [[ $# -ge  2 ]]  ; then CA_CERT=${2}  ; elif [[ "${CA_CERT}" == "" ]]  ; then CA_CERT=${DEFAULT_CA_CERT}   ; fi
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  Variable... CERT_DIR >${CERT_DIR}< CA_CERT >${CA_CERT}<" 1>&2 ; fi

#
if [[ -s "${CERT_DIR}/${CA_CERT}" ]] ; then
  #  Get certificate start and expiration date of ${CA_CERT} file
  CA_CERT_START_DATE=$(openssl x509 -in "${CERT_DIR}/${CA_CERT}" -noout -startdate | cut -d '=' -f 2)
  CA_CERT_START_DATE=$(date -d"${CA_CERT_START_DATE}" +%Y-%m-%dT%H:%M:%S-%Z)
  CA_CERT_EXPIRE_DATE=$(openssl x509 -in "${CERT_DIR}/${CA_CERT}" -noout -enddate | cut -d '=' -f 2)
  CA_CERT_EXPIRE_DATE=$(date -d"${CA_CERT_EXPIRE_DATE}" +%Y-%m-%dT%H:%M:%S-%Z)
  DAYS_VALID=$(echo "( $(date -d ${CA_CERT_EXPIRE_DATE} +%s) - $(date -d ${CA_CERT_START_DATE} +%s)) / (24*3600)" | bc)
#    Help hint
  echo -e "\n\tDocker CA, ${YELLOW}${CERT_DIR}/${CA_CERT}${WHITE}, is valid for ${BOLD}${YELLOW}${DAYS_VALID} days${NORMAL}"
  echo -e "\tfrom ${BOLD}${YELLOW}${CA_CERT_START_DATE}${NORMAL} to ${BOLD}${YELLOW}${CA_CERT_EXPIRE_DATE}${NORMAL}."
  echo -e "\n\tOther ${CA_CERT} files in directory ${CERT_DIR} are listed below:${CYAN}${BOLD}"
  cd "${CERT_DIR}"
  ls -1 "${CA_CERT}"* | sed 's/^/        /' 
  echo -e "${NORMAL}"
else
#    Help hint
  echo "Cannot access ${BOLD}${YELLOW}${CERT_DIR}/${CA_CERT}${NORMAL}: Permission denied or No such file or directory"
fi

#
new_message "${LINENO}" "${YELLOW}INFO${WHITE}" "  Operation finished..." 1>&2
###
