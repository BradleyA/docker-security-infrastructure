#!/bin/bash
# 	docker-TLS/copy-registry-tls.sh  3.159.573  2019-03-27T21:34:28.527120-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure-scripts.git  uadmin  six-rpi3b.cptx86.com 3.158  
# 	   docker-TLS/create-registry-tls.sh update tree #41 
# 	docker-TLS/copy-registry-tls.sh  3.142.556  2019-03-06T23:19:58.300034-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure-scripts.git  uadmin  six-rpi3b.cptx86.com 3.141  
# 	   create docker-TLS/copy-registry-tls.sh #43 
#
echo "In development            In developmen           In developmentt         In development          In development"
echo "          In development          In developmen           In developmentt         In development          In development"
#   production standard 5
### copy-registry-tls.sh - Copy TLS for Private Registry V2
#       Copyright (c) 2019 Bradley Allen
#       License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
###
#       Order of precedence: environment variable, default code
if [ "${DEBUG}" == "" ] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
#	set -x
#	set -v
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
###
display_help() {
echo -e "\n{NORMAL}${0} - Copy certs for Private Registry V2"
echo -e "\nUSAGE\n   ${0} [<REGISTRY_HOST>]" 
echo    "   ${0}  <REGISTRY_HOST> [<REGISTRY_PORT>]" 
echo    "   ${0}  <REGISTRY_HOST>  <REGISTRY_PORT> [<CLUSTER>]" 
echo    "   ${0}  <REGISTRY_HOST>  <REGISTRY_PORT>  <CLUSTER>  [<DATA_DIR>]" 
echo    "   ${0}  <REGISTRY_HOST>  <REGISTRY_PORT>  <CLUSTER>   <DATA_DIR>  [<SYSTEMS_FILE>]" 
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
#       Displaying help DESCRIPTION in English en_US.UTF-8
echo -e "\nDESCRIPTION"
echo    "A user with administration authority uses this script to copy Docker private"
echo    "registry certificates from "
echo    "~/.docker/registry-certs-<REGISTRY_HOST>-<REGISTRY_PORT> directory on this"
echo    "system to the <REGISTRY_HOST> and systems in <SYSTEMS_FILE>.  The certificates"
echo    "(domain.{crt,key}) for the <REGISTRY_HOST> are coped to it, into the following"
echo    "<DATA_DIR>/<CLUSTER>/docker-registry/<REGISTRY_HOST>-<REGISTRY_PORT>/certs/."
echo    "The daemon registry domain cert (ca.crt) is copied to the <REGISTRY_HOST> and"
echo    "all the systems found in <SYSTEMS_FILE> in the following"
echo    "/etc/docker/certs.d/<REGISTRY_HOST>:<REGISTRY_PORT>/." 
echo -e "\nThe administration user may receive password and/or passphrase prompts from a"
echo    "remote systen; running the following may stop the prompts in your cluster."
echo    "   ssh-copy-id <admin-user>@x.x.x.x"
echo -e "\nThe <DATA_DIR>/<CLUSTER>/<SYSTEMS_FILE> includes one FQDN or IP address per"
echo    "line for all hosts in the cluster.  Lines in <SYSTEMS_FILE> that begin with a"
echo    "'#' are comments.  The <SYSTEMS_FILE> is used by markit/find-code.sh,"
echo    "Linux-admin/cluster-command/cluster-command.sh, docker-TLS/copy-registry-tls.sh," 
echo    "pi-display/create-message/create-display-message.sh, and other scripts.  A"
echo    "different <SYSTEMS_FILE> can be entered on the command line or environment"
echo    "variable."
#   production standard 4
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
echo    "   REGISTRY_HOST   Registry host (default 'local host')"
echo    "   REGISTRY_PORT   Registry port number (default '5000')"
echo    "   CLUSTER         (default us-tx-cluster-1/)"
echo    "   DATA_DIR        (default /usr/local/data/)"
echo -e "\nOPTIONS"
echo    "   REGISTRY_HOST   Registry host (default 'local host')"
echo    "   REGISTRY_PORT   Registry port number (default '5000')"
echo    "   CLUSTER         (default us-tx-cluster-1/)"
echo    "   DATA_DIR        (default /usr/local/data/)"
#   production standard 6
echo -e "\nSTORAGE & CERTIFICATION ARCHITECTURE TREE"
echo    "/usr/local/data/                            <-- <DATA_DIR>"
echo    "   <CLUSTER>/                               <-- <CLUSTER>"
echo    "   ├── SYSTEMS                              <-- List of hosts in cluster"
echo    "   └── docker-registry/                     <-- Docker registry directory"
echo    "       ├── <REGISTRY_HOST>-<REGISTRY_PORT>/ <-- Registry container mount"
echo    "       │   │── certs/                       <-- Registry cert directory"
echo    "       │   │   ├── domain.crt               <-- Registry cert"
echo    "       │   │   └── domain.key               <-- Registry key"
echo    "       │   └── docker/                      <-- Registry storage directory"
echo -e "       └── <REGISTRY_HOST>-<REGISTRY_PORT>/ <-- Registry container mount\n"
echo    "~<USER-1>/.docker/                          <-- User docker cert directory"
echo    "   └── registry-certs-<REGISTRY_HOST>-<REGISTRY_PORT>/ <-- Working directory"
echo    "       │                                        to create registory certs"
echo    "       ├── ca.crt                           <-- Daemon trust registry cert"
echo    "       ├── domain.crt                       <-- Registry cert"
echo -e "       └── domain.key                       <-- Registry key\n"
echo    "/etc/docker/certs.d/                        <-- Host docker cert directory"
echo    "   ├── <REGISTRY_HOST>:<REGISTRY_PORT>/     <-- Registry cert directory"
echo    "   │   └── ca.crt                           <-- Daemon trust registry cert"
echo    "   └── <REGISTRY_HOST>:<REGISTRY_PORT>/     <-- Registry cert directory"
echo    "       └── ca.crt                           <-- Daemon trust registry cert"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-security-infrastructure/tree/master/docker-TLS"
echo -e "\nEXAMPLES\n   ${BOLD}sudo ${0} two.cptx86.com 17313${NORMAL}\n"
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

###		>>>   not sure need to be root  just sudo -i;exit or  need to think more about this
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
if [ $# -ge  3 ]  ; then CLUSTER=${3} ; elif [ "${CLUSTER}" == "" ] ; then CLUSTER="us-tx-cluster-1/" ; fi
if [ $# -ge  4 ]  ; then DATA_DIR=${4} ; elif [ "${DATA_DIR}" == "" ] ; then DATA_DIR="/usr/local/data/" ; fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... REGISTRY_HOST >${REGISTRY_HOST}< REGISTRY_PORT >${REGISTRY_PORT}< CLUSTER >${CLUSTER}< DATA_DIR >${DATA_DIR}<" 1>&2 ; fi


# >>>	need to change this to work on remote host that is running private registry
echo -e "\n\n\n >>>	need to change this script to work on remote hosts in SYSTEMS file that is running private registry\n\n"
# >>>

# >>>	Check if localhost = registry host

#	Check if user has home directory on system
if [ ! -d ${HOME} ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${USER} does not have a home directory on this system or ${USER} home directory is not ${HOME}" 1>&2
	exit 1
fi

#       Check if docker registry cert directory on system
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

# >>>	Do not assume the LOCALHOST is $REGISTRY_HOST
# >>>	IS LOCALHOST = $REGISTRY_HOST then 

# >>>	elso login to $REGISTRY_HOST

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
#       Copy ca.crt file to /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt on every Docker host.
#       Restart Docker not required
sudo cp ${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}/ca.crt /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt
echo -e "\n\tCopy ${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}/ca.crt"
echo    "to /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt"
echo    "for each host requiring access to private registry"

# >>>	Check if localhost = registry host

# >>>	If NOT echo incident / connecting to remote host ${REGISTRY_HOST} test ERROR else cp files to ${REGISTRY_HOST}

# >>>	x

sudo mkdir -p  ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs
sudo chmod 700 ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs

echo    ">>>	not sure how to find the UID and GID from namespace UID . . .  maybe get it from ${DATA_DIR}/${CLUSTER}/docker/#####.#####   <<<"
#	sudo chown -R #####:##### ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-$REGISTRY_PORT

#       Check if domain.crt already exist
if [ -e ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt ] ; then
        echo -e "\n\t${BOLD}domain.crt${NORMAL} already exists, renaming existing keys so new keys can be copied.\n"
        mv ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt-$(date +%Y-%m-%dT%H:%M:%S%:z)
fi

#       Check if domain.key already exist
if [ -e ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key ] ; then
        echo -e "\n\t${BOLD}domain.key${NORMAL} already exists, renaming existing keys so new keys can be copied.\n"
        mv ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key-$(date +%Y-%m-%dT%H:%M:%S%:z)
fi

sudo cp $HOME/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}/domain.{crt,key} ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs

#	I do not feel these two lines are needed if the file owner is correct ??????  need to test before removing ????
#	sudo mkdir -p ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/docker/registry
#	sudo chmod 755 ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/docker/registry

# >>>	 got this one to start with out any errors on port 5000 and 443
#		$ docker container run --detach --disable-content-trust --name private-registry-$REGISTRY_PORT --publish $REGISTRY_PORT:443 --volume ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}:/var/lib/registry  --env REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY=/var/lib/registry --volume ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs:/certs  --env REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt --env REGISTRY_HTTP_TLS_KEY=/certs/domain.key registry:2

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
