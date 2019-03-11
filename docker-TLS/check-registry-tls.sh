#!/bin/bash
# 	docker-TLS/check-registry-tls.sh  3.152.565  2019-03-10T20:32:40.379938-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure-scripts.git  uadmin  six-rpi3b.cptx86.com 3.151  
# 	   more work 
# 	docker-TLS/check-registry-tls.sh  3.151.564  2019-03-09T20:06:59.495406-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure-scripts.git  uadmin  six-rpi3b.cptx86.com 3.150  
# 	   update to display_help 
# 	docker-TLS/check-registry-tls.sh  3.150.563  2019-03-09T08:26:16.534422-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure-scripts.git  uadmin  six-rpi3b.cptx86.com 3.149  
# 	   begin writing create docker-TLS/check-registry-tls.sh #42 
### check-registry-tls.sh - Check certifications for private registry
#       Copyright (c) 2019 Bradley Allen
#       License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.

#
echo "In development		In developmen		In developmentt		In development		In development"
echo "		In development		In developmen		In developmentt		In development		In development"
# 


###
#   production standard 5
#       Order of precedence: environment variable, default code
if [ "${DEBUG}" == "" ] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
#       set -x
#       set -v
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
###
display_help() {
echo -e "\n${NORMAL}${0} - Check certifications for private registry"
echo -e "\nUSAGE\n   ${0} " 
echo -e "   ${0} [<REGISTRY_HOST>]" 
echo -e "   ${0}  <REGISTRY_HOST> [<REGISTRY_PORT>]" 
echo -e "   ${0}  <REGISTRY_HOST>  <REGISTRY_PORT> [<CLUSTER>]" 
echo -e "   ${0}  <REGISTRY_HOST>  <REGISTRY_PORT>  <CLUSTER> [<DATA_DIR>]"
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


#       Displaying help DESCRIPTION in French fr_CA.UTF-8, fr_FR.UTF-8, fr_CH.UTF-8
if [ "${LANG}" == "fr_CA.UTF-8" ] || [ "${LANG}" == "fr_FR.UTF-8" ] || [ "${LANG}" == "fr_CH.UTF-8" ] ; then
        echo -e "\n--> ${LANG}"
        echo    "<votre aide va ici>" # your help goes here
        echo    "Souhaitez-vous traduire la section description?" # Do you want to translate the description section?
elif ! [ "${LANG}" == "en_US.UTF-8" ] ; then
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Your language, ${LANG}, is not supported.  Would you like to translate the description section?" 1>&2
fi
echo -e "\nSTORAGE & CERTIFICATION ARCHITECTURE TREE"
echo    "/usr/local/data/                            <-- <DATA_DIR>"
echo    "   <CLUSTER>/                               <-- <CLUSTER>"
echo    "   └── docker-registry/                     <-- Docker registry directory"
echo    "       └── <REGISTRY_HOST>-<REGISTRY_PORT>/ <-- Registry container mount"
echo    "           ├── certs/                       <-- Registry cert directory"
echo    "           │   ├── domain.crt               <-- Registry cert"
echo    "           │   └── domain.key               <-- Registry private key"
echo -e "           └── docker/                      <-- Registry storage directory\n"
echo    "/etc/docker/certs.d/                        <-- Host docker cert directory"
echo    "   └── <REGISTRY_HOST>:<REGISTRY_PORT>/     <-- Registry cert directory"
echo    "       └── ca.crt                           <-- Daemon trust registry cert"
echo -e "\nENVIRONMENT VARIABLES"
echo    "If using the bash shell, enter; 'export DEBUG=1' on the command line to set"
echo    "the DEBUG environment variable to '1' (0 = debug off, 1 = debug on).  Use the"
echo    "command, 'unset DEBUG' to remove the exported information from the DEBUG"
echo    "environment variable.  You are on your own defining environment variables if"
echo    "you are using other shells."
echo    "   DEBUG       (default '0')"
echo    "   REGISTRY_HOST   Registry host (default 'local host')"
echo    "   REGISTRY_PORT   Registry port number (default '5000')"
echo    "   CLUSTER         (default us-tx-cluster-1/)"
echo    "   DATA_DIR        (default /usr/local/data/)"
echo -e "\nOPTIONS"
echo    "   REGISTRY_HOST   Registry host (default 'local host')"
echo    "   REGISTRY_PORT   Registry port number (default '5000')"
echo    "   CLUSTER         (default us-tx-cluster-1/)"
echo    "   DATA_DIR        (default /usr/local/data/)"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-security-infrastructure/tree/master/docker-TLS"
echo -e "\nEXAMPLES\n   ${BOLD}sudo ${0} <<code example goes here>>${NORMAL}\n\n   <<your code examples description goes here>>\n"
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
#       Root is required to copy certs
if ! [ $(id -u) = 0 ] ; then
        display_help | more
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Use sudo ${0}" 1>&2
        echo -e "${BOLD}\n>>   SCRIPT MUST BE RUN AS ROOT TO COPY FILES.  sudo copy-registry-tls.sh   <<\n${NORMAL}"     1>&2
        exit 1
fi


# >>>
REGISTRY_HOST=two.cptx86.com
REGISTRY_PORT=17313
# >>>

#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  1 ]  ; then REGISTRY_HOST=${1} ; elif [ "${REGISTRY_HOST}" == "" ] ; then REGISTRY_HOST=${LOCALHOST} ; fi
if [ $# -ge  2 ]  ; then REGISTRY_PORT=${2} ; elif [ "${REGISTRY_PORT}" == "" ] ; then REGISTRY_PORT="5000" ; fi
if [ $# -ge  3 ]  ; then CLUSTER=${3} ; elif [ "${CLUSTER}" == "" ] ; then CLUSTER="us-tx-cluster-1/" ; fi
if [ $# -ge  4 ]  ; then DATA_DIR=${4} ; elif [ "${DATA_DIR}" == "" ] ; then DATA_DIR="/usr/local/data/" ; fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... REGISTRY_HOST >${REGISTRY_HOST}< REGISTRY_PORT >${REGISTRY_PORT}< CLUSTER >${CLUSTER}< DATA_DIR >${DATA_DIR}<" 1>&2 ; fi

#       Set REGISTRY_HOST_CERT variable to host entered during the creation of certificates
REGISTRY_HOST_CERT=$(openssl x509 -in /etc/docker/certs.d/${REGISTRY_HOST}\:${REGISTRY_PORT}/ca.crt -noout -issuer | cut -d '/' -f 7 | cut -d '=' -f 2)
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... REGISTRY_HOST >${REGISTRY_HOST}< REGISTRY_HOST_CERT >${REGISTRY_HOST_CERT}<" 1>&2 ; fi
if [ ! "${REGISTRY_HOST_CERT}" == "${REGISTRY_HOST}" ] ; then 
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  The certificate, /etc/docker/certs.d/${REGISTRY_HOST}\:${REGISTRY_PORT}/ca.crt, is for host ${REGISTRY_HOST_CERT} not ${REGISTRY_HOST}" 1>&2
	exit 1
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
	REGISTRY_HOST_CERT=$(openssl x509 -in ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}:${REGISTRY_PORT}/certs/domain.crt -noout -issuer | cut -d '/' -f 7 | cut -d '=' -f 2)
	if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... REGISTRY_HOST >${REGISTRY_HOST}< REGISTRY_HOST_CERT >${REGISTRY_HOST_CERT}<" 1>&2 ; fi
	if [ ! "${REGISTRY_HOST_CERT}" == "${REGISTRY_HOST}" ] ; then
        	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  The certificate, ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}:${REGISTRY_PORT}/certs/domain.crt, is for host ${REGISTRY_HOST_CERT} not ${REGISTRY_HOST}" 1>&2
        	exit 1
	fi
	#	Get registry certificate expiration date domain.crt
	REGISTRY_EXPIRE_DATE=$(openssl x509 -in ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}:${REGISTRY_PORT}/certs/domain.crt -noout -enddate | cut -d '=' -f 2)
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


#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
