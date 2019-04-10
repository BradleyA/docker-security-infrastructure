#!/bin/bash
# 	docker-TLS/copy-user-2-remote-host-tls.sh  3.207.642  2019-04-09T20:59:31.173874-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  six-rpi3b.cptx86.com 3.206  
# 	   shellcheck 
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
DEFAULT_REMOTE_HOST=""
DEFAULT_TLS_USER="${USER}"
DEFAULT_USER_HOME="/home/"
DEFAULT_ADM_TLS_USER="${USER}"
### production standard 0.3.160 --help
display_help() {
echo -e "\n${NORMAL}${0} - Copy user TLS public, private keys and CA to remote host."
echo -e "\nUSAGE"
echo    "   ${0} [<REMOTE_HOST>]"
echo    "   ${0}  <REMOTE_HOST> [<TLS_USER>]"
echo    "   ${0}  <REMOTE_HOST>  <TLS_USER> [<USER_HOME>]"
echo    "   ${0}  <REMOTE_HOST>  <TLS_USER>  <USER_HOME> [<ADM_TLS_USER>]"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION"
#       Displaying help DESCRIPTION in English en_US.UTF-8
echo    "A user with administration authority uses this script to copy user TLS CA,"
echo    "public, and private keys from <USER_HOME>/<TLS_USER>/.docker/docker-ca"
echo    "directory on this system to <USER_HOME>/<TLS_USER>/.docker/docker-ca remote"
echo    "system."
# >>>   FUTURE  echo    "To copy to this local system, do not enter a"
# >>>   FUTURE  echo    "<REMOTE_HOST> option and this local system or local hostname will be used."
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
echo    "   REMOTE_HOST Remote host to copy certificates to (required)"
echo    "   TLS_USER    User requiring new TLS keys on remote host (default ${DEFAULT_TLS_USER})"
echo    "   USER_HOME   Location of user home directory (default ${DEFAULT_USER_HOME})"
echo    "               Many sites have different home directories (/u/north-office/)"
echo    "   ADM_TLS_USER Administrator user creating TLS keys (default ${DEFAULT_ADM_TLS_USER})"
### production standard 6.3.170 Architecture tree
echo -e "\nARCHITECTURE TREE"   # STORAGE & CERTIFICATION
echo    "<<USER_HOME>/                             <-- Location of user home directory"         # production standard 6.3.167
echo    "   <USER-1>/.docker/                      <-- User docker cert directory"
echo    "      ├── ca.pem                          <-- Symbolic link to user tlscacert"
echo    "      ├── cert.pem                        <-- Symbolic link to user tlscert"
echo    "      ├── key.pem                         <-- Symbolic link to user tlskey"
echo    "      └── docker-ca/                      <-- Working directory to create certs"
# >>>	FUTURE	echo    "/usr/local/data/                          <-- <DATA_DIR>"
# >>>	FUTURE	echo    "   <CLUSTER>/                             <-- <CLUSTER>"
# >>>	FUTURE	echo    "   └── docker-accounts/                   <-- Docker TLS certs"
# >>>	FUTURE	echo    "       ├── <HOST-1>/                      <-- Host in cluster"
# >>>	FUTURE	echo    "       │   ├── <USER-1>/                  <-- User TLS certs directory"
# >>>	FUTURE	echo    "       │   │   ├── ca.pem      FUTURE     <-- User tlscacert"
# >>>	FUTURE	echo    "       │   │   ├── cert.pem    FUTURE     <-- User tlscert"
# >>>	FUTURE	echo    "       │   │   └── key.pem     FUTURE     <-- User tlskey"
# >>>	FUTURE	echo    "       │   └── <USER-2>/                  <-- User TLS certs directory"
# >>>	FUTURE	echo    "       └── <HOST-2>/                      <-- Host in cluster"
echo -e "\nDOCUMENTATION"
echo    "   https://github.com/BradleyA/docker-security-infrastructure/tree/master/docker-TLS"
echo -e "\nEXAMPLES"
echo    "   Administrator copies TLS keys and CA to remote host, two.cptx86.com, for"
echo    "   user bob, using local home directory, /u/north-office/, administrator user,"
echo    "   uadmin."
echo -e "\t${BOLD}${0} two.cptx86.com bob /u/north-office/ uadmin${NORMAL}"
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
TLS_USER=${2:-${DEFAULT_TLS_USER}}
#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  3 ]  ; then USER_HOME=${3} ; elif [ "${USER_HOME}" == "" ] ; then USER_HOME="${DEFAULT_USER_HOME}" ; fi
ADM_TLS_USER=${4:-${DEFAULT_ADM_TLS_USER}}
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  REMOTE_HOST >${REMOTE_HOST}< TLS_USER >${TLS_USER}< USER_HOME >${USER_HOME}< ADM_TLS_USER >${ADM_TLS_USER}<" 1>&2 ; fi

#	Check if admin user has home directory on system
if [ ! -d "${USER_HOME}${ADM_TLS_USER}" ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${ADM_TLS_USER} does not have a home directory on this system or ${ADM_TLS_USER} home directory is not ${USER_HOME}${ADM_TLS_USER}" 1>&2
	exit 1
fi

#	Check if ${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca directory on system
if [ ! -d "${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca" ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Default directory, ${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca, not on system." 1>&2
	#	Help hint
	echo -e "\n\tRunning create-site-private-public-tls.sh will create directories"
	echo -e "\tand site private and public keys.  Then run sudo"
	echo -e "\tcreate-new-openssl.cnf-tls.sh to modify openssl.cnf file."
	exit 1
fi

#	Check if ${TLS_USER}-user-priv-key.pem file on system
if ! [ -e "${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca/${TLS_USER}-user-priv-key.pem" ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  The ${TLS_USER}-user-priv-key.pem file was not found in ${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca." 1>&2
	#	Help hint
	echo -e "\n\tRunning create-user-tls.sh will create public and private keys."
	exit 1
fi

#	Prompt for ${REMOTE_HOST} if argement not entered
if [ -z "${REMOTE_HOST}" ] ; then
	echo    "Enter remote host where TLS keys are to be copied:"
	read REMOTE_HOST
fi

#	Check if ${REMOTE_HOST} string length is zero
if [ -z "${REMOTE_HOST}" ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Remote host is required." 1>&2
	exit 1
fi

#	Check if ${REMOTE_HOST} is available on ssh port
if $(ssh "${REMOTE_HOST}" 'exit' >/dev/null 2>&1 ) ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  ${ADM_TLS_USER} user may receive password and passphrase prompt from ${REMOTE_HOST}.  Running ${BOLD}ssh-copy-id ${ADM_TLS_USER}@${REMOTE_HOST}${NORMAL} may stop some of the prompts." 1>&2
	ssh -t ${ADM_TLS_USER}@${REMOTE_HOST} " cd ~${TLS_USER} " || { get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${TLS_USER} user does not have home directory on ${REMOTE_HOST}"  ; exit 1; }
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Create directory, change file permissions, and copy TLS keys to ${TLS_USER}@${REMOTE_HOST}." 1>&2
	cd "${USER_HOME}${ADM_TLS_USER}/.docker/docker-ca"
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
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Transfer TLS keys to ${TLS_USER}@${REMOTE_HOST}." 1>&2
	scp -p "./${TLS_USER}-${REMOTE_HOST}-${FILE_DATE_STAMP}.tar" ${ADM_TLS_USER}@${REMOTE_HOST}:/tmp

#	Check if ${TLS_USER} == ${ADM_TLS_USER} because sudo is not required for user copying their certs
	if [ "${TLS_USER}" == "${ADM_TLS_USER}" ] ; then
		ssh -t ${ADM_TLS_USER}@${REMOTE_HOST} " cd ~${TLS_USER} ; tar -xf /tmp/${TLS_USER}-${REMOTE_HOST}-${FILE_DATE_STAMP}.tar ; rm /tmp/${TLS_USER}-${REMOTE_HOST}-${FILE_DATE_STAMP}.tar ; chown -R ${TLS_USER}.${TLS_USER} .docker "
	else
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  ${ADM_TLS_USER} sudo password is required to install other user, ${TLS_USER}, certs on host, ${REMOTE_HOST}." 1>&2
		ssh -t ${ADM_TLS_USER}@${REMOTE_HOST} "cd ~${TLS_USER}/.. ; sudo tar -pxf /tmp/${TLS_USER}-${REMOTE_HOST}-${FILE_DATE_STAMP}.tar -C ${TLS_USER} ; sudo rm /tmp/${TLS_USER}-${REMOTE_HOST}-${FILE_DATE_STAMP}.tar ; sudo chown -R ${TLS_USER}.${TLS_USER} ${TLS_USER}/.docker "
	fi
	cd ..
	rm -rf "${TLS_USER}"

#	Display instructions about cert environment variables
	#	Help hint
	echo -e "\nTo set environment variables permanently, add them to the user's"
	echo -e "\t.bashrc.  These environment variables will be set each time the user"
	echo -e "\tlogs into the computer system.  Edit your .bashrc file (or the"
	echo -e "\tcorrect shell if different) and prepend the following two lines."
	echo -e "\texport DOCKER_HOST=tcp://$(hostname -f):2376"
	echo -e "\texport DOCKER_TLS_VERIFY=1"
#
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
	exit 0
else
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${REMOTE_HOST} not responding on ssh port." 1>&2
	exit 1
fi

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
