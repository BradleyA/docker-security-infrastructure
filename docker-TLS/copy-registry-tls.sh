#!/bin/bash
# 	docker-TLS/copy-registry-tls.sh  3.143.557  2019-03-08T18:44:08.359006-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure-scripts.git  uadmin  six-rpi3b.cptx86.com 3.142  
# 	   create docker-TLS/create-registry-tls.sh update ARCHITECTURE TREE 
# 	docker-TLS/copy-registry-tls.sh  3.142.556  2019-03-06T23:19:58.300034-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure-scripts.git  uadmin  six-rpi3b.cptx86.com 3.141  
# 	   create docker-TLS/copy-registry-tls.sh #43 
### copy-registry-tls.sh - Copy TLS for Private Registry V2
#       Copyright (c) 2019 Bradley Allen
#       License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
###

echo -e "\n\nIn development\n\n"


#   production standard 5
#       Order of precedence: environment variable, default code
if [ "${DEBUG}" == "" ] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
#	set -x
#	set -v
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
###
display_help() {
echo -e "\n{NORMAL}${0} - Copy TLS for Private Registry V2"
echo -e "\nUSAGE\n   ${0} [<REGISTRY_HOST> <REGISTRY_PORT> <ABSOLUTE_PATH>]" 
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION"
#       Displaying help DESCRIPTION in English en_US.UTF-8
echo    "An administration user can run this script to copy . . . "

echo    "An administration user can run this script to copy Docker private registry"
echo    "certificates."

echo    "The <REGISTRY_PORT> number is not required when creating private registry"
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
echo -e "\nCONFIGURATION"
echo    "   /usr/local/                                           <-- <ABSOLUTE_PATH>"
echo    "    └── docker-registry-<REGISTRY_HOST>-<REGISTRY_PORT>/ <-- Container mount"
echo    "      └── certs/                                         <-- Cert directory"
echo    "        ├── domain.crt                                   <-- Registry cert"
echo    "        └── domain.key                                   <-- Registry key"
echo    "      └── docker/                                        <-- Registry storage"
echo -e "                                                             directory\n"
echo    "   \$HOME/.docker/                                       <-- Docker client cert"
echo    "                                                            directory"
echo    "    ├── docker-ca                                       <-- Working directory"
echo    "                                                            to create certs"
echo    "    └── registry-certs-<REGISTRY_HOST>-<REGISTRY_PORT>/ <-- Working directory"
echo    "                                                            to create registory"
echo -e "                                                            certs\n"
echo    "   /etc/docker/certs.d/                   <-- Host docker cert directory"
echo    "    ├── daemon                            <-- Daemon cert directory"
echo    "      ├── ca.pem                          <-- tlscacert"
echo    "      ├── cert.pem                        <-- tlscert"
echo    "      └── key.pem                         <-- tlskey"
echo    "    └── <REGISTRY_HOST>:<REGISTRY_PORT>/  <-- Registry cert directory"
echo    "      └── ca.crt                          <-- Registry cert"
echo -e "\nENVIRONMENT VARIABLES"
echo    "If using the bash shell, enter; 'export DEBUG=1' on the command line to set"
echo    "the DEBUG environment variable to '1' (0 = debug off, 1 = debug on).  Use the"
echo    "command, 'unset DEBUG' to remove the exported information from the DEBUG"
echo    "environment variable.  You are on your own defining environment variables if"
echo    "you are using other shells."
echo    "   DEBUG           (default '0')"
echo    "   REGISTRY_HOST   Registry host (default 'local host')"
echo    "   REGISTRY_PORT   Registry port number (default '5000')"
echo    "   REGISTRY_PORT   Registry port number (default '5000')"
echo    "   ABSOLUTE_PATH   Absolute path (default '/usr/local/')"
echo -e "\nOPTIONS"
echo    "   REGISTRY_HOST   Registry host (default 'local host')"
echo    "   REGISTRY_PORT   Registry port number (default '5000')"
echo    "   ABSOLUTE_PATH   Absolute path (default '/usr/local/')"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-security-infrastructure"
echo -e "\nEXAMPLES\n   ${0} two.cptx86.com 17313\n"
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

#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  1 ]  ; then REGISTRY_HOST=${1} ; elif [ "${REGISTRY_HOST}" == "" ] ; then REGISTRY_HOST=${LOCALHOST} ; fi
if [ $# -ge  2 ]  ; then REGISTRY_PORT=${2} ; elif [ "${REGISTRY_PORT}" == "" ] ; then REGISTRY_PORT="5000" ; fi
if [ $# -ge  3 ]  ; then ABSOLUTE_PATH=${3} ; elif [ "${ABSOLUTE_PATH}" == "" ] ; then ABSOLUTE_PATH="/usr/local/" ; fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... REGISTRY_HOST >${REGISTRY_HOST}< REGISTRY_PORT >${REGISTRY_PORT}< ABSOLUTE_PATH >${ABSOLUTE_PATH}<" 1>&2 ; fi

# >>>	need to change this to work on remote host that is running private registry
echo -e "\n\n\n >>>	need to change this script to work on remote host that is running private registry\n\n"

#	Check if user has home directory on system
if [ ! -d ${HOME} ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${USER} does not have a home directory on this system or ${USER} home directory is not ${HOME}" 1>&2
	exit 1
fi

#       Check if docker registry cert  directory on system
if [ ! -d ${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT} ] ; then
	display_help | more
	echo -e "\n\t${BOLD}${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}${NORMAL}"
	echo -e "\tdirectory not found on ${REGISTRY_HOST}.  Use create-registry-tls.sh to create"
	echo -e "\tdocker private registry certs."
	exit 1
fi
cd ${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}

#	Check if domain.crt 
if ! [ -e domain.crt ] ; then
	echo -e "\n\t${BOLD}domain.crt not found in $(pwd)${NORMAL}"
	exit 1
fi

#	Check if domain.key 
if ! [ -e domain.key ] ; then
	echo -e "\n\t${BOLD}domain.key not found in $(pwd)${NORMAL}"
	exit 1
fi

#	Check if ca.crt 
if ! [ -e ca.crt ] ; then
	echo -e "\n\t${BOLD}ca.crt not found in $(pwd)${NORMAL}"
	exit 1
fi

#	Create /etc/docker/certs.d/$REGISTRY_HOST:$REGISTRY_PORT
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Create /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}" 1>&2 ; fi
sudo mkdir -p /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}
sudo chmod 700 /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}

#       Check if ca.crt already exist
if [ -e /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt ] ; then
        echo -e "\n\t${BOLD}ca.crt${NORMAL} already exists, renaming existing keys so new keys can be copied.\n"
        mv /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt-$(date +%Y-%m-%dT%H:%M:%S%:z)
fi

#       For each Docker daemon to trust the Docker private registry certificate
#       Copy domain.crt file to /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt on every Docker host.
#       Restart Docker not required
sudo cp ${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}/domain.crt /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt
echo -e "\n\tCopy ${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}/domain.crt"
echo    "to /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt"
echo    "for each host requiring access to private registry
sudo cp ${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}/domain.crt /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt

sudo mkdir -p  /usr/local/docker-registry-${REGISTRY_HOST}-${REGISTRY_PORT}/certs
sudo chmod 700 /usr/local/docker-registry-${REGISTRY_HOST}-${REGISTRY_PORT}/certs

echo    ">>>	not sure how to find the UID and GID from namespace UID . . .  maybe get it from /usr/local/docker/#####.#####   <<<"
#	sudo chown -R #####:##### /usr/local/docker-registry-$REGISTRY_PORT

#       Check if domain.crt already exist
if [ -e /usr/local/docker-registry-${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt ] ; then
        echo -e "\n\t${BOLD}domain.crt${NORMAL} already exists, renaming existing keys so new keys can be copied.\n"
        mv /usr/local/docker-registry-${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt /usr/local/docker-registry-${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt-$(date +%Y-%m-%dT%H:%M:%S%:z)
fi

#       Check if domain.key already exist
if [ -e /usr/local/docker-registry-${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key ] ; then
        echo -e "\n\t${BOLD}domain.key${NORMAL} already exists, renaming existing keys so new keys can be copied.\n"
        mv /usr/local/docker-registry-${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key /usr/local/docker-registry-${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key-$(date +%Y-%m-%dT%H:%M:%S%:z)
fi

sudo cp $HOME/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}/domain.{crt,key} /usr/local/docker-registry-${REGISTRY_HOST}-${REGISTRY_PORT}/certs

#	I do not feel these two lines are need if the file owner is correct ??????  need to test before removing ????
#	sudo mkdir -p /usr/local/docker-registry-$REGISTRY_PORT/docker/registry
#	sudo chmod 777 /usr/local/docker-registry-$REGISTRY_PORT/docker/registry
#		   755

# >>>	 got this one to start with out any errors on port 5000 and 443
#		$ docker container run --detach --disable-content-trust --name private-registry-$REGISTRY_PORT --publish $REGISTRY_PORT:443 --volume /usr/local/docker-registry-$REGISTRY_PORT:/var/lib/registry  --env REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY=/var/lib/registry --volume /usr/local/docker-registry-$REGISTRY_PORT/certs:/certs  --env REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt --env REGISTRY_HTTP_TLS_KEY=/certs/domain.key registry:2

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
