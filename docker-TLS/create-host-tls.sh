#!/bin/bash
# 	docker-TLS/create-host-tls.sh  3.112.481  2019-01-22T16:33:52.690661-06:00 (CST)  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.111-8-g9346bea  
# 	   production standard 5 include Copyright notice change format on first prompt 
# 	docker-TLS/create-host-tls.sh  3.111.472  2019-01-20T00:05:37.625390-06:00 (CST)  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.110  
# 	   production standard 4 Internationalizing display-help close #39 
# 	docker-TLS/create-host-tls.sh  3.110.471  2018-12-23T23:19:37.585130-06:00 (CST)  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.109  
# 	   format process output for user 
#
### create-host-tls.sh - Create host public, private keys and CA
#       Copyright (c) 2019 Bradley Allen
#       License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
###
#   production standard 5
#       Order of precedence: environment variable, default code
if [ "${DEBUG}" == "" ] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
#	set -x
#	set -v
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
###
display_help() {
echo -e "\n{NORMAL}${0} - Create host public, private keys and CA"
echo -e "\nUSAGE\n   ${0} <FQDN> <#-of-days>  [<USERHOME>] [<ADMTLSUSER>]" 
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION"
#       Displaying help DESCRIPTION in English en_US.UTF-8
echo    "An administration user can run this script to create host public, private keys"
echo    "and CA in working directory, ${HOME}/.docker/docker-ca."
#       Displaying help DESCRIPTION in French fr_CA.UTF-8, fr_FR.UTF-8, fr_CH.UTF-8
if [ "${LANG}" == "fr_CA.UTF-8" ] || [ "${LANG}" == "fr_FR.UTF-8" ] || [ "${LANG}" == "fr_CH.UTF-8" ] ; then
        echo -e "\n--> ${LANG}"
        echo    "<votre aide va ici>" # your help goes here
        echo    "Souhaitez-vous traduire la section description?" # Do you want to translate the description section?
elif ! [ "${LANG}" == "en_US.UTF-8" ] ; then
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Your language, ${LANG}, is not supported.  Would you like to translate the description section?" 1>&2
fi
echo -e "\nEnvironment Variables"
echo    "If using the bash shell, enter; 'export DEBUG=1' on the command line to set"
echo    "the DEBUG environment variable to '1' (0 = debug off, 1 = debug on).  Use the"
echo    "command, 'unset DEBUG' to remove the exported information from the DEBUG"
echo    "environment variable.  You are on your own defining environment variables if"
echo    "you are using other shells."
echo    "   DEBUG       (default '0')"
echo    "   USERHOME    (default /home/)"
echo -e "\nOPTIONS"
echo    "   FQDN         Fully qualified domain name of host requiring new TLS keys"
echo    "   NUMBERDAYS   number of days host CA is valid, default 365 days"
echo    "   USERHOME     location of admin user directory, default is /home/"
echo    "                sites have different home directories (/u/north-office/)"
echo    "   ADMTLSUSER   site administrator creating TLS keys, default is user running"
echo    "                script."
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS"
echo -e "\nEXAMPLES\n   ${0} two.cptx86.com 180 /u/north-office/ uadmin\n"
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
FQDN=$1
NUMBERDAYS=${2:-365}
#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  3 ]  ; then USERHOME=${3} ; elif [ "${USERHOME}" == "" ] ; then USERHOME="/home/" ; fi
ADMTLSUSER=${4:-${USER}}
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  FQDN >${FQDN}< NUMBERDAYS >${NUMBERDAYS}< USERHOME >${USERHOME}< ADMTLSUSER  >${ADMTLSUSER}<" 1>&2 ; fi

#	Check if admin user has home directory on system
if [ ! -d ${USERHOME}${ADMTLSUSER} ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${ADMTLSUSER} does not have a home directory on this system or ${ADMTLSUSER} home directory is not ${USERHOME}${ADMTLSUSER}" 1>&2
	exit 1
fi

#       Check if site CA directory on system
if [ ! -d ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Default directory, ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private, not on system." 1>&2
	#	Help hint
	echo -e "\n\tRunning create-site-private-public-tls.sh will create directories"
	echo -e "\tand site private and public keys.  Then run sudo"
	echo -e "\tcreate-new-openssl.cnf-tls.sh to modify openssl.cnf file.  Then run"
	echo -e "\tcreate-host-tls.sh or create-user-tls.sh as many times as you want."
	exit 1
fi
cd ${USERHOME}${ADMTLSUSER}/.docker/docker-ca

#       Check if ca-priv-key.pem file on system
if ! [ -e ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Site private key ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem is not in this location." 1>&2
	#	Help hint
	echo -e "\n\tEither move it from your site secure location to"
	echo -e "\t${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/"
	echo -e "\tOr run create-site-private-public-tls.sh and sudo"
	echo -e "\tcreate-new-openssl.cnf-tls.sh to create a new one."
	exit 1
fi

#	Prompt for ${FQDN} if argement not entered
if [ -z ${FQDN} ] ; then
	echo -e "\n\t${BOLD}Enter fully qualified domain name (FQDN) requiring new TLS keys:${NORMAL}"
	read FQDN
fi

#	Check if ${FQDN} string length is zero
if [ -z ${FQDN} ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  A Fully Qualified Domain Name (FQDN) is required to create new host TLS keys." 1>&2
	exit 1
fi

#	Check if ${FQDN}-priv-key.pem file exists
if [ -e ${FQDN}-priv-key.pem ] ; then
	echo -e "\n\t${FQDN}-priv-key.pem already exists,"
	echo -e "\trenaming existing keys so new keys can be created."
	mv ${FQDN}-priv-key.pem ${FQDN}-priv-key.pem$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)
	mv ${FQDN}-cert.pem ${FQDN}-cert.pem$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)
fi

#	Creating private key for host ${FQDN}
echo -e "\n\tCreating private key for host ${FQDN}."
openssl genrsa -out ${FQDN}-priv-key.pem 2048

#	Create CSR for host ${FQDN}
echo -e "\n\tGenerate a Certificate Signing Request (CSR) for"
echo -e "\thost ${FQDN}."
openssl req -sha256 -new -key ${FQDN}-priv-key.pem -subj "/CN=${FQDN}/subjectAltName=${FQDN}" -out ${FQDN}.csr

#	Create and sign certificate for host ${FQDN}
echo -e "\n\tCreate and sign a ${NUMBERDAYS} day certificate for host"
echo -e "\t${FQDN}."
openssl x509 -req -days ${NUMBERDAYS} -sha256 -in ${FQDN}.csr -CA ca.pem -CAkey .private/ca-priv-key.pem -CAcreateserial -out ${FQDN}-cert.pem -extensions v3_req -extfile /usr/lib/ssl/openssl.cnf || { get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Wrong pass phrase for .private/ca-priv-key.pem: " ; exit 1; }
openssl rsa -in ${FQDN}-priv-key.pem -out ${FQDN}-priv-key.pem
echo -e "\n\tRemoving certificate signing requests (CSR) and set file permissions"
echo -e "\tfor host ${FQDN} key pairs."
rm ${FQDN}.csr
chmod 0400 ${FQDN}-priv-key.pem
chmod 0444 ${FQDN}-cert.pem

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
