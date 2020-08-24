#!/bin/bash
# 	docker-TLS/copy-host-2-remote-host-tls.sh  4.2.8.1305  2020-08-24T15:24:08.022153-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  master  uadmin  five-rpi3b.cptx86.com 4.2.7-6-g8583a9e  
# 	   docker-TLS/copy-host-2-remote-host-tls.sh -->   added help hint to include 18.04, 20.04  
# 	docker-TLS/copy-host-2-remote-host-tls.sh  4.2.1.1273  2020-04-18T15:20:29.932587-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  master  uadmin  five-rpi3b.cptx86.com 4.2-47-g4ac099b  
# 	   docker-TLS/copy-host-2-remote-host-tls.sh   display_help description typos close #72   update to Production standard 0.3.579 --help 
# 	docker-TLS/copy-host-2-remote-host-tls.sh  4.1.1211  2019-12-30T11:34:27.128441-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.565-13-g1455a67  
# 	   docker-TLS/*   New Release 4.1 
# 	docker-TLS/copy-host-2-remote-host-tls.sh  3.555.1127  2019-12-22T17:46:04.738024-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.554-1-gb837ae5 
# 	   docker-TLS/copy-host-2-remote-host-tls.sh   Production standard 5.3.550 Copyright  Production standard 0.3.550 --help  Production standard 4.3.550 Documentation Language  Production standard 1.3.550 DEBUG variable 
# 	docker-TLS/copy-host-2-remote-host-tls.sh  3.543.1106  2019-12-13T16:20:52.247955-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.542  
# 	   Production standard 6.3.547  Architecture tree  Production standard 8.3.541 --usage 
#86# docker-TLS/copy-host-2-remote-host-tls.sh - Copy public, private keys and CA to remote host
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
DEFAULT_WORKING_DIRECTORY=~/.docker/docker-ca
DEFAULT_CA_CERT="ca.pem"
DEFAULT_CERT_DAEMON_DIR="/etc/docker/certs.d/daemon/"

###  Production standard 8.3.541 --usage
COMMAND_NAME=$(echo "${0}" | sed 's/^.*\///')   # 3.541
display_usage() {
echo -e "\n${NORMAL}${COMMAND_NAME}\n   Copy public, private keys and CA to remote host"
echo -e "\n${BOLD}USAGE${NORMAL}"
echo    "   ${YELLOW}Positional Arguments${NORMAL}"
echo    "   ${COMMAND_NAME} [<REMOTE_HOST>]"
echo    "   ${COMMAND_NAME}  <REMOTE_HOST> [<WORKING_DIRECTORY>]"
echo -e "   ${COMMAND_NAME}  <REMOTE_HOST>  <WORKING_DIRECTORY> [<CERT_DAEMON_DIR>]\n"
echo    "   ${COMMAND_NAME} [--help | -help | help | -h | h | -?]"
echo    "   ${COMMAND_NAME} [--usage | -usage | -u]"
echo    "   ${COMMAND_NAME} [--version | -version | -v]"
}

###  Production standard 0.3.579 --help                                                     # 0.3.579
display_help() {
display_usage
#    Displaying help DESCRIPTION in English en_US.UTF-8, en.UTF-8, C.UTF-8                  # 3.550
echo -e "\n${BOLD}DESCRIPTION${NORMAL}"
echo    "A user with administration authority uses this script to copy host TLS CA,"
echo    "public, and private keys from <WORKING_DIRECTORY> directory on this"
echo    "system to /etc/docker/certs.d/daemon directory on a local system or"
echo    "remote system."
echo -e "\nTo copy to this local system, do not enter a <REMOTE_HOST> on the"
echo    "command line and this local system will be used."
echo -e "\nThe administration user may receive password and/or passphrase prompts from a"
echo    "remote systen; running the following may stop the prompts."
echo -e "\t${BOLD}ssh-copy-id <USER>@<REMOTE_HOST>${NORMAL}"
echo    "or"
echo -e "\t${BOLD}ssh-copy-id <USER>@<x.x.x.x>${NORMAL}"

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
#
echo    "   CA_CERT           File name of certificate (default ${DEFAULT_CA_CERT})"
echo    "   WORKING_DIRECTORY Absolute path for working directory"
echo    "                     (default ${DEFAULT_WORKING_DIRECTORY})"
echo    "   CERT_DAEMON_DIR   dockerd certification directory"
echo    "                     (default ${DEFAULT_CERT_DAEMON_DIR})"

echo -e "\n${BOLD}OPTIONS${NORMAL}"
echo -e "Order of precedence: CLI options, environment variable, default value.\n"     # 3.572
echo    "   --help, -help, help, -h, h, -?"                                            # 3.572
echo -e "\tOn-line brief reference manual\n"                                           # 3.572
echo    "   --usage, -usage, -u"                                                       # 3.572
echo -e "\tOn-line command usage\n"                                                    # 3.572
echo    "   --version, -version, -v"                                                      # 0.3.579
echo -e "\tOn-line command version\n"                                                  # 3.572
#                                                                                         # 0.3.579
echo    "   REMOTE_HOST"                                                                  # 0.3.579
echo -e "\tRemote host to copy certificates to (default ${DEFAULT_REMOTE_HOST})\n"        # 0.3.579
echo    "   WORKING_DIRECTORY"                                                            # 0.3.579
echo -e "\tAbsolute path for working directory (default ${DEFAULT_WORKING_DIRECTORY})\n"  # 0.3.579
echo    "   CERT_DAEMON_DIR"                                                              # 0.3.579
echo -e "\tdockerd certification directory (default ${DEFAULT_CERT_DAEMON_DIR})"          # 0.3.579

###  Production standard 6.3.547  Architecture tree
echo -e "\n${BOLD}ARCHITECTURE TREE${NORMAL}"  # STORAGE & CERTIFICATION
echo    "<USER_HOME>/                               <-- Location of user home directory"
echo    "└── <USER-1>/.docker/                      <-- User docker cert directory"
echo    "    └── docker-ca/                         <-- Working directory to create certs"
echo    "        └── hosts/                         <-- Directory for hostnames"            # 3.539
echo    "            └── <HOST>/                    <-- Directory to store host certs"      # 3.539
echo    "               ├── ca.pem                  <-- CA Cert"                            # 3.542
echo    "               ├── <HOST>-cert.pem         <-- public key (default: cert.pem)"     # 3.547
echo -e "               └── <HOST>-priv-key.pem     <-- private key (default: key.pem)\n"   # 3.547
echo    "/etc/ "
echo    "└── docker/ "
echo    "    └── certs.d/                           <-- Host docker cert directory"
echo    "        └── daemon/                        <-- Daemon cert directory"
echo    "            ├── ca.pem                     <-- CA Cert"                            # 3.542
echo    "            ├── <HOST>-cert.pem            <-- public key (default: cert.pem)"     # 3.547
echo    "            └── <HOST>-priv-key.pem        <-- private key (default: key.pem)"     # 3.547

echo -e "\n${BOLD}DOCUMENTATION${NORMAL}"
echo    "   https://github.com/BradleyA/docker-security-infrastructure/blob/master/docker-TLS/README.md"

echo -e "\n${BOLD}EXAMPLES${NORMAL}"
echo -e "   Administration user copies TLS keys and CA to remote host, two.cptx86.com.\n\t${BOLD}${COMMAND_NAME} two.cptx86.com${NORMAL}\n" # 3.550

echo -e "\n${BOLD}AUTHOR${NORMAL}"                                                          # 3.550
echo    "   ${COMMAND_NAME} was written by Bradley Allen <allen.bradley@ymail.com>"         # 3.550

echo -e "\n${BOLD}REPORTING BUGS${NORMAL}"                                                  # 3.550
echo    "   Report ${COMMAND_NAME} bugs https://github.com/BradleyA/docker-security-infrastructure/issues/new/choose"  # 0.3.579

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
REMOTE_HOST=${1:-${DEFAULT_REMOTE_HOST}}
#    Order of precedence: CLI argument, environment variable, default code
if [[ $# -ge  2 ]]  ; then WORKING_DIRECTORY=${2} ; elif [[ "${WORKING_DIRECTORY}" == "" ]] ; then WORKING_DIRECTORY="${DEFAULT_WORKING_DIRECTORY}" ; fi
if [[ $# -ge  3 ]]  ; then CERT_DAEMON_DIR=${3} ; elif [[ "${CERT_DAEMON_DIR}" == "" ]] ; then CERT_DAEMON_DIR="${DEFAULT_CERT_DAEMON_DIR}" ; fi
#    Order of precedence: environment variable, default code
if [[ "${CA_CERT}" == "" ]] ; then CA_CERT="${DEFAULT_CA_CERT}" ; fi
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  REMOTE_HOST >${REMOTE_HOST}< WORKING_DIRECTORY >${WORKING_DIRECTORY}< CERT_DAEMON_DIR >${CERT_DAEMON_DIR}<  CA_CERT >${CA_CERT}<" 1>&2 ; fi

#    Check if ${WORKING_DIRECTORY} directory on system
if [[ ! -d "${WORKING_DIRECTORY}" ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Default directory, ${BOLD}${YELLOW}${WORKING_DIRECTORY}${NORMAL}, not on system." 1>&2
#    Help hint
  echo -e "\n\tRunning ${BOLD}${YELLOW}create-site-private-public-tls.sh${NORMAL} will create directories"
  echo -e "\tand site private and public keys.  Then run sudo"
  echo -e "\t${BOLD}${YELLOW}create-new-openssl.cnf-tls.sh${NORMAL} to modify openssl.cnf file."
  echo -e "\t${BOLD}See DOCUMENTATION link in '${YELLOW}${COMMAND_NAME} --help${NORMAL}' for more information.${NORMAL}"
  exit 1
fi

#    Check if ${CA_CERT} file on system
if ! [[ -e "${WORKING_DIRECTORY}/hosts/${REMOTE_HOST}/${CA_CERT}" ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Site public key ${WORKING_DIRECTORY}/hosts/${REMOTE_HOST}/${CA_CERT}\n  is not in this location.\n  Enter ${COMMAND_NAME} --help for more information." 1>&2
#    Help hint
  echo -e "\n\tEither link ${CA_CERT} to a file in site directory"
  echo -e "\t${WORKING_DIRECTORY}/site/"
  echo -e "\tor run ${YELLOW}create-site-private-public-tls.sh${WHITE} and sudo"
  echo -e "\t${YELLOW}create-new-openssl.cnf-tls.sh${WHITE} to create a new key."
  exit 1
fi

#    Check if priv-key.pem file on system
if ! [[ -e "${WORKING_DIRECTORY}/hosts/${REMOTE_HOST}/priv-key.pem" ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  The ${YELLOW}priv-key.pem${WHITE} file was not found in ${WORKING_DIRECTORY}/hosts/${REMOTE_HOST}/" 1>&2
#    Help hint
  echo -e "\n\tRunning ${BOLD}${YELLOW}create-user-tls.sh${NORMAL} will create public and private keys.\n\tEnter ${COMMAND_NAME} --help for more information."
  exit 1
fi

echo -e "\n\t${BOLD}${USER} user may receive password and passphrase prompts"
echo -e "\tfrom host: ${REMOTE_HOST}${NORMAL}.  Running"
echo -e "\t  ${BOLD}${YELLOW}ssh-copy-id ${USER}@${REMOTE_HOST}${NORMAL}"
echo -e "\tmay stop some of the prompts.\n"

if [[ "${LOCALHOST}" != "${REMOTE_HOST}" ]] ; then  #  >>> #48 Not "${LOCALHOST}"
#    Check if ${REMOTE_HOST} is available on ssh port
  if ! $(ssh "${REMOTE_HOST}" 'exit' >/dev/null 2>&1 ) ; then
    new_message "${LINENO}" "${RED}ERROR${WHITE}" "  ${REMOTE_HOST} not responding on ssh port." 1>&2
    exit 1
  fi
fi

#    Create working directory ${WORKING_DIRECTORY}/hosts/${REMOTE_HOST}/${REMOTE_HOST}
cd "${WORKING_DIRECTORY}/hosts/${REMOTE_HOST}"
mkdir -p "${REMOTE_HOST}"
cd       "${REMOTE_HOST}"

#    Check if ${WORKING_DIRECTORY}/hosts/${REMOTE_HOST}/${REMOTE_HOST}/docker directory on system from a previous backup
if [[ -d "docker" ]] ; then
  rm -fR docker
fi

#    Backup ${REMOTE_HOST}:${CERT_DAEMON_DIR}/.. to support rollback
FILE_DATE_STAMP=$(date +%Y-%m-%dT%H.%M.%S.%2N-%Z)
echo -e "\n\tBacking up ${REMOTE_HOST}:${CERT_DAEMON_DIR}/.."
echo -e "\tto $(pwd)\n\t${BOLD}${YELLOW}Root access required.${NORMAL}\n"
if [[ "${LOCALHOST}" != "${REMOTE_HOST}" ]] ; then  #  >>> #48 Not "${LOCALHOST}"
  ssh -t "${REMOTE_HOST}" "sudo mkdir -p ${CERT_DAEMON_DIR} ; cd /etc ; sudo tar -pcf /tmp/${REMOTE_HOST}--${FILE_DATE_STAMP}.tar ./docker/certs.d/daemon ; sudo chown ${USER}.${USER} /tmp/${REMOTE_HOST}--${FILE_DATE_STAMP}.tar ; chmod 0400 /tmp/${REMOTE_HOST}--${FILE_DATE_STAMP}.tar"
  scp -p "${REMOTE_HOST}:/tmp/${REMOTE_HOST}--${FILE_DATE_STAMP}.tar" .
  ssh -t "${REMOTE_HOST}" "rm -f /tmp/${REMOTE_HOST}--${FILE_DATE_STAMP}.tar"
else
#    Backup ${CERT_DAEMON_DIR}/.. to support rollback
  sudo mkdir -p "${CERT_DAEMON_DIR}"
  cd /etc
  sudo tar -pcf "/tmp/${REMOTE_HOST}--${FILE_DATE_STAMP}.tar"  ./docker/certs.d/daemon
  cd  "${WORKING_DIRECTORY}/hosts/${REMOTE_HOST}/${REMOTE_HOST}"
  sudo chown "${USER}.${USER}"  "/tmp/${REMOTE_HOST}--${FILE_DATE_STAMP}.tar"
  chmod 0400 "/tmp/${REMOTE_HOST}--${FILE_DATE_STAMP}.tar"
  cp -p      "/tmp/${REMOTE_HOST}--${FILE_DATE_STAMP}.tar"  .
  rm -f      "/tmp/${REMOTE_HOST}--${FILE_DATE_STAMP}.tar"
fi

tar -pxf "${REMOTE_HOST}--${FILE_DATE_STAMP}.tar"

TEMP_CA_PEM=$(ls -l "${WORKING_DIRECTORY}/hosts/${REMOTE_HOST}/ca.pem" | sed -e 's/^.* -> //')
TEMP_CERT_PEM=$(ls -l "${WORKING_DIRECTORY}/hosts/${REMOTE_HOST}/cert.pem" | sed -e 's/^.* -> //')
TEMP_PRIV_KEY_PEM=$(ls -l "${WORKING_DIRECTORY}/hosts/${REMOTE_HOST}/priv-key.pem" | sed -e 's/^.* -> //')

#    Create certification tar file and install it to ${REMOTE_HOST}
chmod 0700 ./docker/certs.d/daemon
cp -pf "../${TEMP_CA_PEM}"        ./docker/certs.d/daemon
cp -pf "../${TEMP_CERT_PEM}"      ./docker/certs.d/daemon
cp -pf "../${TEMP_PRIV_KEY_PEM}"  ./docker/certs.d/daemon
cd     ./docker/certs.d/daemon
ln -sf "${TEMP_CA_PEM}"        ca.pem
ln -sf "${TEMP_CERT_PEM}"      cert.pem     #  default  Repeat this on each host that will be running a Docker Swarm standalone manager
ln -sf "${TEMP_PRIV_KEY_PEM}"  key.pem      #  default  Repeat this on each host that will be running a Docker Swarm standalone manager
ln -sf "${TEMP_CERT_PEM}"      "${REMOTE_HOST}-cert.pem"      #  docker-security-infrastructure/dockerd-configuration-options/ uses these links
ln -sf "${TEMP_PRIV_KEY_PEM}"  "${REMOTE_HOST}-priv-key.pem"  #  docker-security-infrastructure/dockerd-configuration-options/ uses these links
cd     ../../..
FILE_DATE_STAMP=$(date +%Y-%m-%dT%H.%M.%S.%2N-%Z)
tar -pcf   "./${REMOTE_HOST}--${FILE_DATE_STAMP}.tar" ./docker/certs.d/daemon
chmod 0600 "./${REMOTE_HOST}--${FILE_DATE_STAMP}.tar"
if [[ "${LOCALHOST}" != "${REMOTE_HOST}" ]] ; then  #  >>> #48 Not "${LOCALHOST}"
  scp -p   "./${REMOTE_HOST}--${FILE_DATE_STAMP}.tar" "${USER}@${REMOTE_HOST}:/tmp"
else
  cp -p    "./${REMOTE_HOST}--${FILE_DATE_STAMP}.tar" /tmp
fi

#    Create remote directory /etc/docker/certs.d/daemon
#    This directory was selected to place dockerd TLS certifications because
#    docker registry stores it's TLS certifications in /etc/docker/certs.d.
echo -e "\n\tCopying dockerd certification to ${REMOTE_HOST}"
echo -e "\t${BOLD}${YELLOW}Root access required.${NORMAL}\n"
if [[ "${LOCALHOST}" != "${REMOTE_HOST}" ]] ; then  #  >>> #48 Not "${LOCALHOST}"
  ssh -t "${USER}@${REMOTE_HOST}" "cd /etc ; sudo tar -pxf /tmp/${REMOTE_HOST}--${FILE_DATE_STAMP}.tar ; sudo chmod 0700 /etc/docker ; sudo chmod 0700 /etc/docker/certs.d ; sudo chown -R root.root ./docker ; rm /tmp/${REMOTE_HOST}--${FILE_DATE_STAMP}.tar"
else
  cd   /etc
  sudo tar -pxf   "/tmp/${REMOTE_HOST}--${FILE_DATE_STAMP}.tar"
  sudo chmod 0700 /etc/docker
  sudo chmod 0700 /etc/docker/certs.d
  sudo chown -R root.root ./docker
  rm   "/tmp/${REMOTE_HOST}--${FILE_DATE_STAMP}.tar"
fi

#    Display instructions about certification environment variables
echo -e "\n\tAdd TLS flags to dockerd so it will know to use TLS certifications"
echo -e "\t(--tlsverify, --tlscacert, --tlscert, --tlskey).  Scripts that will"
echo -e "\thelp with setup and operations of Docker using TLS can be found:"
echo    "https://github.com/BradleyA/docker-security-infrastructure/tree/master/dockerd-configuration-options"
echo -e "\tThe ${YELLOW}dockerd-configuration-options${WHITE} scripts will help with configuration"
echo -e "\tof dockerd on systems running Ubuntu 16.04, 18.04, 20.04 (systemd)"
echo -e "\tand Ubuntu 14.04 (Upstart)."
#
echo -e "\n\tIf dockerd is already using TLS certifications then entering one of the"
echo -e "\tfollowing will restart dockerd with the new certifications.\n"
echo -e "\tUbuntu 16.04, 18.04, 20.04 (Systemd) ${BOLD}${YELLOW}ssh -t ${REMOTE_HOST} 'sudo systemctl restart docker'${NORMAL}"
echo -e "\tUbuntu 14.04 (Upstart) ${BOLD}${YELLOW}ssh -t ${REMOTE_HOST} 'sudo service docker restart'${NORMAL}"

# >>>	May want to create a version of this script that automates this process for SRE tools,
# >>>	but keep this script for users to run manually,
# >>>	open ticket and remove this comment

#
new_message "${LINENO}" "${YELLOW}INFO${WHITE}" "  Operation finished....." 1>&2
###
