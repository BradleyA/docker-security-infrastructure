#!/bin/bash
# 	docker-TLS/copy-user-2-remote-host-tls.sh  3.452.948  2019-10-12T19:26:58.916776-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.451-2-g6faccee  
# 	   close #64   docker-TLS/copy-user-2-remote-host-tls.sh  - upgrade Production standard 
# 	docker-TLS/copy-user-2-remote-host-tls.sh  3.281.748  2019-06-10T16:46:36.797714-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.280  
# 	   trying to reproduce docker-TLS/check-{host,user}-tls.sh - which one should check if the ca.pem match #49 
#86# docker-TLS/copy-user-2-remote-host-tls.sh - Copy user TLS public, private keys & CA to remote host
###  Production standard 3.0 shellcheck
###  Production standard 5.1.160 Copyright
#    Copyright (c) 2019 Bradley Allen
#    MIT License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
###  Production standard 1.3.516 DEBUG variable
#    Order of precedence: environment variable, default code
if [[ "${DEBUG}" == ""  ]] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
if [[ "${DEBUG}" == "2" ]] ; then set -x    ; fi   # Print trace of simple commands before they are executed
if [[ "${DEBUG}" == "3" ]] ; then set -v    ; fi   # Print shell input lines as they are read
if [[ "${DEBUG}" == "4" ]] ; then set -e    ; fi   # Exit immediately if non-zero exit status
#
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
YELLOW=$(tput setaf 3)

###  Production standard 7.0 Default variable value
DEFAULT_REMOTE_HOST="$(hostname -f)"    # local host
DEFAULT_TLS_USER="${USER}"
DEFAULT_WORKING_DIRECTORY=~/.docker/docker-ca

###  Production standard 8.3.214 --usage
display_usage() {
COMMAND_NAME=$(echo "${0}" | sed 's/^.*\///')
echo -e "\n${NORMAL}${COMMAND_NAME}\n   Copy user TLS public, private keys & CA to remote host"
echo -e "\n${BOLD}USAGE${NORMAL}"
echo    "   ${COMMAND_NAME} [<TLS_USER>]"
echo    "   ${COMMAND_NAME}  <TLS_USER> [<REMOTE_HOST>]"
echo -e "   ${COMMAND_NAME}  <TLS_USER>  <REMOTE_HOST> [<WORKING_DIRECTORY>]\n"
echo    "   ${COMMAND_NAME} [--help | -help | help | -h | h | -?]"
echo    "   ${COMMAND_NAME} [--usage | -usage | -u]"
echo    "   ${COMMAND_NAME} [--version | -version | -v]"
}

###  Production standard 0.3.214 --help
display_help() {
display_usage
#    Displaying help DESCRIPTION in English en_US.UTF-8
echo -e "\n${BOLD}DESCRIPTION${NORMAL}"
echo    "A user with administration authority uses this script to copy user TLS CA,"
echo    "public, and private keys from <WORKING_DIRECTORY> directory on this system to"
echo    "<TLS_USER>/.docker on <REMOTE_HOST> system."
echo -e "\nTo copy to this system, do not enter a <REMOTE_HOST> on the command line and"
echo    "and this system will be used."
echo -e "\nThe administration user may receive password and/or passphrase prompts from a"
echo    "remote systen; running the following may stop the prompts in your cluster."
echo -e "\t${BOLD}ssh-copy-id <TLS_USER>@<REMOTE_HOST>${NORMAL}"
echo    "or"
echo -e "\t${BOLD}ssh-copy-id <TLS_USER>@<x.x.x.x>${NORMAL}"

###  Production standard 1.3.516 DEBUG variable
echo -e "\nThe DEBUG environment variable can be set to '', '0', '1', '2', '3', or '4'."
echo    "The setting '' or '0' will turn off all DEBUG messages during execution of this"
echo    "script.  The setting '1' will print all DEBUG messages during execution of this"
echo    "script.  The setting '2' (set -x) will print a trace of simple commands before"
echo    "they are executed in this script.  The setting '3' (set -v) will print shell"
echo    "input lines as they are read.  The setting '4' (set -e) will exit immediately"
echo    "if non-zero exit status is recieved with some exceptions.  For more information"
echo    "about any of the set options, see man bash."

###  Production standard 4.0 Documentation Language
#    Displaying help DESCRIPTION in French fr_CA.UTF-8, fr_FR.UTF-8, fr_CH.UTF-8
if [[ "${LANG}" == "fr_CA.UTF-8" ]] || [[ "${LANG}" == "fr_FR.UTF-8" ]] || [[ "${LANG}" == "fr_CH.UTF-8" ]] ; then
  echo -e "\n--> ${LANG}"
  echo    "<votre aide va ici>" # your help goes here
  echo    "Souhaitez-vous traduire la section description?" # Do you want to translate the description section?
elif ! [[ "${LANG}" == "en_US.UTF-8" ]] ; then
  new_message "${SCRIPT_NAME}" "${LINENO}" "INFO" "  Your language, ${LANG}, is not supported.  Would you like to translate the description section?" 1>&2
fi

echo -e "\n${BOLD}ENVIRONMENT VARIABLES${NORMAL}"
echo    "If using the bash shell, enter; 'export DEBUG=1' on the command line to set"
echo    "the environment variable DEBUG to '1' (0 = debug off, 1 = debug on).  Use the"
echo    "command, 'unset DEBUG' to remove the exported information from the environment"
echo    "variable DEBUG.  You are on your own defining environment variables if"
echo    "you are using other shells."
echo    "   DEBUG             (default off '0')"
echo    "   WORKING_DIRECTORY Absolute path for working directory"
echo    "                     (default ${DEFAULT_WORKING_DIRECTORY})"

echo -e "\n${BOLD}OPTIONS${NORMAL}"
echo    "   TLS_USER          User requiring new TLS keys on remote host"
echo    "                     (default ${DEFAULT_TLS_USER})"
echo    "   REMOTE_HOST       Remote host to copy certificates to"
echo    "                     (default ${DEFAULT_REMOTE_HOST})"
echo    "   WORKING_DIRECTORY Absolute path for working directory"
echo    "                     (default ${DEFAULT_WORKING_DIRECTORY})"

###  Production standard 6.1.177 Architecture tree
echo -e "\n${BOLD}ARCHITECTURE TREE${NORMAL}"  # STORAGE & CERTIFICATION
echo    "<USER_HOME>/                               <-- Location of user home directory"
echo    "└── <USER-1>/.docker/                      <-- User docker cert directory"
echo    "    ├── ca.pem                             <-- User tlscacert or symbolic link"
echo    "    ├── cert.pem                           <-- Symbolic link to user tlscert"
echo    "    ├── key.pem                            <-- Symbolic link to user tlskey"
echo    "    └── docker-ca/                         <-- Working directory to create certs"
# >>>   FUTURE  open ticket on github
# >>>   FUTURE  echo    "/usr/local/data/                           <-- <DATA_DIR>"
# >>>   FUTURE  echo    "└── <CLUSTER>/                             <-- <CLUSTER>"
# >>>   FUTURE  echo    "    └── docker-accounts/                   <-- Docker TLS certs"
# >>>   FUTURE  echo    "        ├── <HOST-1>/                      <-- Host in cluster"
# >>>   FUTURE  echo    "        │   ├── <USER-1>/                  <-- User TLS certs directory"
# >>>   FUTURE  echo    "        │   │   ├── ca.pem       FUTURE    <-- User tlscacert"
# >>>   FUTURE  echo    "        │   │   ├── cert.pem     FUTURE    <-- User tlscert"
# >>>   FUTURE  echo    "        │   │   └── key.pem      FUTURE    <-- User tlskey"
# >>>   FUTURE  echo    "        │   └── <USER-2>/                  <-- User TLS certs directory"
# >>>   FUTURE  echo    "        └── <HOST-2>/                      <-- Host in cluster"

echo -e "\n${BOLD}DOCUMENTATION${NORMAL}"
echo    "   https://github.com/BradleyA/docker-security-infrastructure/blob/master/docker-TLS/README.md"

echo -e "\n${BOLD}EXAMPLES${NORMAL}"
echo    "   Administrator copies TLS keys and CA from /usr/local/north-office/certs"
echo    "   local working directory to remote host, two.cptx86.com, for user bob"
echo -e "\t${BOLD}${0} bob two.cptx86.com /usr/local/north-office/certs${NORMAL}"
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

#    UID and GID
USER_ID=$(id -u)
GROUP_ID=$(id -g)

###  Production standard 2.3.512 log format (WHEN WHERE WHAT Version Line WHO UID:GID [TYPE] Message)
new_message() {  #  $1="${SCRIPT_NAME}"  $2="${LINENO}"  $3="DEBUG INFO ERROR WARN"  $4="message"
  get_date_stamp
  echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${1}[$$] ${SCRIPT_VERSION} ${2} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[${3}]${NORMAL}  ${4}"
}

#    INFO
new_message "${SCRIPT_NAME}" "${LINENO}" "INFO" "  Started..." 1>&2

#    Added following code because USER is not defined in crobtab jobs
if ! [[ "${USER}" == "${LOGNAME}" ]] ; then  USER=${LOGNAME} ; fi
if [[ "${DEBUG}" == "1" ]] ; then new_message "${SCRIPT_NAME}" "${LINENO}" "DEBUG" "  Setting USER to support crobtab...  USER >${USER}<  LOGNAME >${LOGNAME}<" 1>&2 ; fi

#    DEBUG
if [[ "${DEBUG}" == "1" ]] ; then new_message "${SCRIPT_NAME}" "${LINENO}" "DEBUG" "  Name_of_command >${SCRIPT_NAME}< Name_of_arg1 >${1}< Name_of_arg2 >${2}< Name_of_arg3 >${3}<  Version of bash ${BASH_VERSION}" 1>&2 ; fi

###  Production standard 9.3.513 Parse CLI options and arguments
while [[ "${#}" -gt 0 ]] ; do
  case "${1}" in
    --help|-help|help|-h|h|-\?)  display_help | more ; exit 0 ;;
    --usage|-usage|usage|-u)  display_usage ; exit 0  ;;
    --version|-version|version|-v)  echo "${SCRIPT_NAME} ${SCRIPT_VERSION}" ; exit 0  ;;
    *)  new_message "${SCRIPT_NAME}" "${LINENO}" "ERROR" "  Option, ${BOLD}${YELLOW}${1}${NORMAL}, entered on the command line is not supported." 1>&2 ; display_usage ; exit 1 ; ;;
  esac
done

###

TLS_USER=${1:-${DEFAULT_TLS_USER}}
REMOTE_HOST=${2:-${DEFAULT_REMOTE_HOST}}
#    Order of precedence: CLI argument, environment variable, default code
if [[ $# -ge  3 ]]  ; then WORKING_DIRECTORY=${3} ; elif [[ "${WORKING_DIRECTORY}" == "" ]] ; then WORKING_DIRECTORY="${DEFAULT_WORKING_DIRECTORY}" ; fi
if [[ "${DEBUG}" == "1" ]] ; then new_message "${SCRIPT_NAME}" "${LINENO}" "DEBUG" "  TLS_USER >${TLS_USER}< REMOTE_HOST >${REMOTE_HOST}< WORKING_DIRECTORY >${WORKING_DIRECTORY}<" 1>&2 ; fi

#    Check if ${WORKING_DIRECTORY} directory on system
if [[ ! -d "${WORKING_DIRECTORY}" ]] ; then
  display_help | more
  new_message "${SCRIPT_NAME}" "${LINENO}" "ERROR" "  Default directory, ${BOLD}${WORKING_DIRECTORY}${NORMAL}, not on system." 1>&2
#    Help hint
  echo -e "\n\tRunning create-site-private-public-tls.sh will create directories"
  echo -e "\tand site private and public keys.  Then run sudo"
  echo -e "\tcreate-new-openssl.cnf-tls.sh to modify openssl.cnf file."
  echo -e "\t${BOLD}See DOCUMENTATION link in '${0} --help' for more information.${NORMAL}"
  exit 1
fi

#    Check if ${TLS_USER}-user-priv-key.pem file on system
if ! [[ -e "${WORKING_DIRECTORY}/${TLS_USER}-user-priv-key.pem" ]] ; then
  new_message "${SCRIPT_NAME}" "${LINENO}" "ERROR" "  The ${TLS_USER}-user-priv-key.pem file was not found in ${WORKING_DIRECTORY}" 1>&2
#    Help hint
  echo -e "\n\tRunning ${BOLD}create-user-tls.sh${NORMAL} will create public and private keys."
  exit 1
fi

cd "${WORKING_DIRECTORY}"
#    Check if ${REMOTE_HOST} is available on ssh port
echo -e "\n\t${BOLD}${USER}${NORMAL} user may receive password and passphrase prompts"
echo -e "\tfrom ${REMOTE_HOST}.  Running"
echo -e "\t${BOLD}ssh-copy-id ${USER}@${REMOTE_HOST}${NORMAL}"
echo -e "\tmay stop some of the prompts.\n"
if $(ssh "${REMOTE_HOST}" 'exit' >/dev/null 2>&1 ) ; then
  ssh -t ${REMOTE_HOST} " cd ~${TLS_USER} " || { new_message "${SCRIPT_NAME}" "${LINENO}" "ERROR" "  ${TLS_USER} user does not have home directory on ${REMOTE_HOST}"  ; exit 1; }
  echo -e "\tCreate directory, change file permissions, and copy TLS keys to ${TLS_USER}@${REMOTE_HOST}." 1>&2
  mkdir -p "${TLS_USER}/.docker"
  chmod 0755 "${TLS_USER}"
  chmod 0700 "${TLS_USER}/.docker"
  cp -p ca.pem "${TLS_USER}/.docker"
  cp -p "${TLS_USER}-user-cert.pem"  "${TLS_USER}/.docker"
  cp -p "${TLS_USER}-user-priv-key.pem"  "${TLS_USER}/.docker"
  FILE_DATE_STAMP=$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)
  cd "${TLS_USER}/.docker"
  ln -s "${TLS_USER}-user-cert.pem"  cert.pem
  ln -s "${TLS_USER}-user-priv-key.pem"  key.pem
  cd ..
  tar -pcf "./${TLS_USER}-${REMOTE_HOST}-${FILE_DATE_STAMP}.tar" .docker
  echo -e "\tTransfer TLS keys to ${TLS_USER}@${REMOTE_HOST}." 1>&2
  scp -p "./${TLS_USER}-${REMOTE_HOST}-${FILE_DATE_STAMP}.tar" ${REMOTE_HOST}:/tmp

#    Check if ${TLS_USER} == ${USER} because sudo is not required for user copying their certs
  if [[ "${TLS_USER}" == "${USER}" ]] ; then
    ssh -t ${REMOTE_HOST} " cd ~${TLS_USER} ; tar -xf /tmp/${TLS_USER}-${REMOTE_HOST}-${FILE_DATE_STAMP}.tar ; rm /tmp/${TLS_USER}-${REMOTE_HOST}-${FILE_DATE_STAMP}.tar ; chown -R ${TLS_USER}.${TLS_USER} .docker "
  else
    new_message "${SCRIPT_NAME}" "${LINENO}" "INFO" "  ${USER}, sudo password is required to install other user, ${TLS_USER}, certs on host, ${REMOTE_HOST}." 1>&2
    ssh -t ${REMOTE_HOST} "cd ~${TLS_USER}/.. ; sudo tar -pxf /tmp/${TLS_USER}-${REMOTE_HOST}-${FILE_DATE_STAMP}.tar -C ${TLS_USER} ; sudo rm /tmp/${TLS_USER}-${REMOTE_HOST}-${FILE_DATE_STAMP}.tar ; sudo chown -R ${TLS_USER}.${TLS_USER} ${TLS_USER}/.docker "
  fi
  cd ..
  rm -rf "${TLS_USER}"

#    Display instructions about cert environment variables
#    Help hint
  echo -e "\nTo set environment variables permanently, add them to the user's"
  echo -e "\t.bashrc.  These environment variables will be set each time the user"
  echo -e "\tlogs into the computer system.  Edit your .bashrc file (or the"
  echo -e "\tcorrect shell if different) and prepend the following two lines."
  echo -e "\texport DOCKER_HOST=tcp://$(hostname -f):2376"
  echo -e "\texport DOCKER_TLS_VERIFY=1"
#
  new_message "${SCRIPT_NAME}" "${LINENO}" "INFO" "  Operation finished..." 1>&2
  exit 0
else
  display_help | more
  new_message "${SCRIPT_NAME}" "${LINENO}" "ERROR" "  ${REMOTE_HOST} not responding on ssh port." 1>&2
  exit 1
fi

#
new_message "${SCRIPT_NAME}" "${LINENO}" "INFO" "  Operation finished....." 1>&2
###
