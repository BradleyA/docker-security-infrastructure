#!/bin/bash
# 	docker-TLS/create-host-tls.sh  3.76.433  2018-11-11T10:23:58.368310-06:00 (CST)  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.75  
# 	   move UID and GID function up a few link to allow DEBUG statement to use it 
# 	docker-TLS/create-host-tls.sh  3.74.431  2018-10-22T21:18:56.079225-05:00 (CDT)  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.73  
# 	   Need to retest everything after all the formating changes #30 
# 	docker-TLS/create-host-tls.sh  3.67.424  2018-10-22T13:39:36.001257-05:00 (CDT)  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.66  
# 	   create-host-tls.sh Change echo or print DEBUG INFO WARNING ERROR closes #23 
# 	create-host-tls.sh  3.58.415  2018-09-01_18:08:57_CDT  https://github.com/BradleyA/docker-scripts  uadmin  three-rpi3b.cptx86.com 3.57  
# 	   change file names to use date format without : or _ close #17 
#
###	create-host-tls.sh - Create host public, private keys and CA
DEBUG=0                 # 0 = debug off, 1 = debug on
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
echo -e "\nDESCRIPTION\nAn administration user can run this script to create host public, private keys"
echo    "and CA in working directory, ${HOME}/.docker/docker-ca."
echo -e "\nOPTIONS"
echo    "   FQDN         Fully qualified domain name of host requiring new TLS keys"
echo    "   NUMBERDAYS   number of days host CA is valid, default 365 days"
echo    "   USERHOME     location of admin user directory, default is /home/"
echo    "                sites have different home directories (/u/north-office/)"
echo    "   ADMTLSUSER   site administrator creating TLS keys, default is user running"
echo    "                script."
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS"
echo -e "\nEXAMPLES\n   ${0} two.cptx86.com 180 /u/north-office/ uadmin\n"
#       After displaying help in english check for other languages
if ! [ "${LANG}" == "en_US.UTF-8" ] ; then
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[WARN]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Your language, ${LANG}, is not supported, Would you like to help translate?" 1>&2
#       elif [ "${LANG}" == "fr_CA.UTF-8" ] ; then
#               get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[WARN]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Display help in ${LANG}" 1>&2
#       else
#               get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[WARN]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Your language, ${LANG}, is not supported.\tWould you like to translate?" 1>&2
fi
}

#       Date and time function ISO 8601
get_date_stamp() {
DATE_STAMP=`date +%Y-%m-%dT%H:%M:%S.%6N%:z`
TEMP=`date +%Z`
DATE_STAMP=`echo "${DATE_STAMP} (${TEMP})"`
}

#       Fully qualified domain name FQDN hostname
LOCALHOST=`hostname -f`

#       Version
SCRIPT_NAME=`head -2 ${0} | awk {'printf$2'}`
SCRIPT_VERSION=`head -2 ${0} | awk {'printf$3'}`

#       UID and GID
USER_ID=`id -u`
GROUP_ID=`id -g`

#       Added line because USER is not defined in crobtab jobs
if ! [ "${USER}" == "${LOGNAME}" ] ; then  USER=${LOGNAME} ; fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  USER  >${USER}<  LOGNAME >${LOGNAME}<" 1>&2 ; fi

#       Default help and version arguments
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] ; then
        display_help
        exit 0
fi
if [ "$1" == "--version" ] || [ "$1" == "-version" ] || [ "$1" == "version" ] || [ "$1" == "-v" ] ; then
        echo "${SCRIPT_NAME} ${SCRIPT_VERSION}"
        exit 0
fi

#       INFO
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Begin" 1>&2

#       DEBUG
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Name_of_command >${0}< Name_of_arg1 >${1}<  Version of bash ${BASH_VERSION}" 1>&2 ; fi

###		
FQDN=$1
NUMBERDAYS=${2:-365}
USERHOME=${3:-/home/}
ADMTLSUSER=${4:-${USER}}
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  FQDN >${FQDN}< NUMBERDAYS >${NUMBERDAYS}< USERHOME >${USERHOME}< ADMTLSUSER  >${ADMTLSUSER}<" 1>&2 ; fi

#	Check if admin user has home directory on system
if [ ! -d ${USERHOME}${ADMTLSUSER} ] ; then
	display_help
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  ${ADMTLSUSER} does not have a home directory on this system or ${ADMTLSUSER} home directory is not ${USERHOME}${ADMTLSUSER}" 1>&2
	exit 1
fi

#       Check if site CA directory on system
if [ ! -d ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private ] ; then
	display_help
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Default directory, ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private, not on system." 1>&2
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
	display_help
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Site private key ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem is not in this location." 1>&2
	#	Help hint
	echo -e "\n\tEither move it from your site secure location to"
	echo -e "\t${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/"
	echo -e "\tOr run create-site-private-public-tls.sh and sudo"
	echo -e "\tcreate-new-openssl.cnf-tls.sh to create a new one."
	exit 1
fi

#	Prompt for ${FQDN} if argement not entered
if [ -z ${FQDN} ] ; then
	echo -e "Enter fully qualified domain name (FQDN) requiring new TLS keys:"
	read FQDN
fi

#	Check if ${FQDN} string length is zero
if [ -z ${FQDN} ] ; then
	display_help
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  A Fully Qualified Domain Name (FQDN) is required to create new host TLS keys." 1>&2
	exit 1
fi

#	Check if ${FQDN}-priv-key.pem file exists
if [ -e ${FQDN}-priv-key.pem ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[WARN]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  ${FQDN}-priv-key.pem already exists, renaming existing keys so new keys can be created." 1>&2
	mv ${FQDN}-priv-key.pem ${FQDN}-priv-key.pem`date +%Y-%m-%dT%H:%M:%S.%6N%:z`
	mv ${FQDN}-cert.pem ${FQDN}-cert.pem`date +%Y-%m-%dT%H:%M:%S.%6N%:z`
fi

#	Creating private key for host ${FQDN}
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Creating private key for host ${FQDN}." 1>&2
openssl genrsa -out ${FQDN}-priv-key.pem 2048

#	Create CSR for host ${FQDN}
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Generate a Certificate Signing Request (CSR) for host ${FQDN}." 1>&2
openssl req -sha256 -new -key ${FQDN}-priv-key.pem -subj "/CN=${FQDN}/subjectAltName=${FQDN}" -out ${FQDN}.csr

#	Create and sign certificate for host ${FQDN}
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Create and sign a ${NUMBERDAYS} day certificate for host ${FQDN}." 1>&2
openssl x509 -req -days ${NUMBERDAYS} -sha256 -in ${FQDN}.csr -CA ca.pem -CAkey .private/ca-priv-key.pem -CAcreateserial -out ${FQDN}-cert.pem -extensions v3_req -extfile /usr/lib/ssl/openssl.cnf || { get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Wrong pass phrase for .private/ca-priv-key.pem:" ; exit 1; }
openssl rsa -in ${FQDN}-priv-key.pem -out ${FQDN}-priv-key.pem
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Removing certificate signing requests (CSR) and set file permissions for host ${FQDN} key pairs." 1>&2
rm ${FQDN}.csr
chmod 0400 ${FQDN}-priv-key.pem
chmod 0444 ${FQDN}-cert.pem

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Done." 1>&2
###
