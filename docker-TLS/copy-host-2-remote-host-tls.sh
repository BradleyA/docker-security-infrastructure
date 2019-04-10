#!/bin/bash
# 	docker-TLS/copy-host-2-remote-host-tls.sh  3.225.660  2019-04-10T16:57:29.488909-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  six-rpi3b.cptx86.com 3.224  
# 	   completed testing after rewrite, ready for release 
### production standard 3.0 shellcheck
### production standard 5.3.160 Copyright
#       Copyright (c) 2019 Bradley Allen
#       MIT License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
### production standard 1.0 DEBUG variable
#       Order of precedence: environment variable, default code
if [ "${DEBUG}" == "" ] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
#	set -x
#	set -v
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
### production standard 7.0 Default variable value
DEFAULT_REMOTE_HOST="$(hostname -f)"    # local host
DEFAULT_USER_HOME="/home/"
DEFAULT_TLS_USER="${USER}"
### production standard 0.3.158 --help
display_help() {
echo -e "\n${NORMAL}${0} - Copy public, private keys and CA to remote host"
echo -e "\nUSAGE"
echo    "   ${0} [<REMOTE_HOST>]"
echo    "   ${0}  <REMOTE_HOST> [<USER_HOME>]"
echo    "   ${0}  <REMOTE_HOST>  <USER_HOME> [<TLS_USER>]"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION"
#       Displaying help DESCRIPTION in English en_US.UTF-8
echo    "A user with administration authority uses this script to copy host TLS CA,"
echo    "public, and private keys from <USER_HOME>/<TLS_USER>/.docker/docker-ca"
echo    "directory on this system to /etc/docker/certs.d/daemon directory on a local"
echo    "system or remote system.  To copy to this local system, do not enter a"
echo    "<REMOTE_HOST> option and this local system or local hostname will be used."
echo -e "\nThe administration user may receive password and/or passphrase prompts from a"
echo    "remote systen; running the following may stop the prompts in your cluster."
echo -e "\t${BOLD}ssh-copy-id <TLS_USER>@<REMOTE_HOST>${NORMAL}"
echo    "or"
echo -e "\t${BOLD}ssh-copy-id <TLS_USER>@<x.x.x.x>${NORMAL}"
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
echo    "   DEBUG       (default off '0')"
echo    "   USER_HOME   Location of user home directory (default ${DEFAULT_USER_HOME})"
echo -e "\nOPTIONS"
echo    "   REMOTE_HOST Remote host to copy certificates to (default ${DEFAULT_REMOTE_HOST})"
echo    "   USER_HOME   Location of user home directory (default ${DEFAULT_USER_HOME})"
echo    "               Many sites have different home directories (/u/north-office/)"
echo    "   TLS_USER    Administration user (default ${DEFAULT_TLS_USER})"
### production standard 6.3.170 Architecture tree
echo -e "\nARCHITECTURE TREE"   # STORAGE & CERTIFICATION
echo    "<<USER_HOME>/                             <-- Location of user home directory"         # production standard 6.3.167
echo    "   <USER-1>/.docker/                      <-- User docker cert directory"
echo -e "      └── docker-ca/                      <-- Working directory to create certs\n"
echo    "/etc/ "
echo    "   docker/ "
echo    "   └── certs.d/                           <-- Host docker cert directory"
echo    "       └── daemon/                        <-- Daemon cert directory"
echo    "           ├── ca.pem                     <-- Daemon tlscacert"
echo    "           ├── cert.pem                   <-- Daemon tlscert"
echo    "           └── key.pem                    <-- Daemon tlskey"
echo -e "\nDOCUMENTATION"
echo    "   https://github.com/BradleyA/docker-security-infrastructure/tree/master/docker-TLS"
echo -e "\nEXAMPLES"
echo -e "   Administration user copies TLS keys and CA to remote host, two.cptx86.com,\n   using default home directory, /home/, default administration user running\n   script.\n\t${BOLD}${0} two.cptx86.com${NORMAL}"
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

#       Default help and version arguments
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] ; then
        display_help | more
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
if [ $# -ge  2 ]  ; then USER_HOME=${2} ; elif [ "${USER_HOME}" == "" ] ; then USER_HOME="${DEFAULT_USER_HOME}" ; fi
USER_HOME=${USER_HOME}"/"
TLS_USER=${3:-${DEFAULT_TLS_USER}}
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  REMOTE_HOST >${REMOTE_HOST}< USER_HOME >${USER_HOME}< TLS_USER >${TLS_USER}<" 1>&2 ; fi

#	Check if admin user has home directory on system
if [ ! -d "${USER_HOME}${TLS_USER}" ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${TLS_USER} does not have a home directory on this system or ${TLS_USER} home directory is not ${USER_HOME}${TLS_USER}" 1>&2
	exit 1
fi

#	Check if ${USER_HOME}${TLS_USER}/.docker/docker-ca directory on system
if [ ! -d "${USER_HOME}${TLS_USER}/.docker/docker-ca" ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Default directory, ${BOLD}${USER_HOME}${TLS_USER}/.docker/docker-ca${NORMAL}, not on system." 1>&2
	echo -e "\tSee documentation for more information."
	exit 1
fi
cd "${USER_HOME}${TLS_USER}/.docker/docker-ca"

#	Prompt for ${REMOTE_HOST} if argement not entered
if [ -z "${REMOTE_HOST}" ] ; then
	echo -e "\n\t${BOLD}Enter remote host where TLS keys are to be copied:${NORMAL}"
	read REMOTE_HOST
fi

#	Check if ${REMOTE_HOST} string length is zero
if [ -z "${REMOTE_HOST}" ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Remote host is required." 1>&2
	echo -e "\tSee documentation for more information."
	exit 1
fi

#	Check if ${REMOTE_HOST}-priv-key.pem file on system
if ! [ -e "${USER_HOME}${TLS_USER}/.docker/docker-ca/${REMOTE_HOST}-priv-key.pem" ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  The ${REMOTE_HOST}-priv-key.pem file was not found in ${USER_HOME}${TLS_USER}/.docker/docker-ca." 1>&2
	#	Help hint
	echo -e "\tRunning create-host-tls.sh will create public and private keys."
	exit 1
fi

#	Check if ${REMOTE_HOST} is available on ssh port
echo -e "\n\t${BOLD}${TLS_USER}${NORMAL} user may receive password and passphrase prompts"
echo -e "\tfrom ${REMOTE_HOST}.  Running"
echo -e "\t${BOLD}ssh-copy-id ${TLS_USER}@${REMOTE_HOST}${NORMAL}"
echo -e "\tmay stop some of the prompts.\n"
if $(ssh ${TLS_USER}@${REMOTE_HOST} 'exit' >/dev/null 2>&1 ) ; then
#	Check if /etc/docker directory on ${REMOTE_HOST}
	if ! $(ssh -t ${TLS_USER}@${REMOTE_HOST} "test -d /etc/docker") ; then
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  /etc/docker directory missing, is docker installed on ${REMOTE_HOST}." 1>&2
		exit 1
	fi

#	Create working directory ~/.docker/docker-ca/${REMOTE_HOST}
	mkdir -p "${REMOTE_HOST}"
	cd "${REMOTE_HOST}"

#	Backup ${REMOTE_HOST}/etc/docker/certs.d
	FILE_DATE_STAMP=$(date +%Y-%m-%dT%H.%M.%S.%6N%z)
	echo -e "\n\tBacking up ${REMOTE_HOST}:/etc/docker/certs.d"
	echo -e "\tto $(pwd)\n\tRoot access required.\n"
	ssh -t ${TLS_USER}@${REMOTE_HOST} "sudo mkdir -p /etc/docker/certs.d/daemon ; cd /etc ; sudo tar -pcf /tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar ./docker/certs.d/daemon ; sudo chown ${TLS_USER}.${TLS_USER} /tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar ; chmod 0400 /tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar"
	scp -p ${TLS_USER}@${REMOTE_HOST}:/tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar .
	ssh -t ${TLS_USER}@${REMOTE_HOST} "rm -f /tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar"
	tar -pxf "${REMOTE_HOST}-${FILE_DATE_STAMP}.tar"

#	Check if /etc/docker/certs.d/daemon/${REMOTE_HOST}-priv-key.pem file exists on remote system
	if [ -e "./docker/certs.d/daemon/${REMOTE_HOST}-priv-key.pem" ] ; then
		echo -e "\n\t/etc/docker/certs.d/daemon/${REMOTE_HOST}-priv-key.pem"
		echo -e "\talready exists, ${BOLD}renaming existing keys${NORMAL} so new keys can be installed.\n"
		mv "./docker/certs.d/daemon/${REMOTE_HOST}-priv-key.pem" "./docker/certs.d/daemon/${REMOTE_HOST}-priv-key.pem-${FILE_DATE_STAMP}"
		mv "./docker/certs.d/daemon/${REMOTE_HOST}-cert.pem" "./docker/certs.d/daemon/${REMOTE_HOST}-cert.pem-${FILE_DATE_STAMP}"
		mv ./docker/certs.d/daemon/ca.pem "./docker/certs.d/daemon/ca.pem-${FILE_DATE_STAMP}"
		rm ./docker/certs.d/daemon/{cert,key}.pem
	fi

#	Create certification tar file and install it to ${REMOTE_HOST}
	chmod 0700 ./docker/certs.d/daemon
	cp -p "../${REMOTE_HOST}-priv-key.pem" ./docker/certs.d/daemon
	cp -p "../${REMOTE_HOST}-cert.pem" ./docker/certs.d/daemon
	cp -p ../ca.pem ./docker/certs.d/daemon
	cd ./docker/certs.d/daemon
	ln -s "${REMOTE_HOST}-priv-key.pem" key.pem
	ln -s "${REMOTE_HOST}-cert.pem" cert.pem
	cd ../../..
	FILE_DATE_STAMP=$(date +%Y-%m-%dT%H.%M.%S.%6N%z)
	tar -pcf "./${REMOTE_HOST}-${FILE_DATE_STAMP}.tar" ./docker/certs.d/daemon
	chmod 0600 "./${REMOTE_HOST}-${FILE_DATE_STAMP}.tar"
	scp -p "./${REMOTE_HOST}-${FILE_DATE_STAMP}.tar" "${TLS_USER}@${REMOTE_HOST}:/tmp"

#	Create remote directory /etc/docker/certs.d/daemon
#	This directory was selected to place dockerd TLS certifications because
#	docker registry stores it's TLS certifications in /etc/docker/certs.d.
	echo -e "\n\tCopying dockerd certification to ${REMOTE_HOST}"
	echo -e "\tRoot access required.\n"
	ssh -t ${TLS_USER}@${REMOTE_HOST} "cd /etc ; sudo tar -pxf /tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar ; sudo chmod 0700 /etc/docker ; sudo chmod 0700 /etc/docker/certs.d ; sudo chown -R root.root ./docker ; rm /tmp/${REMOTE_HOST}-${FILE_DATE_STAMP}.tar"
	cd ..

#	Remove working directory ~/.docker/docker-ca/${REMOTE_HOST}
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
