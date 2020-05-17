#!/bin/bash
# 	docker-TLS/check-registry-tls.sh  4.2.5.1286  2020-05-16T21:34:33.094398-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  master  uadmin  five-rpi3b.cptx86.com 4.2.4  
# 	   docker-TLS/check-registry-tls.sh docker-TLS/copy-registry-tls.sh -->   update Options  
# 	docker-TLS/check-registry-tls.sh  4.2.4.1285  2020-05-16T20:26:17.725612-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  master  uadmin  five-rpi3b.cptx86.com 4.2.3  
# 	   docker-TLS/check-registry-tls.sh -->   close #74  updated display_help with examples  
# 	docker-TLS/check-registry-tls.sh  4.1.1211  2019-12-30T11:34:26.795302-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  five-rpi3b.cptx86.com 3.565-13-g1455a67  
# 	   docker-TLS/*   New Release 4.1 
#86# docker-TLS/check-registry-tls.sh - Check certifications for private registry
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
UNDERLINE=$(tput -Txterm sgr 0 1)
NORMAL=$(tput -Txterm sgr0)
RED=$(tput    setaf 1)
GREEN=$(tput  setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput   setaf 4)
PURPLE=$(tput setaf 5)
CYAN=$(tput   setaf 6)
WHITE=$(tput  setaf 7)

###  Production standard 7.0 Default variable value
DEFAULT_REGISTRY_HOST=$(hostname -f)    # local host
DEFAULT_REGISTRY_PORT="5000"
DEFAULT_CLUSTER="us-tx-cluster-1/"
DEFAULT_DATA_DIR="/usr/local/data/"

###  Production standard 8.3.541 --usage
COMMAND_NAME=$(echo "${0}" | sed 's/^.*\///')   # 3.541
display_usage() {
echo -e "\n${NORMAL}${COMMAND_NAME}\n   - Check certifications for private registry"
echo -e "\n${BOLD}USAGE${NORMAL}"
echo    "   ${YELLOW}Positional Arguments${NORMAL}"
echo    "   ${COMMAND_NAME} [<REGISTRY_HOST>]"
echo    "   ${COMMAND_NAME}  <REGISTRY_HOST> [<REGISTRY_PORT>]"
echo    "   ${COMMAND_NAME}  <REGISTRY_HOST>  <REGISTRY_PORT> [<CLUSTER>]"
echo -e "   ${COMMAND_NAME}  <REGISTRY_HOST>  <REGISTRY_PORT>  <CLUSTER> [<DATA_DIR>]\n"
echo    "   ${COMMAND_NAME} [--help | -help | help | -h | h | -?]"
echo    "   ${COMMAND_NAME} [--usage | -usage | -u]"
echo    "   ${COMMAND_NAME} [--version | -version | -v]"
}

###  Production standard 0.3.550 --help                                                     # 3.550
display_help() {
display_usage
#    Displaying help DESCRIPTION in English en_US.UTF-8, en.UTF-8, C.UTF-8                  # 3.550
echo -e "\n${BOLD}DESCRIPTION${NORMAL}"
echo    "This script has to be run as root to check daemon registry cert (ca.crt),"
echo    "A user with administration authority uses this script to check daemon registry cert (ca.crt),"

echo    "registry cert (domain.crt), and registry private key (domain.key) in"
echo    "/etc/docker/certs.d/<REGISTRY_HOST>:<REGISTRY_PORT>/ and"
echo    "<DATA_DIR>/<CLUSTER>/docker-registry/<REGISTRY_HOST>-<REGISTRY_PORT>/certs/"
echo    "directories.  The certification files and directory permissions are also"
echo    "checked."

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
echo    "   REGISTRY_HOST   Registry host (default '${DEFAULT_REGISTRY_HOST}')"
echo    "   REGISTRY_PORT   Registry port number (default '${DEFAULT_REGISTRY_PORT}')"
echo    "   CLUSTER         Cluster name (default '${DEFAULT_CLUSTER}')"
echo    "   DATA_DIR        Data directory (default '${DEFAULT_DATA_DIR}')"

echo -e "\n${BOLD}OPTIONS${NORMAL}"
echo -e "Order of precedence: CLI options, environment variable, default value.\n"     # 3.572
echo    "   --help, -help, help, -h, h, -?"                                            # 3.572
echo -e "\tOn-line brief reference manual\n"                                           # 3.572
echo    "   --usage, -usage, -u"                                                       # 3.572
echo -e "\tOn-line command usage\n"                                                    # 3.572
echo    "   --version, -version, -v"                                                      # 0.3.579
echo -e "\tOn-line command version\n"                                                  # 3.572
#
echo -e "   REGISTRY_HOST\n\tRegistry host (default '${DEFAULT_REGISTRY_HOST}')\n"
echo -e "   REGISTRY_PORT\n\tRegistry port number (default '${DEFAULT_REGISTRY_PORT}')\n"
echo -e "   CLUSTER\n\tCluster name (default '${DEFAULT_CLUSTER}')\n"
echo -e "   DATA_DIR\n\tData directory (default '${DEFAULT_DATA_DIR}')"

###  Production standard 6.3.547  Architecture tree
echo -e "\n${BOLD}ARCHITECTURE TREE${NORMAL}"  # STORAGE & CERTIFICATION
echo    "/usr/local/data/                           <-- <DATA_DIR>"
echo    "└── <CLUSTER>/                             <-- <CLUSTER>"
echo    "    └── docker-registry/                   <-- Docker registry directory"
echo    "        ├── <REGISTRY_HOST>-<REGISTRY_PORT>/ < Registry container mount"
echo    "        │   ├── certs/                     <-- Registry cert directory"
echo    "        │   │   ├── domain.crt             <-- Registry cert"
echo    "        │   │   └── domain.key             <-- Registry private key"
echo    "        │   └── docker/                    <-- Registry storage directory"
echo    "        ├── <REGISTRY_HOST>-<REGISTRY_PORT>/ < Registry container mount"
echo -e "        └── <REGISTRY_HOST>-<REGISTRY_PORT>/ < Registry container mount\n"
echo    "/etc/ "
echo    "└── docker/ "
echo    "    └── certs.d/                           <-- Host docker cert directory"
echo    "        ├── <REGISTRY_HOST>:<REGISTRY_PORT>/ < Registry cert directory"
echo    "        │   └── ca.crt                     <-- Daemon registry domain cert"
echo    "        ├── <REGISTRY_HOST>:<REGISTRY_PORT>/ < Registry cert directory"
echo    "        └── <REGISTRY_HOST>:<REGISTRY_PORT>/ < Registry cert directory"

echo -e "\n${BOLD}DOCUMENTATION${NORMAL}"
echo    "   ${UNDERLINE}https://github.com/BradleyA/docker-security-infrastructure/blob/master/docker-TLS/README.md${NORMAL}"  # 4.2.4

echo -e "\n${BOLD}EXAMPLES${NORMAL}"   # 3.550
echo -e "   Check local host certificates using default port (${DEFAULT_REGISTRY_PORT})\n\t${BOLD}sudo ${COMMAND_NAME}${NORMAL}\n"
echo -e "   Check local host certificates with environment variable DEBUG=1\n\t${BOLD}sudo DEBUG=1 ${COMMAND_NAME}${NORMAL}\n"
echo -e "   Check local host certificates with environment variable REGISTRY_PORT=17315\n\t${BOLD}sudo REGISTRY_PORT=17315 ${COMMAND_NAME}${NORMAL}\n"
echo    "   This script works for the local host only.  To use ${COMMAND_NAME} on a"
echo    "   remote hosts (one-rpi3b.cptx86.com) with ssh port of 12323 as uadmin user"
echo -e "\t${BOLD}ssh -tp 12323 uadmin@one-rpi3b.cptx86.com 'sudo ${COMMAND_NAME} two.cptx86.com 17313'${NORMAL}\n"
echo    "   Or using ssh's default port as uadmin user"
echo -e "\t${BOLD}ssh -t uadmin@three-rpi3b.cptx86.com 'sudo ${COMMAND_NAME} two.cptx86.com 17313'${NORMAL}\n"
echo    "   To loop through a list of hosts in the cluster use,"
echo    "   ${UNDERLINE}https://github.com/BradleyA/Linux-admin/tree/master/cluster-command${NORMAL}"
echo -e "\t${BOLD}cluster-command.sh special 'sudo ${COMMAND_NAME} two.cptx86.com 17313'${NORMAL}"

echo -e "\n${BOLD}SEE ALSO${NORMAL}"                                                        # 3.550
echo    "   cluster-command.sh (${UNDERLINE}https://github.com/BradleyA/Linux-admin/tree/master/cluster-command)${NORMAL}"  # 4.2.4

echo -e "\n${BOLD}AUTHOR${NORMAL}"                                                          # 3.550
echo    "   ${COMMAND_NAME} was written by Bradley Allen <allen.bradley@ymail.com>"         # 3.550

echo -e "\n${BOLD}REPORTING BUGS${NORMAL}"                                                  # 3.550
echo    "   Report ${COMMAND_NAME} bugs ${UNDERLINE}https://github.com/BradleyA/docker-security-infrastructure/issues/new${NORMAL}"  # 4.2.4

###  Production standard 5.3.550 Copyright                                                  # 3.550
echo -e "\n${BOLD}COPYRIGHT${NORMAL}"                                                       # 3.550
echo    "   Copyright (c) 2020 Bradley Allen"                                               # 3.550
echo    "   MIT License ${UNDERLINE}https://github.com/BradleyA/docker-security-infrastructure/blob/master/LICENSE${NORMAL}"  # 4.2.4

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
SCRIPT_NAME=$(head -2 "${0}" | awk '{printf $2}')  #  Different from ${COMMAND_NAME}=$(echo "${0}" | sed 's/^.*\///'), SCRIPT_NAME = includes Git repository directory and can be used any where in script (for dev, test teams)
SCRIPT_VERSION=$(head -2 "${0}" | awk '{printf $3}')
if [[ "${SCRIPT_NAME}" == "" ]] ; then SCRIPT_NAME="${0}" ; fi
if [[ "${SCRIPT_VERSION}" == "" ]] ; then SCRIPT_VERSION="v?.?" ; fi

#    GID
GROUP_ID=$(id -g)

###  Production standard 2.3.578 Log format (WHEN WHERE WHAT Version Line WHO UID:GID [TYPE] Message)
new_message() {  #  $1="${LINENO}"  $2="DEBUG INFO ERROR WARN"  $3="message"
  get_date_stamp
  echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${SCRIPT_NAME}[$$] ${BOLD}${BLUE}${SCRIPT_VERSION} ${PURPLE}${1}${NORMAL} ${USER} ${UID}:${GROUP_ID} ${BOLD}[${2}]${NORMAL}  ${3}"
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

#    Root is required to check certs
if ! [[ "$(id -u)" = 0 ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Use sudo ${COMMAND_NAME}" 1>&2
#    Help hint
  echo -e "\n\t${BOLD}${YELLOW}>>   SCRIPT MUST BE RUN AS ROOT   <<\n${NORMAL}"  1>&2
  exit 1
fi

###

###  Production standard 7.0 Default variable value
#    Order of precedence: CLI argument, environment variable, default code
if [[ $# -ge  1 ]]  ; then REGISTRY_HOST=${1} ; elif [[ "${REGISTRY_HOST}" == "" ]] ; then REGISTRY_HOST=${DEFAULT_REGISTRY_HOST} ; fi
if [[ $# -ge  2 ]]  ; then REGISTRY_PORT=${2} ; elif [[ "${REGISTRY_PORT}" == "" ]] ; then REGISTRY_PORT=${DEFAULT_REGISTRY_PORT} ; fi
if [[ $# -ge  3 ]]  ; then CLUSTER=${3}       ; elif [[ "${CLUSTER}" == "" ]] ; then CLUSTER=${DEFAULT_CLUSTER} ; fi
if [[ $# -ge  4 ]]  ; then DATA_DIR=${4}      ; elif [[ "${DATA_DIR}" == "" ]] ; then DATA_DIR=${DEFAULT_DATA_DIR} ; fi
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  Variable... REGISTRY_HOST >${REGISTRY_HOST}< REGISTRY_PORT >${REGISTRY_PORT}< CLUSTER >${CLUSTER}< DATA_DIR >${DATA_DIR}<" 1>&2 ; fi

#    Test <REGISTRY_PORT> for integer
if ! [[ "${REGISTRY_PORT}" =~ ^[0-9]+$ ]] ; then       #  requires [[   ]] or  [: =~: binary operator expected
   new_message "${LINENO}" "${RED}ERROR${WHITE}" "  <REGISTRY_PORT> is not an interger.  <REGISTRY_PORT> is set to '${REGISTRY_PORT}'" 1>&2
   exit 1
fi

#    Check if /etc/docker directory on system
if [[ ! -d /etc/docker ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  /etc/${YELLOW}docker${WHITE} directory not found." 1>&2
  exit 1
fi

#    Check if /etc/docker/certs.d directory on system
if [[ ! -d /etc/docker/certs.d ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  /etc/docker/${YELLOW}certs.d${NORMAL} directory not found." 1>&2
  exit 1
fi

#    Check if /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT} directory on system
if [[ ! -d "/etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}" ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  /etc/docker/certs.d/${YELLOW}${REGISTRY_HOST}:${REGISTRY_PORT}${NORMAL} directory not found." 1>&2
#    Help hint
  echo -e "\n\tOthers in directory /etc/docker/certs.d/ are listed below:${CYAN}${BOLD}"
  ls -1 /etc/docker/certs.d/ | sed 's/^/        /'
  echo -e "${NORMAL}"
  exit 1
fi

#    Check if 
if [[ ! -e "/etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt" ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/${YELLOW}ca.crt${NORMAL} file not found." 1>&2
  exit 1
fi

#    Get currect date in seconds
CURRENT_DATE_SECONDS=$(date '+%s')

#    Get currect date in seconds add 30 days
CURRENT_DATE_SECONDS_PLUS_30_DAYS=$(date '+%s' -d '+30 days')
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  Variable... CURRENT_DATE_SECONDS >${CURRENT_DATE_SECONDS}< CURRENT_DATE_SECONDS_PLUS_30_DAYS >${CURRENT_DATE_SECONDS_PLUS_30_DAYS=}<" 1>&2 ; fi

#    Set REGISTRY_HOST_CERT variable to host entered during the creation of certificates
REGISTRY_HOST_CERT=$(openssl x509 -in "/etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt" -noout -issuer | cut -d '/' -f 7 | cut -d '=' -f 2)
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  Variable... REGISTRY_HOST >${REGISTRY_HOST}< REGISTRY_HOST_CERT >${REGISTRY_HOST_CERT}<" 1>&2 ; fi

#    Get registry certificate expiration date from ca.crt
REGISTRY_EXPIRE_DATE=$(openssl x509 -in "/etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt" -noout -enddate | cut -d '=' -f 2)
REGISTRY_EXPIRE_SECONDS=$(date -d "${REGISTRY_EXPIRE_DATE}" '+%s')
if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  Variable... REGISTRY_EXPIRE_DATE >${REGISTRY_EXPIRE_DATE}< REGISTRY_EXPIRE_SECONDS >${REGISTRY_EXPIRE_SECONDS}<" 1>&2 ; fi

#    Check if ${REGISTRY_HOST_CERT} is NOT ${REGISTRY_HOST}
if ! [[ "${REGISTRY_HOST_CERT}" == "${REGISTRY_HOST}" ]] ; then
  new_message "${LINENO}" "${YELLOW}WARN${WHITE}" "  Certificate (/etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/${YELLOW}ca.crt)${NORMAL} is for ${CYAN}${REGISTRY_HOST_CERT}  ${BOLD}${RED}NOT${NORMAL}  ${REGISTRY_HOST} " 1>&2
#    Help hint
  echo -e "\n\t${BOLD}Use script ${YELLOW}create-registry-tls.sh${WHITE} to correct registry TLS.${NORMAL}"
fi

#    Check if certificate has expired
if [[ "${REGISTRY_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS}" ]] ; then

#    Check if certificate will expire in the next 30 day
  if [[ "${REGISTRY_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS_PLUS_30_DAYS}" ]] ; then
    echo -e "\n\tCertificate on ${BOLD}${CYAN}${LOCALHOST}${NORMAL},\n\t/etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/${YELLOW}ca.crt${NORMAL}:\n\t${BOLD}${GREEN}PASS${NORMAL} until ${BOLD}${YELLOW}${REGISTRY_EXPIRE_DATE}${NORMAL}"
  else
    new_message "${LINENO}" "${YELLOW}WARN${WHITE}" "  Certificate on ${LOCALHOST}, /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/${YELLOW}ca.crt${NORMAL}, ${BOLD}${YELLOW}EXPIRES${NORMAL} on ${BOLD}${YELLOW}${REGISTRY_EXPIRE_DATE}${NORMAL}" 1>&2
#    Help hint
    echo -e "\n\t${BOLD}Use script ${YELLOW}create-registry-tls.sh${WHITE} to update expired registry TLS.${NORMAL}"
  fi
else
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Certificate on ${LOCALHOST}, /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/${YELLOW}ca.crt${NORMAL}, ${BOLD}${RED}HAS EXPIRED${NORMAL} on ${BOLD}${YELLOW}${REGISTRY_EXPIRE_DATE}${NORMAL}" 1>&2
#    Help hint
  echo -e "\n\t${BOLD}Use script ${YELLOW}create-registry-tls.sh${WHITE} to update expired registry TLS.${NORMAL}"
fi

echo -e "\n\tVerify and correct file permissions."

#    Verify and correct file permissions for /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt
if [[ "$(stat -Lc %a "/etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt")" != 400 ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  File permissions for /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/${YELLOW}ca.crt${NORMAL} are not 400.  Correcting $(stat -Lc %a /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt) to 0400 file permissions." 1>&2
  chmod 0400 "/etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt"
fi

#    Verify and correct directory permissions for /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ directory
if [[ "$(stat -Lc %a "/etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/")" != 700 ]] ; then
  new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Directory permissions for /etc/docker/certs.d/${YELLOW}${REGISTRY_HOST}:${REGISTRY_PORT}${WHITE}/ are not 700.  Correcting $(stat -Lc %a /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/) to 700 directory permissions." 1>&2
  chmod 700 "/etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/"
fi

###  ${REGISTRY_HOST}
#    Check if ${LOCALHOST} is ${REGISTRY_HOST} running the private registry
if [[ "${LOCALHOST}" == "${REGISTRY_HOST}" ]] ; then

#    Check if private registry certificate directory
  if [[ ! -d "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/" ]] ; then
    new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Directory ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/${YELLOW}certs${WHITE}/ ${BOLD}${RED}NOT found${NORMAL}" 1>&2
    exit 1
  fi

#    Check if domain.crt registry certificate exists and has size greater than zero
  if [[ ! -s "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt" ]] ; then
    new_message "${LINENO}" "${RED}ERROR${WHITE}" "  File ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/${YELLOW}domain.crt${WHITE} does ${BOLD}${RED}NOT exist${NORMAL} or has file size equal to zero." 1>&2
#    Help hint
    echo -e "\n\t${BOLD}Use script ${YELLOW}create-registry-tls.sh${WHITE} to correct registry TLS.${NORMAL}"
    exit 1
  fi

#    Set REGISTRY_HOST_CERT variable to host entered during the creation of certificates
  REGISTRY_HOST_CERT=$(openssl x509 -in "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt" -noout -issuer | cut -d '/' -f 7 | cut -d '=' -f 2)
  if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  Variable... REGISTRY_HOST >${REGISTRY_HOST}< REGISTRY_HOST_CERT >${REGISTRY_HOST_CERT}<" 1>&2 ; fi
  if [[ ! "${REGISTRY_HOST_CERT}" == "${REGISTRY_HOST}" ]] ; then
    new_message "${LINENO}" "${RED}ERROR${WHITE}" "  The certificate, ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/${YELLOW}domain.crt${NORMAL}, is for host ${BOLD}${YELLOW}${REGISTRY_HOST_CERT} ${RED}NOT${NORMAL} ${REGISTRY_HOST}" 1>&2
#    Help hint
    echo -e "\n\t${BOLD}Use script ${YELLOW}create-registry-tls.sh${WHITE} to correct registry TLS.${NORMAL}"
    exit 1
  fi

#    Get registry certificate expiration date domain.crt
  REGISTRY_EXPIRE_DATE=$(openssl x509 -in "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt" -noout -enddate | cut -d '=' -f 2)
  REGISTRY_EXPIRE_SECONDS=$(date -d "${REGISTRY_EXPIRE_DATE}" '+%s')

#    Check if certificate has expired
  if [[ "${DEBUG}" == "1" ]] ; then new_message "${LINENO}" "DEBUG" "  REGISTRY_EXPIRE_DATE  >${REGISTRY_EXPIRE_DATE}<  REGISTRY_EXPIRE_SECONDS > CURRENT_DATE_SECONDS ${REGISTRY_EXPIRE_SECONDS} -gt ${CURRENT_DATE_SECONDS}" 1>&2 ; fi
  if [[ "${REGISTRY_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS}" ]] ; then
    echo -e "\n\tCertificate on ${BOLD}${CYAN}${LOCALHOST}${NORMAL},\n\t${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/${YELLOW}domain.crt${NORMAL}:\n\t${BOLD}${GREEN}PASS${NORMAL} until ${BOLD}${YELLOW}${REGISTRY_EXPIRE_DATE}${NORMAL}"
  else
    new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Certificate on ${LOCALHOST}, ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/${YELLOW}domain.crt${WHITE}, ${BOLD}${RED}HAS EXPIRED${NORMAL} on ${BOLD}${YELLOW}${REGISTRY_EXPIRE_DATE}${NORMAL}" 1>&2
#    Help hint
    echo -e "\n\t${BOLD}Use script ${YELLOW}create-registry-tls.sh${WHITE} to update expired registry TLS.${NORMAL}"
  fi

  echo -e "\n\tVerify and correct file permissions."

#    Verify and correct file permissions for ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt
  if [[ "$(stat -Lc %a "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt")" != 400 ]] ; then
    new_message "${LINENO}" "${RED}ERROR${WHITE}" "  File permissions for ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/${YELLOW}domain.crt${WHITE} are not 400.  Correcting $(stat -Lc %a  ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt) to 0400 file permissions." 1>&2
    chmod 0400 "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt"
  fi

#    Verify and correct file permissions for ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key
  if [[ "$(stat -Lc %a "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key")" != 400 ]] ; then
    new_message "${LINENO}" "${RED}ERROR${WHITE}" "  File permissions for ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/${YELLOW}domain.key${WHITE} are not 400.  Correcting $(stat -Lc %a  ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key) to 0400 file permissions." 1>&2
    chmod 0400 "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key"
  fi

#    Verify and correct directory permissions for ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/ directory
  if [[ "$(stat -Lc %a "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/")" != 700 ]] ; then
    new_message "${LINENO}" "${RED}ERROR${WHITE}" "  Directory permissions for ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/${YELLOW}certs${WHITE}/ are not 700.  Correcting $(stat -Lc %a ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/) to 700 directory permissions." 1>&2
    chmod 700 "${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/"
  fi
fi

#
new_message "${LINENO}" "${YELLOW}INFO${WHITE}" "  Operation finished..." 1>&2
###
