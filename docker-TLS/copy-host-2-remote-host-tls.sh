#!/bin/bash
# 	docker-TLS/copy-host-2-remote-host-tls.sh  3.102.463  2018-12-13T16:26:15.232216-06:00 (CST)  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.101  
# 	   copy-host-2-remote-host-tls.sh  add support for environment variable USERHOME close #32 
#
### copy-host-2-remote-host-tls.sh - Copy public, private keys and CA to remote host
#       Order of precedence: environment variable, default code
if [ "${DEBUG}" == "" ] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
#	set -x
#	set -v
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
###
display_help() {
echo -e "\n${NORMAL}${0} - Copy public, private keys and CA to remote host"
echo -e "\nUSAGE\n   ${0} <REMOTEHOST> [<USERHOME>]"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION\nA user with administration authority uses this script to"
echo    "copy host TLS CA, public, and private keys from"
echo    "${USERHOME}${ADMTLSUSER}/.docker/docker-ca directory on this system to"
echo    "/etc/docker/certs.d directory on a remote system."
echo -e "\nThe administration user may receive password and/or passphrase prompts from a"
echo    "remote systen; running the following may stop the prompts in your cluster."
echo    "   ssh-copy-id <admin-user>@x.x.x.x"
echo -e "\nEnvironment Variables"
echo    "If using the bash shell, enter; 'export DEBUG=1' on the command line to set"
echo    "the DEBUG environment variable to '1' (0 = debug off, 1 = debug on).  Use the"
echo    "command, 'unset DEBUG' to remove the exported information from the DEBUG"
echo    "environment variable.  You are on your own defining environment variables if"
echo    "you are using other shells."
echo    "   DEBUG       (default '0')"
echo    "   USERHOME    (default /home/)"
echo -e "\nOPTIONS"
echo    "   REMOTEHOST   remote host to copy certificates to"
echo    "   USERHOME     location of administration user directory, default is /home/"
echo    "      Many sites have different home directories (/u/north-office/)"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS"
echo -e "\nEXAMPLES\n   ${0} two.cptx86.com\n\n   Administration user copies TLS keys and CA to remote host, two.cptx86.com,"
echo    "   using default home directory, /home/, default administration user running"
echo -e "   script.\n"
echo -e "   ${0} two.cptx86.com /u/north-office/ uadmin\n\n   Administration user copies TLS keys and CA to remote host, two.cptx86.com,"
echo    "   using local home directory, /u/north-office/, administrator account, uadmin."
#       After displaying help in english check for other languages
if ! [ "${LANG}" == "en_US.UTF-8" ] ; then
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  ${LANG}, is not supported, Would you like to help translate?" 1>&2
#       elif [ "${LANG}" == "fr_CA.UTF-8" ] ; then
#               get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Display help in ${LANG}" 1>&2
#       else
#               get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Your language, ${LANG}, is not supported.  Would you like to translate?" 1>&2
fi
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
REMOTEHOST=$1
#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  2 ]  ; then USERHOME=${2} ; elif [ "${USERHOME}" == "" ] ; then USERHOME="/home/" ; fi
USERHOME=${USERHOME}"/"
ADMTLSUSER=${3:-${USER}} # design for futrue use
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  REMOTEHOST >${REMOTEHOST}< USERHOME >${USERHOME}< ADMTLSUSER >${ADMTLSUSER}<" 1>&2 ; fi

#	Check if admin user has home directory on system
if [ ! -d ${USERHOME}${ADMTLSUSER} ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${ADMTLSUSER} does not have a home directory on this system or ${ADMTLSUSER} home directory is not ${USERHOME}${ADMTLSUSER}" 1>&2
	exit 1
fi

#	Check if ${USERHOME}${ADMTLSUSER}/.docker/docker-ca directory on system
if [ ! -d ${USERHOME}${ADMTLSUSER}/.docker/docker-ca ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Default directory, ${BOLD}${USERHOME}${ADMTLSUSER}/.docker/docker-ca${NORMAL}, not on system." 1>&2
	echo -e "\tSee documentation for more information."
	exit 1
fi
cd ${USERHOME}${ADMTLSUSER}/.docker/docker-ca

#	Prompt for ${REMOTEHOST} if argement not entered
if [ -z ${REMOTEHOST} ] ; then
	echo    "Enter remote host where TLS keys are to be copied:"
	read REMOTEHOST
fi

#	Check if ${REMOTEHOST} string length is zero
if [ -z ${REMOTEHOST} ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Remote host is required." 1>&2
	echo -e "\tSee documentation for more information."
	exit 1
fi

#	Check if ${REMOTEHOST}-priv-key.pem file on system
if ! [ -e ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/${REMOTEHOST}-priv-key.pem ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  The ${REMOTEHOST}-priv-key.pem file was not found in ${USERHOME}${ADMTLSUSER}/.docker/docker-ca." 1>&2
	#	Help hint
	echo -e "\tRunning create-host-tls.sh will create public and private keys."
	exit 1
fi

#	Check if ${REMOTEHOST} is available on ssh port
if $(ssh ${REMOTEHOST} 'exit' >/dev/null 2>&1 ) ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${ADMTLSUSER} user may receive password and passphrase prompts from ${REMOTEHOST}.  Running ${BOLD}ssh-copy-id ${ADMTLSUSER}@${REMOTEHOST}${NORMAL} may stop some of the prompts." 1>&2

#	Check if /etc/docker directory on ${REMOTEHOST}
	if ! $(ssh -t ${ADMTLSUSER}@${REMOTEHOST} "test -d /etc/docker") ; then
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  /etc/docker directory missing, is docker installed on ${REMOTEHOST}." 1>&2
		exit 1
	fi

#	Create working directory ~/.docker/docker-ca/${REMOTEHOST}
	mkdir -p ${REMOTEHOST}
	cd ${REMOTEHOST}

#	Backup ${REMOTEHOST}/etc/docker/certs.d
	FILE_DATE_STAMP=$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Backing up ${REMOTEHOST}:/etc/docker/certs.d to $(pwd) Root access required." 1>&2
	ssh -t ${ADMTLSUSER}@${REMOTEHOST} "sudo mkdir -p /etc/docker/certs.d/daemon ; cd /etc ; sudo tar -pcf /tmp/${REMOTEHOST}-${FILE_DATE_STAMP}.tar ./docker/certs.d/daemon ; sudo chown ${ADMTLSUSER}.${ADMTLSUSER} /tmp/${REMOTEHOST}-${FILE_DATE_STAMP}.tar ; chmod 0400 /tmp/${REMOTEHOST}-${FILE_DATE_STAMP}.tar"
	scp -p ${ADMTLSUSER}@${REMOTEHOST}:/tmp/${REMOTEHOST}-${FILE_DATE_STAMP}.tar .
	ssh -t ${ADMTLSUSER}@${REMOTEHOST} "rm -f /tmp/${REMOTEHOST}-${FILE_DATE_STAMP}.tar"
	tar -pxf ${REMOTEHOST}-${FILE_DATE_STAMP}.tar

#	Check if /etc/docker/certs.d/daemon/${REMOTEHOST}-priv-key.pem file exists on remote system
	if [ -e ./docker/certs.d/daemon/${REMOTEHOST}-priv-key.pem ] ; then
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  /etc/docker/certs.d/daemon/${REMOTEHOST}-priv-key.pem already exists, ${BOLD}renaming existing keys${NORMAL} so new keys can be installed." 1>&2
		mv ./docker/certs.d/daemon/${REMOTEHOST}-priv-key.pem ./docker/certs.d/daemon/${REMOTEHOST}-priv-key.pem-${FILE_DATE_STAMP}
		mv ./docker/certs.d/daemon/${REMOTEHOST}-cert.pem ./docker/certs.d/daemon/${REMOTEHOST}-cert.pem-${FILE_DATE_STAMP}
		mv ./docker/certs.d/daemon/ca.pem ./docker/certs.d/daemon/ca.pem-${FILE_DATE_STAMP}
		rm ./docker/certs.d/daemon/{cert,key}.pem
	fi

#	Create certification tar file and install it to ${REMOTEHOST}
	chmod 0700 ./docker/certs.d/daemon
	cp -p ../${REMOTEHOST}-priv-key.pem ./docker/certs.d/daemon
	cp -p ../${REMOTEHOST}-cert.pem ./docker/certs.d/daemon
	cp -p ../ca.pem ./docker/certs.d/daemon
	cd ./docker/certs.d/daemon
	ln -s ${REMOTEHOST}-priv-key.pem key.pem
	ln -s ${REMOTEHOST}-cert.pem cert.pem
	cd ../../..
	FILE_DATE_STAMP=$(date +%Y-%m-%d-%H-%M-%S-%Z)
	tar -pcf ./${REMOTEHOST}-${FILE_DATE_STAMP}.tar ./docker/certs.d/daemon
	chmod 0600 ./${REMOTEHOST}-${FILE_DATE_STAMP}.tar
	scp -p ./${REMOTEHOST}-${FILE_DATE_STAMP}.tar ${ADMTLSUSER}@${REMOTEHOST}:/tmp

#	Create remote directory /etc/docker/certs.d/daemon
#	This directory was selected to place dockerd TLS certifications because
#	docker registry stores it's TLS certifications in /etc/docker/certs.d.
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Copying dockerd certification to ${REMOTEHOST}  Root access required." 1>&2
	ssh -t ${ADMTLSUSER}@${REMOTEHOST} "cd /etc ; sudo tar -pxf /tmp/${REMOTEHOST}-${FILE_DATE_STAMP}.tar ; sudo chmod 0700 /etc/docker ; sudo chmod 0700 /etc/docker/certs.d ; sudo chown -R root.root ./docker ; rm /tmp/${REMOTEHOST}-${FILE_DATE_STAMP}.tar"
	cd ..

#	Remove working directory ~/.docker/docker-ca/${REMOTEHOST}
	rm -rf ${REMOTEHOST}

#       Display instructions about certification environment variables
	echo -e "\n\nAdd TLS flags to dockerd so it will know to use TLS certifications (--tlsverify,"
	echo    "--tlscacert, --tlscert, --tlskey).  Scripts that will help with setup and"
	echo    "operations of Docker using TLS can be found:"
	echo    "https://github.com/BradleyA/docker-scripts/tree/master/dockerd-configuration-options"
	echo -e "\tThe dockerd-configuration-options scripts will help with"
	echo -e "\tconfiguration of dockerd on systems running Ubuntu 16.04"
	echo -e "\t(systemd) and Ubuntu 14.04 (Upstart).\n"
#
	echo -e "If dockerd is already using TLS certifications then entering one of the\nfollowing will restart dockerd with the new certifications.\n"
	echo -e "\tUbuntu 16.04 (Systemd) ${BOLD}sudo systemctl restart docker${NORMAL}"
	echo -e "\tUbuntu 14.04 (Upstart) ${BOLD}sudo service docker restart${NORMAL}\n"
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Done." 1>&2
	exit 0
else
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${REMOTEHOST} not responding on ssh port." 1>&2
	exit 1
fi

#       May want to create a version of this script that automates this process for SRE tools,
#       but keep this script for users to run manually,
#       open ticket and remove this comment 

#
#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
