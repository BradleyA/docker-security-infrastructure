#!/bin/bash
# 	docker-TLS/check-registry-tls.sh  3.179.593  2019-04-05T14:13:56.239080-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  six-rpi3b.cptx86.com 3.178  
# 	   update comments 
# 	docker-TLS/check-registry-tls.sh  3.150.563  2019-03-09T08:26:16.534422-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure-scripts.git  uadmin  six-rpi3b.cptx86.com 3.149  
# 	   begin writing create docker-TLS/check-registry-tls.sh #42 
echo "In development		In developmen		In developmentt		In development		In development"
echo "		In development		In developmen		In developmentt		In development		In development"
### production standard 5.0 Copyright
#       Copyright (c) 2019 Bradley Allen
#       License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
### production standard 1.0 DEBUG variable
#       Order of precedence: environment variable, default code
if [ "${DEBUG}" == "" ] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
#       set -x
#       set -v
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
### production standard 7.0 Default variable value
DEFAULT_REGISTRY_HOST=$(hostname -f)    # local host
DEFAULT_REGISTRY_PORT="17313"
DEFAULT_CLUSTER="us-tx-cluster-1/"
DEFAULT_DATA_DIR="/usr/local/data/"
DEFAULT_SYSTEMS_FILE="SYSTEMS"
### production standard 0.0 --help
display_help() {
echo -e "\n${NORMAL}${0} - Check certifications for private registry"
echo -e "\nUSAGE\n   ${0} " 
echo -e "   ${0} [<REGISTRY_HOST>]" 
echo    "   ${0}  <REGISTRY_HOST> [<REGISTRY_PORT>]" 
echo    "   ${0}  <REGISTRY_HOST>  <REGISTRY_PORT> [<CLUSTER>]" 
echo    "   ${0}  <REGISTRY_HOST>  <REGISTRY_PORT>  <CLUSTER>  [<DATA_DIR>]" 
echo    "   ${0}  <REGISTRY_HOST>  <REGISTRY_PORT>  <CLUSTER>   <DATA_DIR>  [<SYSTEMS_FILE>]" 
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION"
#       Displaying help DESCRIPTION in English en_US.UTF-8
echo    "<your help goes here>" 
echo    ">>> NEED TO COMPLETE THIS SOON, ONCE I KNOW HOW IT IS GOING TO WORK :-) <<<"
echo -e "\n<<Paragraph two>>"

echo    "An administration user can run this script to create Docker private registry"
echo    "certificates on any host in the directory; \${HOME}/.docker/.  It will create"
echo    "a working directory, registry-certs-<REGISTRY_HOST>-<REGISTRY_PORT>.  The"
echo    "<REGISTRY_PORT> number is not required when creating private registry"
echo    "certificates.  I use the <REGISTRY_PORT> number to keep track of multiple"
echo    "certificates for multiple private registries on the same host.  The"
echo    "<REGISTRY_HOST> and <REGISTRY_PORT> number is required when copying the"
echo    "ca.crt into the /etc/docker/certs.d/<REGISTRY_HOST>:<REGISTRY_PORT>/"
echo    "directory on each host using the private registry."

echo -e "\nThe <DATA_DIR>/<CLUSTER>/<SYSTEMS_FILE> includes one FQDN or IP address per"
echo    "line for all hosts in the cluster.  Lines in <SYSTEMS_FILE> that begin with a"
echo    "'#' are comments.  The <SYSTEMS_FILE> is used by markit/find-code.sh,"
echo    "Linux-admin/cluster-command/cluster-command.sh, docker-TLS/copy-registry-tls.sh," 
echo    "pi-display/create-message/create-display-message.sh, and other scripts.  A"
echo    "different <SYSTEMS_FILE> can be entered on the command line or environment"
echo    "variable."
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
echo    "   DEBUG           (default '0')"
echo    "   REGISTRY_HOST   Registry host (default '${DEFAULT_REGISTRY_HOST}')"
echo    "   REGISTRY_PORT   Registry port number (default '${DEFAULT_REGISTRY_PORT}')"
echo    "   CLUSTER         (default '${DEFAULT_CLUSTER}')"
echo    "   DATA_DIR        (default '${DEFAULT_DATA_DIR}')"
echo    "   SYSTEMS_FILE    (default '${DEFAULT_SYSTEMS_FILE}')"
echo -e "\nOPTIONS"
echo    "Order of precedence: CLI options, environment variable, default code."
echo    "   REGISTRY_HOST   Registry host (default '${DEFAULT_REGISTRY_HOST}')"
echo    "   REGISTRY_PORT   Registry port number (default '${DEFAULT_REGISTRY_PORT}')"
echo    "   CLUSTER         (default '${DEFAULT_CLUSTER}')"
echo    "   DATA_DIR        (default '${DEFAULT_DATA_DIR}')"
echo    "   SYSTEMS_FILE    (default '${DEFAULT_SYSTEMS_FILE}')"
### production standard 6.0 Architecture tree
echo -e "\nSTORAGE & CERTIFICATION ARCHITECTURE TREE"
echo    "/usr/local/data/                          <-- <DATA_DIR>"
echo    "   <CLUSTER>/                             <-- <CLUSTER>"
echo    "   ├── SYSTEMS                            <-- List of hosts in cluster"
echo    "   └── docker-registry/                   <-- Docker registry directory"
echo    "       ├── <REGISTRY_HOST>-<REGISTRY_PORT>/ <-- Registry container mount"
echo    "       │   ├── certs/                     <-- Registry cert directory"
echo    "       │   │   ├── domain.crt             <-- Registry cert"
echo    "       │   │   └── domain.key             <-- Registry private key"
echo    "       │   └── docker/                    <-- Registry storage directory"
echo -e "       └── <REGISTRY_HOST>-<REGISTRY_PORT>/ <-- Registry container mount\n"
echo    "/etc/ "
echo    "   docker/ "
echo    "   └── certs.d/                           <-- Host docker cert directory"
echo    "       ├── <REGISTRY_HOST>:<REGISTRY_PORT>/ <-- Registry cert directory"
echo    "       │   └── ca.crt                     <-- Daemon registry domain cert"
echo    "       └── <REGISTRY_HOST>:<REGISTRY_PORT>/ <-- Registry cert directory"
echo    "           └── ca.crt                     <-- Daemon registry domain cert"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-security-infrastructure/tree/master/docker-TLS"
echo -e "\nEXAMPLES\n   <<your code examples description goes here>>\n	${BOLD}${0} <<code example goes here>>${NORMAL}"
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

### production standard 2.0 log format (WHEN WHERE WHAT Version Line WHO UID:GID [TYPE] Message)
#       INFO
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Started..." 1>&2

#       DEBUG
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Name_of_command >${0}< Name_of_arg1 >${1}< Name_of_arg2 >${2}< Name_of_arg3 >${3}<  Version of bash ${BASH_VERSION}" 1>&2 ; fi

###
#       Root is required to copy certs
if ! [ $(id -u) = 0 ] ; then
        display_help | more
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Use sudo ${0}" 1>&2
        echo -e "${BOLD}\n>>   SCRIPT MUST BE RUN AS ROOT TO COPY FILES.  sudo copy-registry-tls.sh   <<\n${NORMAL}"     1>&2
        exit 1
fi

### production standard 7.0 Default variable value
#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  1 ]  ; then REGISTRY_HOST=${1} ; elif [ "${REGISTRY_HOST}" == "" ] ; then REGISTRY_HOST=${DEFAULT_REGISTRY_HOST} ; fi
if [ $# -ge  2 ]  ; then REGISTRY_PORT=${2} ; elif [ "${REGISTRY_PORT}" == "" ] ; then REGISTRY_PORT=${DEFAULT_REGISTRY_PORT} ; fi
if [ $# -ge  3 ]  ; then CLUSTER=${3} ; elif [ "${CLUSTER}" == "" ] ; then CLUSTER=${DEFAULT_CLUSTER} ; fi
if [ $# -ge  4 ]  ; then DATA_DIR=${4} ; elif [ "${DATA_DIR}" == "" ] ; then DATA_DIR=${DEFAULT_DATA_DIR} ; fi
if [ $# -ge  5 ]  ; then SYSTEMS_FILE=${5} ; elif [ "${SYSTEMS_FILE}" == "" ] ; then SYSTEMS_FILE=${DEFAULT_SYSTEMS_FILE} ; fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... REGISTRY_HOST >${REGISTRY_HOST}< REGISTRY_PORT >${REGISTRY_PORT}< CLUSTER >${CLUSTER}< DATA_DIR >${DATA_DIR}< SYSTEMS_FILE >${SYSTEMS_FILE}<" 1>&2 ; fi

#       Set REGISTRY_HOST_CERT variable to host entered during the creation of certificates
REGISTRY_HOST_CERT=$(openssl x509 -in /etc/docker/certs.d/${REGISTRY_HOST}\:${REGISTRY_PORT}/ca.crt -noout -issuer | cut -d '/' -f 7 | cut -d '=' -f 2)
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... REGISTRY_HOST >${REGISTRY_HOST}< REGISTRY_HOST_CERT >${REGISTRY_HOST_CERT}<" 1>&2 ; fi
if [ ! "${REGISTRY_HOST_CERT}" == "${REGISTRY_HOST}" ] ; then 
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  The certificate, /etc/docker/certs.d/${REGISTRY_HOST}\:${REGISTRY_PORT}/ca.crt, is for host ${REGISTRY_HOST_CERT} not ${REGISTRY_HOST}" 1>&2
# >>>	#
	exit 1
# >>>	#
fi

#	Get registry certificate expiration date from ca.crt
REGISTRY_EXPIRE_DATE=$(openssl x509 -in /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt -noout -enddate | cut -d '=' -f 2)
REGISTRY_EXPIRE_SECONDS=$(date -d "${REGISTRY_EXPIRE_DATE}" '+%s')
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... REGISTRY_EXPIRE_DATE >${REGISTRY_EXPIRE_DATE}< REGISTRY_EXPIRE_SECONDS >${REGISTRY_EXPIRE_SECONDS}<" 1>&2 ; fi

#	Get currect date in seconds
CURRENT_DATE_SECONDS=$(date '+%s' )
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... CURRENT_DATE_SECONDS >${CURRENT_DATE_SECONDS}<" 1>&2 ; fi

#	Check if certificate has expired
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  REGISTRY_EXPIRE_DATE  >${REGISTRY_EXPIRE_DATE}<  REGISTRY_EXPIRE_SECONDS > CURRENT_DATE_SECONDS ${REGISTRY_EXPIRE_SECONDS} -gt ${CURRENT_DATE_SECONDS}" 1>&2 ; fi
if [ "${REGISTRY_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS}" ] ; then
	echo -e "\n\tCertificate, /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt, is ${BOLD}good${NORMAL} until ${REGISTRY_EXPIRE_DATE}\n"
else
	echo -e "\n\tCertificate, /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt, ${BOLD}HAS EXPIRED${NORMAL} on ${REGISTRY_EXPIRE_DATE}"
	echo -e "\tUse script create-registry-tls.sh to update expired registry TLS.\n"
fi

#	Check if ${LOCALHOST} is ${REGISTRY_HOST} running the private registry
if [ "${LOCALHOST}" == "${REGISTRY_HOST}" ] ; then
	#       Check if private registry certificate directory
	if [ ! -d ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}:${REGISTRY_PORT}/certs/ ] ; then
        	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]  Directory ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}:${REGISTRY_PORT}/certs/ NOT found${NORMAL}" 1>&2
        	exit 1
	fi
	#       Set REGISTRY_HOST_CERT variable to host entered during the creation of certificates
	REGISTRY_HOST_CERT=$(openssl x509 -in ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt -noout -issuer | cut -d '/' -f 7 | cut -d '=' -f 2)
	if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... REGISTRY_HOST >${REGISTRY_HOST}< REGISTRY_HOST_CERT >${REGISTRY_HOST_CERT}<" 1>&2 ; fi
	if [ ! "${REGISTRY_HOST_CERT}" == "${REGISTRY_HOST}" ] ; then
        	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  The certificate, ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}:${REGISTRY_PORT}/certs/domain.crt, is for host ${REGISTRY_HOST_CERT} not ${REGISTRY_HOST}" 1>&2
        	exit 1
	fi
	#	Get registry certificate expiration date domain.crt
	REGISTRY_EXPIRE_DATE=$(openssl x509 -in ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt -noout -enddate | cut -d '=' -f 2)
	REGISTRY_EXPIRE_SECONDS=$(date -d "${REGISTRY_EXPIRE_DATE}" '+%s')
	if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... REGISTRY_EXPIRE_DATE >${REGISTRY_EXPIRE_DATE}< REGISTRY_EXPIRE_SECONDS >${REGISTRY_EXPIRE_SECONDS}<" 1>&2 ; fi

	#	Check if certificate has expired
	if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  REGISTRY_EXPIRE_DATE  >${REGISTRY_EXPIRE_DATE}<  REGISTRY_EXPIRE_SECONDS > CURRENT_DATE_SECONDS ${REGISTRY_EXPIRE_SECONDS} -gt ${CURRENT_DATE_SECONDS}" 1>&2 ; fi
	if [ "${REGISTRY_EXPIRE_SECONDS}" -gt "${CURRENT_DATE_SECONDS}" ] ; then
		echo -e "\n\tCertificate, ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}:${REGISTRY_PORT}/certs/domain.crt, is ${BOLD}good${NORMAL} until ${REGISTRY_EXPIRE_DATE}\n"
	else
		echo -e "\n\tCertificate, ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}:${REGISTRY_PORT}/certs/domain.crt, ${BOLD}HAS EXPIRED${NORMAL} on ${REGISTRY_EXPIRE_DATE}"
		echo -e "\tUse script create-registry-tls.sh to update expired registry TLS.\n"
	fi
else
		echo -e "\n\tHost, ${LOCALHOST}, is ${BOLD}NOT${NORMAL} ${REGISTRY_HOST} thus skip checking domain.crt and domain.key certificates."
fi


#	TEMP=$(openssl verify -verbose -CAfile ${CERTDIR}ca.pem ${CERTDIR}cert.pem)
#	echo -e "\nVerify that dockerd daemon certificate was issued by the CA:\n\t${BOLD}${TEMP}${NORMAL}"
#	
#	echo -e "\nVerify and correct file permissions."
#	
#	#       Verify and correct file permissions for ${CERTDIR}ca.pem
#	if [ $(stat -Lc %a ${CERTDIR}ca.pem) != 444 ]; then
        #	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File permissions for ${CERTDIR}ca.pem are not 444.  Correcting $(stat -Lc %a ${CERTDIR}ca.pem) to 0444 file permissions." 1>&2
        #	chmod 0444 ${CERTDIR}ca.pem
#	fi
#	
#	#       Verify and correct file permissions for ${CERTDIR}cert.pem
#	if [ $(stat -Lc %a ${CERTDIR}cert.pem) != 444 ]; then
        #	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File permissions for ${CERTDIR}cert.pem are not 444.  Correcting $(stat -Lc %a ${CERTDIR}cert.pem) to 0444 file permissions." 1>&2
        #	chmod 0444 ${CERTDIR}cert.pem
#	fi
#	
#	#       Verify and correct file permissions for ${CERTDIR}key.pem
#	if [ $(stat -Lc %a ${CERTDIR}key.pem) != 400 ]; then
        #	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File permissions for ${CERTDIR}key.pem are not 400.  Correcting $(stat -Lc %a ${CERTDIR}key.pem) to 0400 file permissions." 1>&2
        #	chmod 0400 ${CERTDIR}key.pem
#	fi
#	
#	#       Verify and correct directory permissions for ${CERTDIR} directory
#	if [ $(stat -Lc %a ${CERTDIR}) != 700 ]; then
        #	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Directory permissions for ${CERTDIR} are not 700.  Correcting $(stat -Lc %a ${CERTDIR}) to 700 directory permissions." 1>&2
        #	chmod 700 ${CERTDIR}
#	fi


#	#	Verify that user public key in your certificate matches the public portion of your private key.
#	echo -e "\n\tVerify that user public key in your certificate matches the public portion\n\tof your private key."
#	(cd ${USERHOME}${TLSUSER}/.docker ; openssl x509 -noout -modulus -in cert.pem | openssl md5 ; openssl rsa -noout -modulus -in key.pem | openssl md5) | uniq
#	echo -e "\t${BOLD}[WARN]${NORMAL}  -> If ONLY ONE line of output is returned then the public key\n\tmatches the public portion of your private key.\n"
#	

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
