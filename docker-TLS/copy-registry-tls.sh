#!/bin/bash
# 	docker-TLS/copy-registry-tls.sh  3.174.588  2019-04-04T21:51:35.491394-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  six-rpi3b.cptx86.com 3.173  
# 	   create docker-TLS/copy-registry-tls.sh close #43 ready for production 
### production standard 5.0 Copyright
#       Copyright (c) 2019 Bradley Allen
#       License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
###
#       Order of precedence: environment variable, default code
if [ "${DEBUG}" == "" ] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
#       set -x
#       set -v
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
### production standard 7.0 Default variable value
DEFAULT_REGISTRY_HOST=$(hostname -f)	# local host
DEFAULT_REGISTRY_PORT="17313"
DEFAULT_CLUSTER="us-tx-cluster-1/"
DEFAULT_DATA_DIR="/usr/local/data/"
DEFAULT_SYSTEMS_FILE="SYSTEMS"
###
display_help() {
echo -e "\n${NORMAL}${0} - Copy certs for Private Registry V2"
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
echo    "system to systems in <SYSTEMS_FILE> which MUST include the <REGISTRY_HOST>."
echo    "The certificates (domain.{crt,key}) for the <REGISTRY_HOST> are coped to it,"
echo    "into the following directory:"
echo    "<DATA_DIR>/<CLUSTER>/docker-registry/<REGISTRY_HOST>-<REGISTRY_PORT>/certs/."
echo    "The daemon registry domain cert (ca.crt) is copied to all the systems found"
echo    "in <SYSTEMS_FILE> in the following"
echo    "/etc/docker/certs.d/<REGISTRY_HOST>:<REGISTRY_PORT>/." 
echo -e "\nThe administration user may receive password and/or passphrase prompts from a"
echo    "remote systen; running the following may stop some prompts in your cluster."
echo -e "\tssh-copy-id <admin-user>@x.x.x.x"
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
echo    "   ├── docker-registry/                   <-- Docker registry directory"
echo    "   │   ├── <REGISTRY_HOST>-<REGISTRY_PORT>/ <-- Registry container mount"
echo    "   │   │   ├── certs/                     <-- Registry cert directory"
echo    "   │   │   │   ├── domain.crt             <-- Registry cert"
echo    "   │   │   │   └── domain.key             <-- Registry private key"
echo    "   │   │   └── docker/                    <-- Registry storage directory"
echo    "   │   └── <REGISTRY_HOST>-<REGISTRY_PORT>/ <-- Registry container mount"
echo    "   <STANDALONE>/                          <-- <STANDALONE> Architecture tree"
echo    "                                              is the same as <CLUSTER> TREE but"
echo -e "                                              the systems are not in a cluster\n"
echo    "~<USER-1>/.docker/                        <-- User docker cert directory"
echo    "   ├── registry-certs-<REGISTRY_HOST>-<REGISTRY_PORT>/ <-- Working directory to"
echo    "   │   │                                      create registory certs"
echo    "   │   ├── ca.crt                         <-- Daemon registry domain cert"
echo    "   │   ├── domain.crt                     <-- Registry cert"
echo    "   │   └── domain.key                     <-- Registry private key"
echo    "   └── registry-certs-<REGISTRY_HOST>-<REGISTRY_PORT>/ <-- Working directory to"
echo -e "                                              create registory certs\n"
echo    "/etc/ "
echo    "   docker/ "
echo    "   └── certs.d/                           <-- Host docker cert directory"
echo    "       ├── <REGISTRY_HOST>:<REGISTRY_PORT>/ <-- Registry cert directory"
echo    "       │   └── ca.crt                     <-- Daemon registry domain cert"
echo    "       └── <REGISTRY_HOST>:<REGISTRY_PORT>/ <-- Registry cert directory"
echo    "           └── ca.crt                     <-- Daemon registry domain cert"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-security-infrastructure/tree/master/docker-TLS"
echo -e "\nEXAMPLES\n   ${BOLD}${0} two.cptx86.com 17313${NORMAL}\n\n   Copy certs for Private Registry, two.cptx86.com, using port 17313\n"
echo -e "   ${BOLD}${0}${NORMAL}\n\n   Copy certs for Private Registry using environment variables and default options\n"
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

#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  1 ]  ; then REGISTRY_HOST=${1} ; elif [ "${REGISTRY_HOST}" == "" ] ; then REGISTRY_HOST=${DEFAULT_REGISTRY_HOST} ; fi
if [ $# -ge  2 ]  ; then REGISTRY_PORT=${2} ; elif [ "${REGISTRY_PORT}" == "" ] ; then REGISTRY_PORT=${DEFAULT_REGISTRY_PORT} ; fi
if [ $# -ge  3 ]  ; then CLUSTER=${3} ; elif [ "${CLUSTER}" == "" ] ; then CLUSTER=${DEFAULT_CLUSTER} ; fi
if [ $# -ge  4 ]  ; then DATA_DIR=${4} ; elif [ "${DATA_DIR}" == "" ] ; then DATA_DIR=${DEFAULT_DATA_DIR} ; fi
if [ $# -ge  5 ]  ; then SYSTEMS_FILE=${5} ; elif [ "${SYSTEMS_FILE}" == "" ] ; then SYSTEMS_FILE=${DEFAULT_SYSTEMS_FILE} ; fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... REGISTRY_HOST >${REGISTRY_HOST}< REGISTRY_PORT >${REGISTRY_PORT}< CLUSTER >${CLUSTER}< DATA_DIR >${DATA_DIR}< SYSTEMS_FILE >${SYSTEMS_FILE}<" 1>&2 ; fi

#	Check if user has home directory on system
if [ ! -d "${HOME}" ] ; then
	display_help | more
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${USER} does not have a home directory on this system or ${USER} home directory is not ${HOME}" 1>&2
	exit 1
fi

#       Check if docker registry cert directory on system
if [ ! -d "${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}" ] ; then
	display_help | more
	echo -e "\n\t${BOLD}${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}${NORMAL}"
	echo -e "\tdirectory not found on ${REGISTRY_HOST}.  Use create-registry-tls.sh to create"
	echo -e "\tdocker private registry certs.\n"
	exit 1
fi
cd "${HOME}/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}"

#	Check if domain.crt 
if ! [ -e domain.crt ] ; then
	echo -e "\n\t${BOLD}domain.crt not found in $(pwd)${NORMAL}\n"
	exit 1
fi

#	Check if domain.key 
if ! [ -e domain.key ] ; then
	echo -e "\n\t${BOLD}domain.key not found in $(pwd)${NORMAL}\n"
	exit 1
fi

#	Check if ca.crt 
if ! [ -e ca.crt ] ; then
	echo -e "\n\t${BOLD}ca.crt not found in $(pwd)${NORMAL}\n"
	exit 1
fi

#	Create tar file to copy $REGISTRY_HOST:$REGISTRY_PORT/ca.crt to hosts in <SYSTEMS_FILE>
mkdir -p          ./"${REGISTRY_HOST}:${REGISTRY_PORT}"
chmod 700         ./"${REGISTRY_HOST}:${REGISTRY_PORT}"
cp -p ./ca.crt    ./"${REGISTRY_HOST}:${REGISTRY_PORT}"
tar -cf           ./"${REGISTRY_HOST}.${REGISTRY_PORT}.tar" ./"${REGISTRY_HOST}:${REGISTRY_PORT}"
chmod 600         ./"${REGISTRY_HOST}.${REGISTRY_PORT}.tar"
rm -rf            ./"${REGISTRY_HOST}:${REGISTRY_PORT}"

#       Check if ${SYSTEMS_FILE} file is on system, one FQDN or IP address per line for all hosts in cluster
if ! [ -s "${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE}" ] ; then
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  ${BOLD}${SYSTEMS_FILE} file missing or empty, creating ${SYSTEMS_FILE} file with local host.  Edit ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE} file and add additional hosts that are in the cluster.${NORMAL}" 1>&2
        mkdir -p "${DATA_DIR}/${CLUSTER}"
        echo -e "#\n# "  > ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE}
        echo -e "### ${SYSTEMS_FILE}"  >> ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE}
        echo -e "#      Created: ${DATE_STAMP} ${LOCALHOST}"  >> ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE}
        echo -e "#      List of hosts for scripts Linux-admin/cluster-command/cluster-command.sh,"  >> ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE}
        echo -e "#      markit/find-code.sh, pi-display/create-message/create-message.sh,"  >> ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE}
        echo -e "#      and other scripts."  >> ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE}
        echo -e "#\n#   One FQDN or IP address per line for all hosts in cluster" >> ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE}
        echo -e "###" >> ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE}
        echo -e "${REGISTRY_HOST}" >> ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE}
fi

#       Loop through hosts in ${SYSTEMS_FILE} file and update other host information
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Begin loop through hosts in ${SYSTEMS_FILE} file and update other host information" 1>&2 ; fi
for NODE in $(cat "${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE}" | grep -v "#" ) ; do
	if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Copy files to host ${NODE}" 1>&2 ; fi

#       Check if ${NODE} is ${LOCALHOST}
        if [ "${LOCALHOST}" != "${NODE}" ] ; then

#       	Check if ${NODE} is available on ssh port
		if $(ssh ${NODE} 'exit' >/dev/null 2>&1 ) ; then

#			For each Docker daemon to trust the Docker private registry certificate
#			Copy ca.crt file to /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt on every Docker host.
#			Restart Docker not required
			if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Checks complete; ${NODE}; Copy to /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}" 1>&2 ; fi
			echo -e "\n\tCopy ~/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}/ca.crt"
			echo -e "\tto ${BOLD}${NODE}${NORMAL} /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt"
			scp -q -p -i ~/.ssh/id_rsa ./${REGISTRY_HOST}.${REGISTRY_PORT}.tar ${USER}@${NODE}:/tmp
			TEMP="sudo mkdir -p /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT} ; if sudo [ -s /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt ] ; then echo -e '\n\t${BOLD}ca.crt${NORMAL} already exists, renaming existing keys so new keys can be copied.' ; sudo mv /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt-$(date +%Y-%m-%dT%H:%M:%S%:z); fi ; sudo tar -xf /tmp/${REGISTRY_HOST}.${REGISTRY_PORT}.tar --owner=root --group=root --directory /etc/docker/certs.d ; sudo rm -f /tmp/${REGISTRY_HOST}.${REGISTRY_PORT}.tar"
                        ssh -q -t -i ~/.ssh/id_rsa ${USER}@${NODE} ${TEMP}
                else
                        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  ${NODE} found in ${DATA_DIR}/${CLUSTER}/${SYSTEMS_FILE} file is not responding to ${LOCALHOST} on ssh port." 1>&2
                fi
	else
		echo -e "\n\tCopy ~/.docker/registry-certs-${REGISTRY_HOST}-${REGISTRY_PORT}/ca.crt"
		echo -e "\tto ${BOLD}${NODE}${NORMAL} /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt"
		sudo mkdir -p /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}

#       	Check if ca.crt already exist
		if sudo [ -s /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt ] ; then
        		echo -e "\n\t${BOLD}ca.crt${NORMAL} already exists, renaming existing keys so new keys can be copied."
        		sudo mv /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt-$(date +%Y-%m-%dT%H:%M:%S%:z)
		fi

#       	For each Docker daemon to trust the Docker private registry certificate
#       	Copy ca.crt file to /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}/ca.crt on every Docker host.
#       	Restart Docker not required
		if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  LOCALHOST; Copy to /etc/docker/certs.d/${REGISTRY_HOST}:${REGISTRY_PORT}" 1>&2 ; fi
		sudo tar -xf ./${REGISTRY_HOST}.${REGISTRY_PORT}.tar --owner=root --group=root --directory /etc/docker/certs.d
        fi
done
rm -f   ./${REGISTRY_HOST}.${REGISTRY_PORT}.tar

#	Copy files to ${REGISTRY_HOST}
#	Check if localhost = registry host
echo -e "\n\tCopy domain.{crt,key} to ${USER}@${REGISTRY_HOST}:~/.docker/"
if [ "${LOCALHOST}" != "${REGISTRY_HOST}" ] ; then

#      	Check if ${REGISTRY_HOST} is available on ssh port
	if $(ssh ${REGISTRY_HOST} 'exit' >/dev/null 2>&1 ) ; then

#		Copy domain.{crt,key} to ${USER}@${REGISTRY_HOST}:~/.docker/
		if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Copy domain.{crt,key} to ${USER}@${REGISTRY_HOST}:~/.docker/" 1>&2 ; fi
		scp -q -p -i ~/.ssh/id_rsa ./domain.{crt,key} ${USER}@${REGISTRY_HOST}:~/.docker/
     set -x
		REMAP=$(ssh -q -t  -i ~/.ssh/id_rsa uadmin@two.cptx86.com "ps -ef | grep remap | wc -l | tr -d '\r\n'")
		REMAPUID=$(ssh -q -t  -i ~/.ssh/id_rsa uadmin@two.cptx86.com "grep dockremap /etc/subuid | cut -d ':' -f 2 | tr -d '\r\n'")
     set +x
		TEMP="sudo mkdir -p  ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs ; if sudo [ -e ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt ] ; then echo -e '\n\t${BOLD}domain.crt${NORMAL} already exists, renaming existing keys so new keys can be copied.' ; sudo mv ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt-$(date +%Y-%m-%dT%H:%M:%S%:z) ; fi ; if sudo [ -e ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key ] ; then echo -e '\n\t${BOLD}domain.key${NORMAL} already exists, renaming existing keys so new keys can be copied.' ; sudo mv ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key-$(date +%Y-%m-%dT%H:%M:%S%:z) ; fi ; sudo mv ~/.docker/domain.{crt,key} ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs ; if [ ${REMAP} -ge 3 ] ; then  sudo chown -R ${REMAPUID}.${REMAPUID} ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs ; fi'"
     set -x
		ssh -q -t -i ~/.ssh/id_rsa ${USER}@${REGISTRY_HOST} ${TEMP}
     set +x
	else
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${REGISTRY_HOST} is not responding to ${LOCALHOST} on ssh port. " 1>&2
		exit 1
	fi
else

#	Create REGISTRY_HOST certs directory
	sudo mkdir -p  ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs

#       Check if domain.crt already exist
	if sudo [ -e ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt ] ; then
		echo -e "\n\t${BOLD}domain.crt${NORMAL} already exists, renaming existing keys so new keys can be copied."
		sudo mv ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.crt-$(date +%Y-%m-%dT%H:%M:%S%:z)
	fi

#       Check if domain.key already exist
	if sudo [ -e ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key ] ; then
		echo -e "\n\t${BOLD}domain.key${NORMAL} already exists, renaming existing keys so new keys can be copied."
		sudo mv ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs/domain.key-$(date +%Y-%m-%dT%H:%M:%S%:z)
	fi

#	Copy files to ${LOCALHOST} for ${REGISTRY_HOST}
	sudo cp -p ./domain.{crt,key} ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs

#	Change directory and file permissions if dockerd using --userns-remap=default
	if [ $(ps -ef | grep remap | wc -l) == 2 ] ; then
#		Currently when using --userns-remap=default with dockerd the UID and GID are the same as ID
		DOCKREMAP=$(grep dockremap /etc/subuid | cut -d ':' -f 2)
		sudo chown -R ${DOCKREMAP}.${DOCKREMAP} ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs ${DATA_DIR}/${CLUSTER}/docker-registry/${REGISTRY_HOST}-${REGISTRY_PORT}/certs
	fi
fi

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
