#!/bin/bash
# 	dockerd-configuration-options/uninstall-dockerd-scripts.sh  3.238.688  2019-04-12T17:01:12.561469-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.237  
# 	   update production standard 
### production standard 3.0 shellcheck
### production standard 5.1.160 Copyright
#       Copyright (c) 2019 Bradley Allen
#       MIT License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
### production standard 1.0 DEBUG variable
#       Order of precedence: environment variable, default code
if [ "${DEBUG}" == "" ] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
#       set -x
#       set -v
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
### production standard 7.0 Default variable value
DEFAULT_WORK_DIRECTORY="/etc/docker/"
DEFAULT_UPSTART_SYSVINIT_DIRECTORY="/etc/default/"
# >>>	FUTURE	DEFAULT_CUSTOM_DOCKERD_CONFIGURATION_FILE=""
### production standard 0.1.166 --help
display_help() {
echo -e "\n${NORMAL}${0} - uninstall scripts that support dockerd on Systemd and Upstart"
echo -e "\nUSAGE"
echo    "   sudo ${0} [<WORK_DIRECTORY>]"
echo    "   sudo ${0}  <WORK_DIRECTORY> [<UPSTART_SYSVINIT_DIRECTORY>]"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION"
#       Displaying help DESCRIPTION in English en_US.UTF-8
echo    ">>> NEED TO COMPLETE THIS SOON, ONCE I KNOW HOW IT IS GOING TO WORK :-) <<<    |"

echo    "This script has to be run as root to remove scripts and files from /etc/docker"
echo    "and /etc/systemd/system."
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
echo    "   DEBUG                      (default off '0')"
echo -e "\nOPTIONS"
echo    "   WORK_DIRECTORY             Working directory (default ${DEFAULT_WORK_DIRECTORY})"
echo    "   UPSTART_SYSVINIT_DIRECTORY Ubuntu 14.04 (Upstart) dir (default ${DEFAULT_UPSTART_SYSVINIT_DIRECTORY})"
### production standard 6.1.177 Architecture tree
echo -e "\nARCHITECTURE TREE"   # STORAGE & CERTIFICATION
echo    "/etc/ "
echo    "├── docker/ "
echo    "│   ├── daemon.json                        <-- Daemon configuration file"
echo    "│   ├── key.json                           <-- Automatically generated dockerd"
echo    "│   │                                          key for TLS connections to other"
echo    "│   │                                          TLS servers"
echo    "│   ├── 10-override.begin                  <-- docker.service.d default lines"
echo    "│   ├── dockerd-configuration-file         <-- Daemon configuration"
echo    "│   ├── dockerd-configuration-file.service <- runs start-dockerd-with-systemd.sh"
echo    "│   │                                          during boot"
echo    "│   ├── docker.org                         <-- Copy of /etc/default/docker"
echo    "│   ├── README.md"
echo    "│   ├── setup-dockerd.sh                   <-- moves and creates files"
echo    "│   ├── start-dockerd-with-systemd.begin   <-- Beginning default lines"
echo    "│   ├── start-dockerd-with-systemd.end     <-- Ending default lines"
echo    "│   ├── start-dockerd-with-systemd.sh"
echo    "│   └── uninstall-dockerd-scripts.sh       <-- Removes files and scripts"
echo    "├── systemd/system/                        <-- Local systemd configurations"
echo    "│   ├── dockerd-configuration-file.service <-- Runs start-dockerd-with-systemd.sh"
echo    "│   ├── docker.service.d/"
echo    "│   │   └── 10-override.conf               <-- Override configutation file"
echo    "│   └── docker.service.wants/              <-- Dependencies"
echo    "└── default/"
echo    "    └── docker                             <-- Docker daemon Upstart and"
echo    "                                               SysVinit configuration file"
echo -e "\nDOCUMENTATION"
echo    "   https://github.com/BradleyA/docker-security-infrastructure/tree/master/dockerd-configuration-options"
echo -e "\nEXAMPLES"
echo -e "   To remove scripts and files using defulat directories\n\t${BOLD}sudo ${0}${NORMAL}"
echo    "   To use non-default directories for WORK_DIRECTORY (/mnt/etc/docker/) and"
echo -e "   UPSTART_SYSVINIT_DIRECTORY (/mnt/etc/default/)\n\t${BOLD}sudo ${0} /mnt/etc/docker/ /mnt/etc/default/${NORMAL}"
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
WORK_DIRECTORY=${1:-${DEFAULT_WORK_DIRECTORY}}
UPSTART_SYSVINIT_DIRECTORY=${2:-${DEFAULT_UPSTART_SYSVINIT_DIRECTORY}}
# >>>	FUTURE	CUSTOM_DOCKERD_CONFIGURATION_FILE=${3:-${DEFAULT_CUSTOM_DOCKERD_CONFIGURATION_FILE}}
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  WORK_DIRECTORY >${WORK_DIRECTORY} UPSTART_SYSVINIT_DIRECTORY >${UPSTART_SYSVINIT_DIRECTORY}< CUSTOM_DOCKERD_CONFIGURATION_FILE >${CUSTOM_DOCKERD_CONFIGURATION_FILE}<" 1>&2 ; fi

#	Begin uninstalling scripts and supporting files.
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Begin uninstalling scripts and supporting files." 1>&2

###
#       Root is required to copy certs
if ! [ $(id -u) = 0 ] ; then
        display_help | more
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Use sudo ${0}" 1>&2
#       Help hint
        echo -e "\n\t${BOLD}>>   SCRIPT MUST BE RUN AS ROOT   <<\n${NORMAL}"    1>&2
        exit 1
fi

#	Remove dockerd (Upstart and SysVinit configuration file) on Ubuntu 14.04
#	Check for ${WORK_DIRECTORY}
if [ ! -d "${WORK_DIRECTORY}" ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Is Docker installed?  Directory ${WORK_DIRECTORY} not found." 1>&2
else
	#	Removing files from ${WORK_DIRECTORY}
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Removing files from ${WORK_DIRECTORY}." 1>&2
	rm -f "${WORK_DIRECTORY}10-override.begin"
	rm -f "${WORK_DIRECTORY}dockerd-configuration-file"
	rm -f "${WORK_DIRECTORY}dockerd-configuration-file.service"
	rm -f "${WORK_DIRECTORY}README.md"
	rm -f "${WORK_DIRECTORY}setup-dockerd.sh"
	rm -f "${WORK_DIRECTORY}start-dockerd-with-systemd.begin"
	rm -f "${WORK_DIRECTORY}start-dockerd-with-systemd.end"
	rm -f "${WORK_DIRECTORY}start-dockerd-with-systemd.sh"
	#	Check for dockerd configuration file
	if [ -f "${UPSTART_SYSVINIT_DIRECTORY}docker" ] ; then
		echo "Copy ${WORK_DIRECTORY}docker.org to ${UPSTART_SYSVINIT_DIRECTORY}docker"
        	cp   "${WORK_DIRECTORY}docker.org"  "${UPSTART_SYSVINIT_DIRECTORY}docker"
	else
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  ${UPSTART_SYSVINIT_DIRECTORY}docker not found." 1>&2
	fi
	rm -f "${WORK_DIRECTORY}docker.org"
fi
echo -e "${NORMAL}\nIf you are using upstart, Run\t'${BOLD}sudo service docker restart${NORMAL}'\nfor dockerd to read ${UPSTART_SYSVINIT_DIRECTORY}docker.\n"	1>&2
 
#	Remove dockerd (systemd) on Ubuntu 16.04

#	Remove /etc/systemd/system/dockerd-configuration-file.service 
rm -f /etc/systemd/system/dockerd-configuration-file.service

#	Remove directories docker.service.d and docker.service.wants
rm -rf /etc/systemd/system/docker.service.d
rm -rf /etc/systemd/system/docker.service.wants
#
systemctl daemon-reload
#
echo -e "\tRun  '${BOLD}sudo systemctl restart docker${NORMAL}'"
echo -e "\tRun  '${BOLD}rm ${0}${NORMAL}'"  1>&2

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
