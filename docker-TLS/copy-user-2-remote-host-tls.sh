#!/bin/bash
# 	docker-TLS/copy-user-2-remote-host-tls.sh  3.557.1131  2019-12-22T18:16:53.567416-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.556-1-ga963163  
# 	   docker-TLS/copy-user-2-remote-host-tls.sh   Production standard 5.3.550 Copyright  Production standard 0.3.550 --help  Production standard 4.3.550 Documentation Language  Production standard 1.3.550 DEBUG variable 
# 	docker-TLS/copy-user-2-remote-host-tls.sh  3.535.1095  2019-12-10T00:03:37.856236-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.534  
# 	   docker-TLS/copy-user-2-remote-host-tls.sh   Production standard 6.3.547  Architecture tree 
# 	docker-TLS/copy-user-2-remote-host-tls.sh  3.481.1005  2019-10-23T21:49:25.037778-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.480  
# 	   docker-TLS/copy-user-2-remote-host-tls.sh   needs MORE testing before fixing rm -rf incident on ZERO 
# 	docker-TLS/copy-user-2-remote-host-tls.sh  3.480.1004  2019-10-23T14:25:07.419786-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.479-1-g5ac129d  
# 	   docker-TLS/copy-user-2-remote-host-tls.sh   update code for #5 localhost does not use scp & ssh 
# 	docker-TLS/copy-user-2-remote-host-tls.sh  3.281.748  2019-06-10T16:46:36.797714-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.280  
# 	   trying to reproduce docker-TLS/check-{host,user}-tls.sh - which one should check if the ca.pem match #49 
#86# docker-TLS/copy-user-2-remote-host-tls.sh - Copy user TLS public, private keys & CA to remote host
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
WHITE=$(tput  setaf 7)

###  Production standard 7.0 Default variable value
DEFAULT_REMOTE_HOST="$(hostname -f)"    # local host
DEFAULT_TLS_USER="${USER}"
DEFAULT_WORKING_DIRECTORY=~/.docker/docker-ca

###  Production standard 8.3.541 --usage
COMMAND_NAME=$(echo "${0}" | sed 's/^.*\///')   # 3.541
display_usage() {
echo -e "\n${NORMAL}${COMMAND_NAME}\n   Copy user TLS public, private keys & CA to remote host"
echo -e "\n${BOLD}USAGE${NORMAL}"
echo    "   ${YELLOW}Positional Arguments${NORMAL}"
echo    "   ${COMMAND_NAME} [<TLS_USER>]"
echo    "   ${COMMAND_NAME}  <TLS_USER> [<REMOTE_HOST>]"
echo -e "   ${COMMAND_NAME}  <TLS_USER>  <REMOTE_HOST> [<WORKING_DIRECTORY>]\n"
echo    "   ${COMMAND_NAME} [--help | -help | help | -h | h | -?]"
echo    "   ${COMMAND_NAME} [--usage | -usage | -u]"
echo    "   ${COMMAND_NAME} [--version | -version | -v]"
}

###  Production standard 0.3.550 --help                                                     # 3.550
display_help() {
display_usage
#    Displaying help DESCRIPTION in English en_US.UTF-8, en.UTF-8, C.UTF-8                  # 3.550
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

echo    "   WORKING_DIRECTORY Absolute path for working directory"
echo    "                     (default ${DEFAULT_WORKING_DIRECTORY})"

echo -e "\n${BOLD}OPTIONS${NORMAL}"
echo -e "Order of precedence: CLI options, environment variable, default code.\n"
echo    "   TLS_USER          User requiring new TLS keys on remote host"
echo    "                     (default ${DEFAULT_TLS_USER})"
echo    "   REMOTE_HOST       Remote host to copy certificates to"
echo    "                     (default ${DEFAULT_REMOTE_HOST})"
echo    "   WORKING_DIRECTORY Absolute path for working directory"
echo    "                     (default ${DEFAULT_WORKING_DIRECTORY})"

###  Production standard 6.3.547  Architecture tree
echo -e "\n${BOLD}ARCHITECTURE TREE${NORMAL}"  # STORAGE & CERTIFICATION
echo    "<USER_HOME>/                               <-- Location of user home directory"
echo    "└── <USER-1>/.docker/                      <-- User docker cert directory"
echo    "    ├── ca.pem                             <-- User tlscacert or symbolic link"
echo    "    ├── cert.pem                           <-- Symbolic link to user tlscert"
echo    "    ├── key.pem                            <-- Symbolic link to user tlskey"
echo    "    └── docker-ca/                         <-- Working directory to create certs"
echo    "        └── users/                         <-- Directory for users"                # 3.539
echo    "            └── <USER>/                    <-- Directory to store user certs"      # 3.539
echo    "               ├── ca.pem                  <-- CA Cert"                            # 3.544
echo    "               ├── user-cert.pem           <-- public key"                         # 3.546
echo -e "               └── user-priv-key.pem       <-- private key\n"                      # 3.546
# >>>   FUTURE  open ticket on github
echo    "/usr/local/data/                           <-- <DATA_DIR>"
echo    "└── <CLUSTER>/                             <-- <CLUSTER>"
echo    "    └── docker-accounts/                   <-- Docker TLS certs"
echo    "        ├── <HOST-1>/                      <-- Host in cluster"
echo    "        │   ├── <USER-1>/                  <-- User TLS certs directory"
echo    "        │   │   └── docker         FUTURE  <-- User tlscacert"
echo    "        │   │       ├── ca.pem     FUTURE  <-- User tlscacert"
echo    "        │   │       ├── cert.pem   FUTURE  <-- User tlscert"
echo    "        │   │       └── key.pem    FUTURE  <-- User tlskey"
echo    "        │   └── <USER-2>/                  <-- User TLS certs directory"
echo    "        └── <HOST-2>/                      <-- Host in cluster"

echo -e "\n${BOLD}DOCUMENTATION${NORMAL}"
echo    "   https://github.com/BradleyA/docker-security-infrastructure/blob/master/docker-TLS/README.md"

echo -e "\n${BOLD}EXAMPLES${NORMAL}"
echo    "   Administrator copies TLS keys and CA from /usr/local/north-office/certs"
echo    "   local working directory to remote host, two.cptx86.com, for user bob"
echo -e "\t${BOLD}${COMMAND_NAME} bob two.cptx86.com /usr/local/north-office/certs${NORMAL}\n" # 3.550

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

###

TLS_USER=${1:-${DEFAULT_TLS_USER}}
REMOTE_HOST=${2:-${DEFAULT_REMOTE_HOST}}
#    Order of precedence: CLI argument, environment variable, default code
if [[ $# -ge  3 ]]  ; then WORKING_DIRECTORY=${3} ; elif [[ "${WORKING_DIRECTORY}" == "" ]] ; then WORKING_DIRECTORY="${DEFAULT_WORKING_DIRECTORY}" ; fi
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  TLS_USER >${TLS_USER}< REMOTE_HOST >${REMOTE_HOST}< WORKING_DIRECTORY >${WORKING_DIRECTORY}<" 1>&2 ; fi

#    Check if ${WORKING_DIRECTORY} directory on system
if [[ ! -d "${WORKING_DIRECTORY}" ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Default directory, ${BOLD}${WORKING_DIRECTORY}${NORMAL}, not on system." 1>&2
#    Help hint
  echo -e "\n\tRunning ${BOLD}${YELLOW}create-site-private-public-tls.sh${NORMAL} will create directories"
  echo -e "\tand site private and public keys.  Then run sudo"
  echo -e "\t${BOLD}${YELLOW}create-new-openssl.cnf-tls.sh${NORMAL} to modify openssl.cnf file."
  echo -e "\t${BOLD}See DOCUMENTATION link in '${COMMAND_NAME} --help' for more information.${NORMAL}"
  exit 1
fi

#    Check if ${CA_CERT} file on system
if ! [[ -e "${WORKING_DIRECTORY}/users/${TLS_USER}/${CA_CERT}" ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Site public key ${WORKING_DIRECTORY}/users/${TLS_USER}/${CA_CERT}\n  is not in this location.\n  Enter ${COMMAND_NAME} --help for more information." 1>&2
#    Help hint
  echo -e "\n\tEither link ${CA_CERT} to a file in site directory"
  echo -e "\t${WORKING_DIRECTORY}/site/"
  echo -e "\tor run ${YELLOW}create-site-private-public-tls.sh${WHITE} and sudo"
  echo -e "\t${YELLOW}create-new-openssl.cnf-tls.sh${WHITE} to create a new key."
  exit 1
fi

#    Check if user-priv-key.pem file on system
if ! [[ -e "${WORKING_DIRECTORY}/users/${TLS_USER}/user-priv-key.pem" ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  The ${YELLOW}user-priv-key.pem${WHITE} file was not found in ${WORKING_DIRECTORY}/users/${TLS_USER}/" 1>&2
#    Help hint
  echo -e "\n\tRunning ${BOLD}${YELLOW}create-user-tls.sh${NORMAL} will create public and private keys.\n\tEnter ${COMMAND_NAME} --help for more information."
  exit 1
fi

echo -e "\n\t${BOLD}${YELLOW}${USER}${NORMAL} user may receive password and passphrase prompts"
echo -e "\tfrom ${REMOTE_HOST}.  Running"
echo -e "\t  ${BOLD}${YELLOW}ssh-copy-id ${USER}@${REMOTE_HOST}${NORMAL}"
echo -e "\tmay stop some of the prompts.\n"

if [[ "${LOCALHOST}" != "${REMOTE_HOST}" ]] ; then  #  #48 Not "${LOCALHOST}"
#    Check if ${REMOTE_HOST} is available on ssh port
  if ! $(ssh "${REMOTE_HOST}" 'exit' >/dev/null 2>&1 ) ; then
    new_message "${LINENO}" "${RED}ERROR${WHITE}" "  ${REMOTE_HOST} not responding on ssh port." 1>&2
    exit 1
  fi
fi

#    Create working directory ${WORKING_DIRECTORY}/users/${TLS_USER}/${TLS_USER}
cd "${WORKING_DIRECTORY}/users/${TLS_USER}"
mkdir -p "${TLS_USER}"
cd       "${TLS_USER}"

#    Check if ${WORKING_DIRECTORY}/users/${TLS_USER}/${TLS_USER}/.docker directory on system from a previous backup
if [[ -d ".docker" ]] ; then
  rm -rf .docker
fi

#    Backup ${REMOTE_HOST}:${CERT_DAEMON_DIR}/.. to support rollback
FILE_DATE_STAMP=$(date +%Y-%m-%dT%H.%M.%S.%2N-%Z)
echo -e "\n\tBacking up ${REMOTE_HOST}:~${TLS_USER}/.docker"
echo -e "\tto $(pwd)\n\t${BOLD}${YELLOW}Root access required.${NORMAL}\n"
if [[ "${LOCALHOST}" != "${REMOTE_HOST}" ]] ; then  #  #48 Not "${LOCALHOST}"
  if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  ${LOCALHOST} does NOT equal ${REMOTE_HOST}" 1>&2 ; fi
  ssh -t "${REMOTE_HOST}" "sudo -u ${TLS_USER}  mkdir -p ~${TLS_USER}/.docker ; cd ~${TLS_USER} ; sudo tar -pcf /tmp/${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.backup.tar --exclude=.docker/docker-ca .docker ; sudo chown ${USER}.${USER} /tmp/${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.backup.tar ; chmod 0400 /tmp/${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.backup.tar"
  scp -p "${REMOTE_HOST}:/tmp/${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.backup.tar" .
  ssh -t "${REMOTE_HOST}"  rm -f "/tmp/${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.backup.tar"
else
#    Check if ${TLS_USER} == ${USER} because sudo is not required for user copying their certs
  if [[ "${TLS_USER}" == "${USER}" ]] ; then
    if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  ${LOCALHOST} does equal ${REMOTE_HOST}  and  ${TLS_USER} does equal ${USER}" 1>&2 ; fi
    #    Backup ${TLS_USER}/.docker to support rollback
    cd 
    tar -pcf "/tmp/${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.backup.tar" --exclude=.docker/docker-ca .docker
    cd  "${WORKING_DIRECTORY}/users/${TLS_USER}/${TLS_USER}"
    cp -p      "/tmp/${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.backup.tar"  .
    rm -f      "/tmp/${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.backup.tar"
    chmod 0400 "./${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.backup.tar"
  else
    if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  ${LOCALHOST} does equal ${REMOTE_HOST}  and  ${TLS_USER} does NOT equal ${USER}" 1>&2 ; fi
    #    Backup ${TLS_USER}/.docker to support rollback
    TLS_USER_HOME=$(eval echo "~${TLS_USER}")
    cd "${TLS_USER_HOME}"
    sudo -u "${TLS_USER}"  mkdir -p   "${TLS_USER_HOME}"/.docker
    sudo -u "${TLS_USER}"  chmod 0700 "${TLS_USER_HOME}"/.docker
    sudo -u "${TLS_USER}"  tar -pcf "/tmp/${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.backup.tar" --exclude=.docker/docker-ca .docker
    cd  "${WORKING_DIRECTORY}/users/${TLS_USER}/${TLS_USER}"
    cp -p      "/tmp/${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.backup.tar"  .
    sudo rm -f "/tmp/${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.backup.tar"
    chmod 0400 "./${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.backup.tar"
  fi
fi

tar -pxf "${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.backup.tar"

#    Create certification tar file and install it on ${REMOTE_HOST}
TEMP_CA_PEM=$(ls -l "${WORKING_DIRECTORY}/users/${TLS_USER}/ca.pem" | sed -e 's/^.* -> //')
TEMP_USER_CERT_PEM=$(ls -l "${WORKING_DIRECTORY}/users/${TLS_USER}/user-cert.pem" | sed -e 's/^.* -> //')
TEMP_USER_PRIV_KEY_PEM=$(ls -l "${WORKING_DIRECTORY}/users/${TLS_USER}/user-priv-key.pem" | sed -e 's/^.* -> //')
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  TEMP_CA_PEM >${TEMP_CA_PEM}< TEMP_USER_CERT_PEM >${TEMP_USER_CERT_PEM}< TEMP_USER_PRIV_KEY_PEM >${TEMP_USER_PRIV_KEY_PEM}<" 1>&2 ; fi
chmod 0700 .docker
cp -pf "../${TEMP_CA_PEM}"             .docker
cp -pf "../${TEMP_USER_CERT_PEM}"      .docker
cp -pf "../${TEMP_USER_PRIV_KEY_PEM}"  .docker
cd     .docker
ln -sf "${TEMP_CA_PEM}"             ca.pem
ln -sf "${TEMP_USER_CERT_PEM}"      cert.pem
ln -sf "${TEMP_USER_PRIV_KEY_PEM}"  key.pem
rm -fR -- */
cd     ..
FILE_DATE_STAMP=$(date +%Y-%m-%dT%H.%M.%S.%2N-%Z)
tar -pcf   "./${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.new.tar" .docker
rm -rf .docker  # >>>	commented this out during development
                # >>>	  without removing the .docker work directory, there is an issue that old certs reappear after the user removed them from their ~/.docker directory thus increasing the number of old useless certs
chmod 0400 "./${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.new.tar"

#    Install certification on ${REMOTE_HOST}
if [[ "${LOCALHOST}" != "${REMOTE_HOST}" ]] ; then  #  #5 Not "${LOCALHOST}"
  if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  ${LOCALHOST} does NOT equal ${REMOTE_HOST}" 1>&2 ; fi
#    Check if ${REMOTE_HOST} is available on ssh port
  if $(ssh "${REMOTE_HOST}" 'exit' >/dev/null 2>&1 ) ; then
    ssh -t "${REMOTE_HOST}" "cd ~${TLS_USER}" || { new_message "${LINENO}" "${RED}ERROR${WHITE}" "  ${TLS_USER} user does not have home directory on ${REMOTE_HOST}"  ; exit 1; }
    echo -e "\tTransfer TLS keys to ${TLS_USER}@${REMOTE_HOST}." 1>&2
    scp -p "./${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.new.tar" "${REMOTE_HOST}:/tmp"

#    Check if ${TLS_USER} == ${USER} because sudo is not required for user copying their certs
    if [[ "${TLS_USER}" == "${USER}" ]] ; then
      if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  ${TLS_USER} does equal ${USER}" 1>&2 ; fi
      ssh -t "${REMOTE_HOST}" "cd ; tar -pxf /tmp/${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.new.tar ; rm -f /tmp/${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.new.tar ; chown -fR ${TLS_USER}.${TLS_USER} .docker"
    else
      if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  ${TLS_USER} does NOT equal ${USER}" 1>&2 ; fi
      echo -e "\n\tInstalling TLS keys in ${REMOTE_HOST}:~${TLS_USER}/.docker"
      echo -e "\t${BOLD}${YELLOW}Root access required.${NORMAL}\n"
      ssh -t "${REMOTE_HOST}" "cd ~${TLS_USER} ; sudo tar -pxf /tmp/${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.new.tar ; sudo rm /tmp/${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.new.tar ; sudo chown -fR ${TLS_USER}.${TLS_USER} .docker"
    fi
  else
    new_message "${LINENO}" "${RED}ERROR${WHITE}" "  ${REMOTE_HOST} not responding on ssh port." 1>&2
    exit 1
  fi
else
  if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  ${LOCALHOST} does equal ${REMOTE_HOST}" 1>&2 ; fi
  cp -p "./${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.new.tar" /tmp
  sudo chown "${TLS_USER}"."${TLS_USER}" "/tmp/${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.new.tar"

#    Check if ${TLS_USER} == ${USER} because sudo is not required for user copying their certs
  if [[ "${TLS_USER}" == "${USER}" ]] ; then
    if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  ${TLS_USER} does equal ${USER}" 1>&2 ; fi
    cd
    tar -pxf "/tmp/${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.new.tar"
  else
    if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  ${TLS_USER} does NOT equal ${USER}" 1>&2 ; fi
    new_message "${LINENO}" "${YELLOW}INFO${WHITE}" "  ${USER}, sudo password is required to install other user, ${TLS_USER}, certs on host, ${REMOTE_HOST}." 1>&2
    cd "${TLS_USER_HOME}"
    sudo -u "${TLS_USER}"  tar -pxf "/tmp/${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.new.tar"
  fi
  sudo -u "${TLS_USER}"  rm -f  "/tmp/${TLS_USER}--${REMOTE_HOST}--${FILE_DATE_STAMP}.new.tar"
fi

#    Display instructions about cert environment variables
#    Help hint
echo -e "\n\tTo set environment variables permanently, add them to the user's"
echo -e "\t.bashrc  These environment variables will be set each time the user"
echo -e "\tlogs into the computer system.  Edit your .bashrc file (or the"
echo -e "\tcorrect shell if different) and prepend the following two lines."
echo -e "\t  ${YELLOW}export DOCKER_HOST=tcp://$(hostname -f):2376"
echo -e "\t  export DOCKER_TLS_VERIFY=1${WHITE}"
echo -e "\tExample: https://github.com/BradleyA/user-files/blob/master/.bashrc"

new_message "${LINENO}" "${YELLOW}INFO${WHITE}" "  Operation finished....." 1>&2
###
