#!/bin/bash
# 	docker-TLS/check-ca-tls.sh  3.294.761  2019-07-21T10:23:02.299570-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.293  
# 	   update DESCRIPTION and EXAMPLES 
# 	docker-TLS/check-ca-tls.sh  3.293.760  2019-07-20T19:51:00.914284-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.292  
# 	   complete, release to production close #56 
### production standard 3.0 shellcheck
### production standard 5.1.160 Copyright
#       Copyright (c) 2019 Bradley Allen
#       MIT License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
### production standard 1.0 DEBUG variable
#       Order of precedence: environment variable, default code
if [ "${DEBUG}" == "" ] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
#       set -x
#       set -v
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
### production standard 7.0 Default variable value
DEFAULT_CERT_DIR="${HOME}/.docker"
DEFAULT_CA_CERT="ca.pem"
### production standard 8.0 --usage
display_usage() {
echo -e "\n${NORMAL}${0} - start and end dates of ${DEFAULT_CERT_DIR}/${DEFAULT_CA_CERT}"
echo -e "\nUSAGE"
echo    "   ${0} [<CERT_DIR>]"
echo -e "   ${0}  <CERT_DIR> [<CA_CERT>]\n"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--usage | -usage | -u]"
echo    "   ${0} [--version | -version | -v]"
}
### production standard 0.1.166 --help
display_help() {
display_usage
#       Displaying help DESCRIPTION in English en_US.UTF-8
echo -e "\nDESCRIPTION"
echo    "Check start and end dates of a Docker CA in <CERT_DIR> (default:"
echo    "${DEFAULT_CERT_DIR}).  This script will create a copy of the"
echo    "<CA_CERT> file with the start and end dates appended to the file name in"
echo    "${DEFAULT_CERT_DIR}."
echo -e "\nAn administrator may receive password and/or passphrase prompts from a"
echo    "remote systen; running the following may stop the prompts in your cluster."
echo -e "\t${BOLD}ssh-copy-id <TLS_USER>@<REMOTE_HOST>${NORMAL}"
echo    "or"
echo -e "\t${BOLD}ssh-copy-id <TLS_USER>@<192.168.x.x>${NORMAL}"
echo    "If that does not resolve the prompting challenge then review the man pages for"
echo    "ssh-agent and ssh-add before entering the following in a terminal window."
echo -e "\t${BOLD}eval \$(ssh-agent)${NORMAL}"
echo -e "\t${BOLD}ssh-add${NORMAL}"
### production standard 4.0 Documentation Language
#       Displaying help DESCRIPTION in French fr_CA.UTF-8, fr_FR.UTF-8, fr_CH.UTF-8
if [ "${LANG}" == "fr_CA.UTF-8" ] || [ "${LANG}" == "fr_FR.UTF-8" ] || [ "${LANG}" == "fr_CH.UTF-8" ] ; then
        echo -e "\n--> ${LANG}"
        echo    "<votre aide va ici>" # your help goes here
        echo    "Souhaitez-vous traduire la section description?" # Do you want to translate the description section?
elif ! [ "${LANG}" == "en_US.UTF-8" ] ; then
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Your language, ${LANG}, is not supported.  Would you like to translate the description section?" 1>&2
fi
echo -e "\nENVIRONMENT VARIABLES"
echo    "If using the bash shell, enter; 'export DEBUG=1' on the command line to set"
echo    "the DEBUG environment variable to '1' (0 = debug off, 1 = debug on).  Use the"
echo    "command, 'unset DEBUG' to remove the exported information from the DEBUG"
echo    "environment variable.  You are on your own defining environment variables if"
echo    "you are using other shells."
echo    "   DEBUG           (default off '0')"
echo    "   CERT_DIR        Certification directory (default '${DEFAULT_CERT_DIR}')"
echo    "   CA_CERT         Name of CA certificate (default '${DEFAULT_CA_CERT}')"
echo -e "\nOPTIONS"
echo    "Order of precedence: CLI options, environment variable, default code."
echo    "   CERT_DIR        Certification directory (default '${DEFAULT_CERT_DIR}')"
echo    "   CA_CERT         Name of CA certificate (default '${DEFAULT_CA_CERT}')"
### production standard 6.1.177 Architecture tree
echo -e "\nARCHITECTURE TREE"   # STORAGE & CERTIFICATION
echo    "<USER_HOME>/                               <-- Location of user home directory"
echo    "└── <USER-1>/.docker/                      <-- User docker cert directory"
echo    "    └── ca.pem                             <-- User tlscacert or symbolic link"
echo    "/etc/ "
echo    "└── docker/ "
echo    "    └── certs.d/                           <-- Host docker cert directory"
echo    "        ├── daemon/                        <-- Daemon cert directory"
echo    "        │   └── ca.pem                     <-- Daemon tlscacert"
echo    "        └── <REGISTRY_HOST>:<REGISTRY_PORT>/ < Registry cert directory"
echo -e "            └── ca.crt                     <-- Daemon registry domain cert\n"
echo -e "\nDOCUMENTATION"
echo    "   https://github.com/BradleyA/   <<URL to online repository README>>"
echo -e "\nEXAMPLES"
echo    "   User checking start and end dates of their Docker CA in \$HOME/.docker."
echo -e "\t${BOLD}${0}${NORMAL}"
echo    "   To loop through a list of hosts in a cluster a user could use,"
echo    "(https://github.com/BradleyA/Linux-admin/tree/master/cluster-command)"
echo -e "\t${BOLD}cluster-command.sh special '${0}'${NORMAL}"
echo    "   To loop through a list of hosts in a cluster an administrator could check the"
echo    "   start and end dates of Docker CA for user sam in /home/sam/.docker."
echo -e "\t${BOLD}cluster-command.sh special 'sudo ${0} /home/sam/.docker ca.pem'${NORMAL}"
echo    "   Administrator checking start and end dates of other certificates by using:"
echo -e "\t${BOLD}sudo ${0} <CERT_DIR> <CA_CERT>${NORMAL}"
echo -e "   Administrator checking a Docker daemon CA by including sudo.  To use"
echo    "   ${0} on a remote hosts (one-rpi3b.cptx86.com) with ssh port"
echo    "   of 12323 as uadmin user;"
echo -e "\t${BOLD}ssh -tp 12323 uadmin@one-rpi3b.cptx86.com 'sudo ${0} /etc/docker/certs.d/daemon ca.pem'${NORMAL}"
echo -e "   Administrator checking a Docker private registry CA by including sudo.  To"
echo    "   use ${0} on a remote hosts (two-rpi3b.cptx86.com) with"
echo    "   default ssh port as uadmin user;"
echo -e "\t${BOLD}ssh -t uadmin@two-rpi3b.cptx86.com 'sudo ${0} /etc/docker/certs.d/two.cptx86.com:17315 ca.crt'${NORMAL}"
}

#       Date and time function ISO 8601
get_date_stamp() {
DATE_STAMP=$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)
TEMP=$(date +%Z)
DATE_STAMP="${DATE_STAMP} (${TEMP})"
}

#       Fully qualified domain name FQDN hostname
LOCALHOST=$(hostname -f)

#       Version
SCRIPT_NAME=$(head -2 "${0}" | awk {'printf $2'})
SCRIPT_VERSION=$(head -2 "${0}" | awk {'printf $3'})

#       UID and GID
USER_ID=$(id -u)
GROUP_ID=$(id -g)

#       Added line because USER is not defined in crobtab jobs
if ! [ "${USER}" == "${LOGNAME}" ] ; then  USER=${LOGNAME} ; fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Setting USER to support crobtab...  USER >${USER}<  LOGNAME >${LOGNAME}<" 1>&2 ; fi

#       Default help, usage, and version arguments
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] ; then
        display_help | more
        exit 0
fi
if [ "$1" == "--usage" ] || [ "$1" == "-usage" ] || [ "$1" == "usage" ] || [ "$1" == "-u" ] ; then
        display_usage | more
        exit 0
fi
if [ "$1" == "--version" ] || [ "$1" == "-version" ] || [ "$1" == "version" ] || [ "$1" == "-v" ] ; then
        echo "${SCRIPT_NAME} ${SCRIPT_VERSION}"
        exit 0
fi

### production standard 2.0 log format (WHEN WHERE WHAT Version Line WHO UID:GID [TYPE] Message)
#       INFO
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Started..." 1>&2

#       DEBUG
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Name_of_command >${0}< Name_of_arg1 >${1}< Name_of_arg2 >${2}< Name_of_arg3 >${3}<  Version of bash ${BASH_VERSION}" 1>&2 ; fi

### production standard 7.0 Default variable value
#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  1 ]  ; then CERT_DIR=${1} ; elif [ "${CERT_DIR}" == "" ] ; then CERT_DIR=${DEFAULT_CERT_DIR} ; fi
if [ $# -ge  2 ]  ; then CA_CERT=${2} ; elif [ "${CA_CERT}" == "" ] ; then CA_CERT=${DEFAULT_CA_CERT} ; fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... CERT_DIR >${CERT_DIR}< CA_CERT >${CA_CERT}<" 1>&2 ; fi

#
if [ -s "${CERT_DIR}/${CA_CERT}" ] ; then
	#       Get certificate start and expiration date of ${CA_CERT} file
	CA_CERT_START_DATE=$(openssl x509 -in "${CERT_DIR}/${CA_CERT}" -noout -startdate | cut -d '=' -f 2)
	CA_CERT_START_DATE_2=$(date -u -d"${CA_CERT_START_DATE}" +%g%m%d%H%M.%S)
	CA_CERT_START_DATE=$(date -u -d"${CA_CERT_START_DATE}" +%Y-%m-%dT%H:%M:%S%z)
	CA_CERT_EXPIRE_DATE=$(openssl x509 -in "${CERT_DIR}/${CA_CERT}" -noout -enddate | cut -d '=' -f 2)
	CA_CERT_EXPIRE_DATE=$(date -u -d"${CA_CERT_EXPIRE_DATE}" +%Y-%m-%dT%H:%M:%S%z)
	cp -f -p "${CERT_DIR}/${CA_CERT}" "${CERT_DIR}/${CA_CERT}_${CA_CERT_START_DATE}_${CA_CERT_EXPIRE_DATE}"
	chmod 0400 "${CERT_DIR}/${CA_CERT}_${CA_CERT_START_DATE}_${CA_CERT_EXPIRE_DATE}"
	touch -m -t "${CA_CERT_START_DATE_2}" "${CERT_DIR}/${CA_CERT}_${CA_CERT_START_DATE}_${CA_CERT_EXPIRE_DATE}" "${CERT_DIR}/${CA_CERT}"
	ls -l ${CERT_DIR}/${CA_CERT}*
else
#	Help hint
	echo "Cannot access ${CERT_DIR}/${CA_CERT}: Permission denied or No such file or directory"
fi

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
