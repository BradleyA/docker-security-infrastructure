#!/bin/bash
# 	docker-TLS/copy-host-2-remote-host-tls.sh  3.438.916  2019-09-04T21:48:43.119624-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.437  
# 	   docker-TLS/copy-host-2-remote-host-tls.sh  upgraded  Production standard 1.3.496 DEBUG variable 
# 	docker-TLS/copy-host-2-remote-host-tls.sh  3.280.747  2019-06-10T12:43:31.498537-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.279  
# 	   update copy-host-2-remote-host-tls.sh while trying to reproduce incident docker-TLS/check-{host,user}-tls.sh - which one should check if the ca.pem match #49 
#86# docker-TLS/copy-host-2-remote-host-tls.sh - Copy public, private keys and CA to remote host
###  Production standard 3.0 shellcheck
###  Production standard 5.1.160 Copyright
#    Copyright (c) 2019 Bradley Allen
#    MIT License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
###  Production standard 1.3.496 DEBUG variable
#    Order of precedence: environment variable, default code
if [[ "${DEBUG}" == ""  ]] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
if [[ "${DEBUG}" == "2" ]] ; then set -x    ; fi   # Print trace of simple commands before they are executed
if [[ "${DEBUG}" == "3" ]] ; then set -v    ; fi   # Print shell input lines as they are read
if [[ "${DEBUG}" == "4" ]] ; then set -e    ; fi   # Exit command has a non-zero exit status
#
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
###  Production standard 7.0 Default variable value
DEFAULT_REMOTE_HOST="$(hostname -f)"    # local host
DEFAULT_WORKING_DIRECTORY=~/.docker/docker-ca
DEFAULT_CA_CERT="ca.pem"
DEFAULT_CERT_DAEMON_DIR="/etc/docker/certs.d/daemon/"
###  Production standard 8.0 --usage
display_usage() {
echo -e "\n${NORMAL}${0} - Copy public, private keys and CA to remote host"
echo -e "\nUSAGE"
echo    "   ${0} [<REMOTE_HOST>]"
echo    "   ${0}  <REMOTE_HOST> [<WORKING_DIRECTORY>]"
echo -e "   ${0}  <REMOTE_HOST>  <WORKING_DIRECTORY> [<CERT_DAEMON_DIR>]\n"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--usage | -usage | -u]"
echo    "   ${0} [--version | -version | -v]"
}
###  Production standard 0.1.158 --help
display_help() {
display_usage
#    Displaying help DESCRIPTION in English en_US.UTF-8
echo -e "\nDESCRIPTION"
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
echo    "   DEBUG             (default off '0')"
echo    "   CA_CERT           File name of certificate (default ${DEFAULT_CA_CERT})"
echo    "   WORKING_DIRECTORY Absolute path for working directory"
echo    "                     (default ${DEFAULT_WORKING_DIRECTORY})"
echo -e "\nOPTIONS"
echo    "   REMOTE_HOST       Remote host to copy certificates to"
echo    "                     (default ${DEFAULT_REMOTE_HOST})"
echo    "   WORKING_DIRECTORY Absolute path for working directory"
echo    "                     (default ${DEFAULT_WORKING_DIRECTORY})"
echo    "   CERT_DAEMON_DIR   dockerd certification directory"
echo    "                     (default ${DEFAULT_CERT_DAEMON_DIR})"
### production standard 6.1.177 Architecture tree
echo -e "\nARCHITECTURE TREE"   # STORAGE & CERTIFICATION
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
echo -e "\nDOCUMENTATION"
echo    "   https://github.com/BradleyA/docker-security-infrastructure/tree/master/docker-TLS"
echo -e "\nEXAMPLES"
echo -e "   Administration user copies TLS keys and CA to remote host, two.cptx86.com.\n\t${BOLD}${0} two.cptx86.com${NORMAL}"
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
SCRIPT_NAME=$(head -2 "${0}" | awk '{printf $2}')
SCRIPT_VERSION=$(head -2 "${0}" | awk '{printf $3}')

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

#       INFO
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Started..." 1>&2

#       DEBUG
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Name_of_command >${0}< Name_of_arg1 >${1}< Name_of_arg2 >${2}< Name_of_arg3 >${3}<  Version of bash ${BASH_VERSION}" 1>&2 ; fi

###
REMOTE_HOST=${1:-${DEFAULT_REMOTE_HOST}}
#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  2 ]  ; then WORKING_DIRECTORY=${2} ; elif [ "${WORKING_DIRECTORY}" == "" ] ; then WORKING_DIRECTORY="${DEFAULT_WORKING_DIRECTORY}" ; fi
CERT_DAEMON_DIR=${3:-${DEFAULT_CERT_DAEMON_DIR}}
#       Order of precedence: environment variable, default code
if [ "${CA_CERT}" == "" ] ; then CA_CERT="${DEFAULT_CA_CERT}" ; fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  REMOTE_HOST >${REMOTE_HOST}< WORKING_DIRECTORY >${WORKING_DIRECTORY}< CERT_DAEMON_DIR >${CERT_DAEMON_DIR}<  CA_CERT >${CA_CERT}<" 1>&2 ; fi

#	Check if ${WORKING_DIRECTORY} directory on system
if [ ! -d "${WORKING_DIRECTORY}" ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Default directory, ${BOLD}${WORKING_DIRECTORY}${NORMAL}, not on system." 1>&2
        #       Help hint
        echo -e "\n\tRunning create-site-private-public-tls.sh will create directories"
        echo -e "\tand site private and public keys.  Then run sudo"
        echo -e "\tcreate-new-openssl.cnf-tls.sh to modify openssl.cnf file."
        echo -e "\t${BOLD}See DOCUMENTATION link in '${0} --help' for more information.${NORMAL}"
	exit 1
fi

#	Check if ${REMOTE_HOST}-priv-key.pem file on system
if ! [ -e "${WORKING_DIRECTORY}/${REMOTE_HOST}-priv-key.pem" ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  The ${REMOTE_HOST}-priv-key.pem file was not found in ${WORKING_DIRECTORY}" 1>&2
	#	Help hint
	echo -e "\tRunning create-host-tls.sh will create public and private keys."
	exit 1
fi

cd "${WORKING_DIRECTORY}"
#	Check if ${REMOTE_HOST} is available on ssh port
echo -e "\n\t${BOLD}${USER}${NORMAL} user may receive password and passphrase prompts"
echo -e "\tfrom ${REMOTE_HOST}.  Running"
echo -e "\t${BOLD}ssh-copy-id ${USER}@${REMOTE_HOST}${NORMAL}"
echo -e "\tmay stop some of the prompts.\n"
if $(ssh ${REMOTE_HOST} 'exit' >/dev/null 2>&1 ) ; then
#	Check if /etc/docker directory on ${REMOTE_HOST}
	if ! $(ssh -t ${REMOTE_HOST} "test -d /etc/docker") ; then
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  /etc/docker directory missing, is docker installed on ${REMOTE_HOST}." 1>&2
		exit 1
	fi

#	Create working directory ${WORKING_DIRECTORY}/${REMOTE_HOST}
	mkdir -p "${REMOTE_HOST}"
	cd "${REMOTE_HOST}"

#	Backup ${REMOTE_HOST}:${CERT_DAEMON_DIR}/..
	FILE_DATE_STAMP=$(date +%Y-%m-%dT%H.%M.%S.%6N%z)
	echo -e "\n\tBacking up ${REMOTE_HOST}:${CERT_DAEMON_DIR}/.."
	echo -e "\tto $(pwd)\n\tRoot access required.\n"
	ssh -t ${USER}@${REMOTE_HOST} "sudo mkdir -p ${CERT_DAEMON_DIR} ;


 cd /etc ; sudo tar -pcf /tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar ./docker/certs.d/daemon ; sudo chown ${USER}.${USER} /tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar ; chmod 0400 /tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar"
	scp -p ${USER}@${REMOTE_HOST}:/tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar .
	ssh -t ${USER}@${REMOTE_HOST} "rm -f /tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar"
	tar -pxf "${REMOTE_HOST}-${FILE_DATE_STAMP}.tar"

#	Check if /etc/docker/certs.d/daemon/${REMOTE_HOST}-priv-key.pem file exists on remote system
	if [ -e "./docker/certs.d/daemon/${REMOTE_HOST}-priv-key.pem" ] ; then
		echo -e "\n\t/etc/docker/certs.d/daemon/${REMOTE_HOST}-priv-key.pem"
		echo -e "\talready exists, ${BOLD}renaming existing keys${NORMAL} so new keys can be installed.\n"
		mv "./docker/certs.d/daemon/${REMOTE_HOST}-priv-key.pem" "./docker/certs.d/daemon/${REMOTE_HOST}-priv-key.pem_${FILE_DATE_STAMP}"
		mv "./docker/certs.d/daemon/${REMOTE_HOST}-cert.pem" "./docker/certs.d/daemon/${REMOTE_HOST}-cert.pem_${FILE_DATE_STAMP}"
		mv "./docker/certs.d/daemon/${CA_CERT}" "./docker/certs.d/daemon/${CA_CERT}_${FILE_DATE_STAMP}"
		rm ./docker/certs.d/daemon/{cert,key}.pem
	fi

#	Create certification tar file and install it to ${REMOTE_HOST}
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
	scp -p "./${REMOTE_HOST}-${FILE_DATE_STAMP}.tar" "${USER}@${REMOTE_HOST}:/tmp"

#	Create remote directory /etc/docker/certs.d/daemon
#	This directory was selected to place dockerd TLS certifications because
#	docker registry stores it's TLS certifications in /etc/docker/certs.d.
	echo -e "\n\tCopying dockerd certification to ${REMOTE_HOST}"
	echo -e "\tRoot access required.\n"
	ssh -t ${USER}@${REMOTE_HOST} "cd /etc ; sudo tar -pxf /tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar ; sudo chmod 0700 /etc/docker ; sudo chmod 0700 /etc/docker/certs.d ; sudo chown -R root.root ./docker ; rm /tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar"
	cd ..

#	Remove working directory ${WORKING_DIRECTORY}/${REMOTE_HOST}
	rm -rf "${REMOTE_HOST}"

#       Display instructions about certification environment variables
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
	get_date_stamp ; echo -e "\n${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
	exit 0
else
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${REMOTE_HOST} not responding on ssh port." 1>&2
	exit 1
fi

# >>>	May want to create a version of this script that automates this process for SRE tools,
# >>>	but keep this script for users to run manually,
# >>>	open ticket and remove this comment 

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
