#!/bin/bash
# 	docker-TLS/copy-host-2-remote-host-tls.sh  3.479.1002  2019-10-23T13:59:01.326766-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.478  
# 	   docker-TLS/copy-user-2-remote-host-tls.sh docker-TLS/copy-host-2-remote-host-tls.sh   changes for #5 #48  localhost does not use scp & ssh 
# 	docker-TLS/copy-host-2-remote-host-tls.sh  3.469.986  2019-10-21T22:21:12.852432-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.468-1-g4bdbb55  
# 	   docker-TLS/copy-host-2-remote-host-tls.sh   added color output ; upgraded Production standard 4.3.534 Documentation Language 
# 	docker-TLS/copy-host-2-remote-host-tls.sh  3.463.976  2019-10-15T23:31:11.161027-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.462-1-g2ea495b  
# 	   docker-TLS/copy-host-2-remote-host-tls.sh  - add code so localhost does not use scp & ssh #48 first pass 
# 	docker-TLS/copy-host-2-remote-host-tls.sh  3.457.961  2019-10-13T21:15:58.035732-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.456-2-g59e591e
# 	   #64 docker-TLS/copy-user-2-remote-host-tls.sh   Production standard 2.3.529 log format, 8.3.530 --usage, 1.3.531 DEBUG variable
# 	docker-TLS/copy-host-2-remote-host-tls.sh  3.456.958  2019-10-13T20:56:21.738318-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.455-2-gd3bc5e6
# 	   docker-TLS/copy-host-2-remote-host-tls.sh   close #65  Production standard 2.3.529 log format, 8.3.530 --usage, 1.3.531 DEBUG variable
# 	docker-TLS/copy-host-2-remote-host-tls.sh  3.280.747  2019-06-10T12:43:31.498537-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.279
# 	   update copy-host-2-remote-host-tls.sh while trying to reproduce incident docker-TLS/check-{host,user}-tls.sh - which one should check if the ca.pem match #49
#86# docker-TLS/copy-host-2-remote-host-tls.sh - Copy public, private keys and CA to remote host
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
WHITE=$(tput  setaf 7)

###  Production standard 7.0 Default variable value
DEFAULT_REMOTE_HOST="$(hostname -f)"    # local host
DEFAULT_WORKING_DIRECTORY=~/.docker/docker-ca
DEFAULT_CA_CERT="ca.pem"
DEFAULT_CERT_DAEMON_DIR="/etc/docker/certs.d/daemon/"

###  Production standard 8.3.530 --usage
display_usage() {
COMMAND_NAME=$(echo "${0}" | sed 's/^.*\///')
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

###  Production standard 0.3.214 --help
display_help() {
display_usage
#    Displaying help DESCRIPTION in English en_US.UTF-8
echo -e "\n${BOLD}DESCRIPTION${NORMAL}"
echo    "A user with administration authority uses this script to copy host TLS CA,"
echo    "public, and private keys from <WORKING_DIRECTORY> directory on this"
echo    "system to /etc/docker/certs.d/daemon directory on a local system or"
echo    "remote system.  To copy to this local system, do not enter a <REMOTE_HOST>"
echo -e "\nTo copy to this local system, do not enter a <REMOTE_HOST> on the"
echo    "command line and this local system will be used."
echo -e "\nThe administration user may receive password and/or passphrase prompts from a"
echo    "remote systen; running the following may stop the prompts in your cluster."
echo -e "\t${BOLD}ssh-copy-id <USER>@<REMOTE_HOST>${NORMAL}"
echo    "or"
echo -e "\t${BOLD}ssh-copy-id <USER>@<x.x.x.x>${NORMAL}"

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
echo    "   WORKING_DIRECTORY Absolute path for working directory"
echo    "                     (default ${DEFAULT_WORKING_DIRECTORY})"
echo -e "\n${BOLD}OPTIONS${NORMAL}"
echo    "   REMOTE_HOST       Remote host to copy certificates to"
echo    "                     (default ${DEFAULT_REMOTE_HOST})"
echo    "   WORKING_DIRECTORY Absolute path for working directory"
echo    "                     (default ${DEFAULT_WORKING_DIRECTORY})"
echo    "   CERT_DAEMON_DIR   dockerd certification directory"
echo    "                     (default ${DEFAULT_CERT_DAEMON_DIR})"

###  Production standard 6.1.177 Architecture tree
echo -e "\n${BOLD}ARCHITECTURE TREE${NORMAL}"  # STORAGE & CERTIFICATION
echo    "<USER_HOME>/                               <-- Location of user home directory"
echo    "└── <USER-1>/.docker/                      <-- User docker cert directory"
echo -e "    └── docker-ca/                         <-- Working directory to create certs\n"
echo    "/etc/ "
echo    "└── docker/ "
echo    "    └── certs.d/                           <-- Host docker cert directory"
echo    "        └── daemon/                        <-- Daemon cert directory"
echo    "            ├── ca.pem                     <-- Daemon tlscacert"
echo    "            ├── cert.pem                   <-- Daemon tlscert"
echo    "            └── key.pem                    <-- Daemon tlskey"

echo -e "\n${BOLD}DOCUMENTATION${NORMAL}"
echo    "   https://github.com/BradleyA/docker-security-infrastructure/blob/master/docker-TLS/README.md"

echo -e "\n${BOLD}EXAMPLES${NORMAL}"
echo -e "   Administration user copies TLS keys and CA to remote host, two.cptx86.com.\n\t${BOLD}${0} two.cptx86.com${NORMAL}"
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
CERT_DAEMON_DIR=${3:-${DEFAULT_CERT_DAEMON_DIR}}
#    Order of precedence: environment variable, default code
if [[ "${CA_CERT}" == "" ]] ; then CA_CERT="${DEFAULT_CA_CERT}" ; fi
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  REMOTE_HOST >${REMOTE_HOST}< WORKING_DIRECTORY >${WORKING_DIRECTORY}< CERT_DAEMON_DIR >${CERT_DAEMON_DIR}<  CA_CERT >${CA_CERT}<" 1>&2 ; fi

#    Check if ${WORKING_DIRECTORY} directory on system
if [[ ! -d "${WORKING_DIRECTORY}" ]] ; then
  display_help | more
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Default directory, ${BOLD}${WORKING_DIRECTORY}${NORMAL}, not on system." 1>&2
#    Help hint
  echo -e "\n\tRunning create-site-private-public-tls.sh will create directories"
  echo -e "\tand site private and public keys.  Then run sudo"
  echo -e "\tcreate-new-openssl.cnf-tls.sh to modify openssl.cnf file."
  echo -e "\t${BOLD}See DOCUMENTATION link in '${0} --help' for more information.${NORMAL}"
  exit 1
fi

#    Check if ${REMOTE_HOST}-priv-key.pem file on system
if ! [[ -e "${WORKING_DIRECTORY}/${REMOTE_HOST}-priv-key.pem" ]] ; then
  display_help | more
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  The ${REMOTE_HOST}-priv-key.pem file was not found in ${WORKING_DIRECTORY}" 1>&2
#    Help hint
  echo -e "\tRunning create-host-tls.sh will create public and private keys."
  exit 1
fi

cd "${WORKING_DIRECTORY}"
echo -e "\n\t${BOLD}${USER}${NORMAL} user may receive password and passphrase prompts"
echo -e "\tfrom ${REMOTE_HOST}.  Running"
echo -e "\t${BOLD}ssh-copy-id ${USER}@${REMOTE_HOST}${NORMAL}"
echo -e "\tmay stop some of the prompts.\n"

if [[ "${LOCALHOST}" != "${REMOTE_HOST}" ]] ; then  #  >>> #48 Not "${LOCALHOST}"
#    Check if ${REMOTE_HOST} is available on ssh port
  if ! $(ssh "${REMOTE_HOST}" 'exit' >/dev/null 2>&1 ) ; then
    new_message "${LINENO}" "${RED}ERROR${WHITE}" "  ${REMOTE_HOST} not responding on ssh port." 1>&2
    exit 1
  fi
  #    Check if /etc/docker directory on ${REMOTE_HOST}
  if ! $(ssh -t "${REMOTE_HOST}" "test -d /etc/docker") ; then
    new_message "${LINENO}" "${RED}ERROR${WHITE}" "  /etc/docker directory missing, is docker installed on ${REMOTE_HOST}." 1>&2
    exit 1
  fi
else
  #    Check if /etc/docker directory on ${LOCALHOST}
  if ! [[ -d "/etc/docker" ]] ; then
    new_message "${LINENO}" "${RED}ERROR${WHITE}" "  /etc/docker directory missing, is docker installed on ${REMOTE_HOST}." 1>&2
    exit 1
  fi
fi

#    Create working directory ${WORKING_DIRECTORY}/${REMOTE_HOST}
mkdir -p "${REMOTE_HOST}"
cd       "${REMOTE_HOST}"

#    Backup ${REMOTE_HOST}:${CERT_DAEMON_DIR}/..
FILE_DATE_STAMP=$(date +%Y-%m-%dT%H.%M.%S.%6N%z)
echo -e "\n\tBacking up ${REMOTE_HOST}:${CERT_DAEMON_DIR}/.."
echo -e "\tto $(pwd)\n\tRoot access required.\n"
if [[ "${LOCALHOST}" != "${REMOTE_HOST}" ]] ; then  #  >>> #48 Not "${LOCALHOST}"
  ssh -t "${USER}@${REMOTE_HOST}" "sudo mkdir -p ${CERT_DAEMON_DIR} ; cd /etc ; sudo tar -pcf /tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar ./docker/certs.d/daemon ; sudo chown ${USER}.${USER} /tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar ; chmod 0400 /tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar"
  scp -p "${USER}@${REMOTE_HOST}:/tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar" .
  ssh -t "${USER}@${REMOTE_HOST}" "rm -f /tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar"
else
#    Backup ${CERT_DAEMON_DIR}/..
  sudo mkdir -p "${CERT_DAEMON_DIR}"
  cd /etc
  sudo tar -pcf "/tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar" ./docker/certs.d/daemon
  sudo chown "${USER}"."${USER}"  "/tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar"
  chmod 0400 "/tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar"
  cp -p      "/tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar" .
  rm -f      "/tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar"
fi

tar -pxf "${REMOTE_HOST}-${FILE_DATE_STAMP}.tar"

#    Check if /etc/docker/certs.d/daemon/${REMOTE_HOST}-priv-key.pem file exists
if [[ -e "./docker/certs.d/daemon/${REMOTE_HOST}-priv-key.pem" ]] ; then
  echo -e "\n\t/etc/docker/certs.d/daemon/${REMOTE_HOST}-priv-key.pem"
  echo -e "\talready exists, ${BOLD}renaming existing keys${NORMAL} so new keys can be installed.\n"
  mv "./docker/certs.d/daemon/${REMOTE_HOST}-priv-key.pem" "./docker/certs.d/daemon/${REMOTE_HOST}-priv-key.pem_${FILE_DATE_STAMP}"
  mv "./docker/certs.d/daemon/${REMOTE_HOST}-cert.pem" "./docker/certs.d/daemon/${REMOTE_HOST}-cert.pem_${FILE_DATE_STAMP}"
  mv "./docker/certs.d/daemon/${CA_CERT}" "./docker/certs.d/daemon/${CA_CERT}_${FILE_DATE_STAMP}"
  rm ./docker/certs.d/daemon/{cert,key}.pem
fi

#    Create certification tar file and install it to ${REMOTE_HOST}
chmod 0700 ./docker/certs.d/daemon
cp -p "../${REMOTE_HOST}-priv-key.pem" ./docker/certs.d/daemon
cp -p "../${REMOTE_HOST}-cert.pem" ./docker/certs.d/daemon
cp -p ../${CA_CERT} ./docker/certs.d/daemon
cd ./docker/certs.d/daemon
ln -s "${REMOTE_HOST}-priv-key.pem" key.pem
ln -s "${REMOTE_HOST}-cert.pem" cert.pem
cd ../../..
FILE_DATE_STAMP=$(date +%Y-%m-%dT%H.%M.%S.%6N%z)
tar -pcf "./${REMOTE_HOST}-${FILE_DATE_STAMP}.tar" ./docker/certs.d/daemon
chmod 0600 "./${REMOTE_HOST}-${FILE_DATE_STAMP}.tar"
if [[ "${LOCALHOST}" != "${REMOTE_HOST}" ]] ; then  #  >>> #48 Not "${LOCALHOST}"
  scp -p "./${REMOTE_HOST}-${FILE_DATE_STAMP}.tar" "${USER}@${REMOTE_HOST}:/tmp"
else
  cp -p "./${REMOTE_HOST}-${FILE_DATE_STAMP}.tar" /tmp
fi

#    Create remote directory /etc/docker/certs.d/daemon
#    This directory was selected to place dockerd TLS certifications because
#    docker registry stores it's TLS certifications in /etc/docker/certs.d.
echo -e "\n\tCopying dockerd certification to ${REMOTE_HOST}"
echo -e "\tRoot access required.\n"
if [[ "${LOCALHOST}" != "${REMOTE_HOST}" ]] ; then  #  >>> #48 Not "${LOCALHOST}"
  ssh -t "${USER}@${REMOTE_HOST}" "cd /etc ; sudo tar -pxf /tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar ; sudo chmod 0700 /etc/docker ; sudo chmod 0700 /etc/docker/certs.d ; sudo chown -R root.root ./docker ; rm /tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar"
else
  cd /etc
  sudo tar -pxf "/tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar"
  sudo chmod 0700 /etc/docker
  sudo chmod 0700 /etc/docker/certs.d
  sudo chown -R root.root ./docker
  rm "/tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar"
fi
cd ..

#    Remove working directory ${WORKING_DIRECTORY}/${REMOTE_HOST}
rm -rf "${REMOTE_HOST}"

#    Display instructions about certification environment variables
echo -e "\n\tAdd TLS flags to dockerd so it will know to use TLS certifications"
echo -e "\t(--tlsverify, --tlscacert, --tlscert, --tlskey).  Scripts that will"
echo -e "\thelp with setup and operations of Docker using TLS can be found:"
echo    "https://github.com/BradleyA/docker-security-infrastructure/tree/master/dockerd-configuration-options"
echo -e "\tThe dockerd-configuration-options scripts will help with configuration"
echo -e "\tof dockerd on systems running Ubuntu 16.04 (systemd) and Ubuntu 14.04"
echo -e "\t(Upstart)."
#
echo -e "\n\tIf dockerd is already using TLS certifications then entering one of the"
echo -e "\tfollowing will restart dockerd with the new certifications.\n"
echo -e "\tUbuntu 16.04 (Systemd) ${BOLD}ssh -t ${REMOTE_HOST} 'sudo systemctl restart docker'${NORMAL}"
echo -e "\tUbuntu 14.04 (Upstart) ${BOLD}ssh -t ${REMOTE_HOST} 'sudo service docker restart'${NORMAL}"

# >>>	May want to create a version of this script that automates this process for SRE tools,
# >>>	but keep this script for users to run manually,
# >>>	open ticket and remove this comment

#
new_message "${LINENO}" "${YELLOW}INFO${WHITE}" "  Operation finished....." 1>&2
###
