#!/bin/bash
# 	dockerd-configuration-options/uninstall-dockerd-scripts.sh  3.111.472  2019-01-20T00:05:38.061917-06:00 (CST)  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.110  
# 	   production standard 4 Internationalizing display-help close #39 
# 	dockerd-configuration-options/uninstall-dockerd-scripts.sh  3.90.447  2018-12-05T16:56:56.798629-06:00 (CST)  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.89  
# 	   added DEBUG environment variable, include process ID in ERROR, INFO, WARN, DEBUG statements, display_help | more , shellcheck #30 
#
### uninstall-dockerd-scripts.sh - uninstall scripts that support dockerd on Systemd and Upstart
#   production standard 4
#       Order of precedence: environment variable, default code
if [ "${DEBUG}" == "" ] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
#	set -v
#	set -x
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
###
display_help() {
echo -e "\n${NORMAL}${0} - uninstall scripts that support dockerd on Systemd and Upstart"
echo -e "\nUSAGE\n   sudo ${0} "
echo    "   sudo ${0} [<WORK_DIRECTORY>] [<UPSTART_SYSVINIT_DIRECTORY>}"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION"
#       Displaying help DESCRIPTION in English en_US.UTF-8
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
echo -e "\nEnvironment Variables"
echo    "If using the bash shell, enter; 'export DEBUG=1' on the command line to set"
echo    "the DEBUG environment variable to '1' (0 = debug off, 1 = debug on).  Use the"
echo    "command, 'unset DEBUG' to remove the exported information from the DEBUG"
echo    "environment variable.  You are on your own defining environment variables if"
echo    "you are using other shells."
echo    "   DEBUG       (default '0')"
echo -e "\nOPTIONS"
echo    "   WORK_DIRECTORY               working directory,"
echo    "                                default is /etc/docker/"
echo    "   UPSTART_SYSVINIT_DIRECTORY   Ubuntu 14.04 (Upstart) directory,"
echo    "                                default is /etc/default/"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-scripts/tree/master/dockerd-configuration-options"
echo -e "\nEXAMPLES\n   sudo ${0}\n\nTo remove scripts and files using defulat directories\n"
echo -e "   sudo ${0} /mnt/etc/docker/ /mnt/etc/default/\n"
echo -e "   To use non-default directories for WORK_DIRECTORY (/mnt/etc/docker/) and"
echo -e "   UPSTART_SYSVINIT_DIRECTORY (/mnt/etc/default/)\n"
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
WORK_DIRECTORY=${1:-/etc/docker/}
UPSTART_SYSVINIT_DIRECTORY=${2:-/etc/default/}
CONFIGURATION_STRING=${3:-Custom_dockerd_Configuration_File}
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  WORK_DIRECTORY >${WORK_DIRECTORY} UPSTART_SYSVINIT_DIRECTORY >${UPSTART_SYSVINIT_DIRECTORY}< CONFIGURATION_STRING >${CONFIGURATION_STRING}<" 1>&2 ; fi

#	Begin uninstalling scripts and supporting files.
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Begin uninstalling scripts and supporting files." 1>&2

#	Must be root to run this script
if ! [ $(id -u) = 0 ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Must be root to run this script.  Use sudo ${0}" 1>&2
	exit 1
fi

#	Remove dockerd (Upstart and SysVinit configuration file) on Ubuntu 14.04

#	Check for ${WORK_DIRECTORY}
if [ ! -d ${WORK_DIRECTORY} ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Is Docker installed?  Directory ${WORK_DIRECTORY} not found." 1>&2
else
	#	Removing files from ${WORK_DIRECTORY}
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Removing files from ${WORK_DIRECTORY}." 1>&2
	rm -f ${WORK_DIRECTORY}10-override.begin
	rm -f ${WORK_DIRECTORY}dockerd-configuration-file
	rm -f ${WORK_DIRECTORY}dockerd-configuration-file.service
	rm -f ${WORK_DIRECTORY}README.md
	rm -f ${WORK_DIRECTORY}setup-dockerd.sh
	rm -f ${WORK_DIRECTORY}start-dockerd-with-systemd.begin
	rm -f ${WORK_DIRECTORY}start-dockerd-with-systemd.end
	rm -f ${WORK_DIRECTORY}start-dockerd-with-systemd.sh
	#	Check for dockerd configuration file
	if [ -f ${UPSTART_SYSVINIT_DIRECTORY}docker ] ; then
		echo "Copy ${WORK_DIRECTORY}docker.org to ${UPSTART_SYSVINIT_DIRECTORY}docker"
        	cp   ${WORK_DIRECTORY}docker.org    ${UPSTART_SYSVINIT_DIRECTORY}docker
	else
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  ${UPSTART_SYSVINIT_DIRECTORY}docker not found." 1>&2
	fi
	rm -f ${WORK_DIRECTORY}docker.org
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
