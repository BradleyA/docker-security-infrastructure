#!/bin/bash
# 	dockerd-configuration-options/setup-dockerd.sh  3.266.733  2019-06-07T22:17:55.369699-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.265  
# 	   dockerd-configuration-options{setup-dockerd.sh,uninstall-dockerd-scripts.sh} - added production standard 8.0 --usage #53 
# 	dockerd-configuration-options/setup-dockerd.sh  3.240.690  2019-04-15T09:49:31.653272-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  six-rpi3b.cptx86.com 3.239  
# 	   correct incident chown chmod /etc/docker/* not found 
# 	dockerd-configuration-options/setup-dockerd.sh  3.235.685  2019-04-11T23:02:08.821768-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.234-5-g2b3f0c6  
# 	   added production standard and ran shell check need to test more 
### production standard 3.0 shellcheck
### production standard 5.1.160 Copyright
#       Copyright (c) 2019 Bradley Allen
#       MIT License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
### production standard 1.0 DEBUG variable
#       Order of precedence: environment variable, default code
if [ "${DEBUG}" == "" ] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
#	set -v
#	set -x
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
### production standard 7.0 Default variable value
DEFAULT_WORK_DIRECTORY="/etc/docker/"
DEFAULT_UPSTART_SYSVINIT_DIRECTORY="/etc/default/"
### production standard 8.0 --usage
display_usage() {
echo -e "\n${NORMAL}${0} - setup system to support dockerd on Systemd and Upstart."
echo -e "\nUSAGE"
echo    "   sudo ${0} [<WORK_DIRECTORY>]"
echo -e "   sudo ${0}  <WORK_DIRECTORY> [<UPSTART_SYSVINIT_DIRECTORY>]\n"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--usage | -usage | -u]"
echo    "   ${0} [--version | -version | -v]"
}
### production standard 0.1.166 --help
display_help() {
display_usage
#       Displaying help DESCRIPTION in English en_US.UTF-8
echo -e "\nDESCRIPTION"
echo    "This script has to be run as root to move files into /etc/docker and create or"
echo    "update the /etc/systemd/system/docker.service.d/10-override.conf file (Ubuntu"
echo    "16.04, systemd) and the /etc/default/docker (Ubuntu 14.04, Upstart).  To"
echo    "change the docker daemon flags,"
echo -e "\t${BOLD}sudo edit /etc/docker/dockerd-configuration-file${NORMAL}"
echo    "and run"
echo -e "\t${BOLD}sudo /etc/docker/setup-dockerd.sh${NORMAL}"
echo    "Docker daemon flag changes can be distributed to any Ubuntu cluster that use"
echo    "systemd or upstart by copying /etc/docker/dockerd-configuration-file to each"
echo    "system and running"
echo -e "\t${BOLD}sudo /etc/docker/setup-dockerd.sh${NORMAL}"
echo    "on each system."
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
echo    "   DEBUG                       (default off '0')"
echo -e "\nOPTIONS"
echo    "   WORK_DIRECTORY              working directory (default ${DEFAULT_WORK_DIRECTORY})"
echo    "   UPSTART_SYSVINIT_DIRECTORY  Ubuntu 14.04 (Upstart) dir (default ${DEFAULT_UPSTART_SYSVINIT_DIRECTORY})"
# >>>	FUTURE	echo    "   CONFIGURATION_STRING   >> no use case currently, future development <<<"
# >>>	FUTURE	echo    "                          default is Custom_dockerd_Configuration_File"
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
echo -e "   Setup system to support dockerd on Systemd and Upstart using default values.\n\t${BOLD}sudo ${0}${NORMAL}"
echo    "   Setup system to support dockerd on Systemd and Upstart using"
echo    "   /mnt/etc/docker/ for the <WORK_DIRECTORY> and /mnt/etc/default/ for the"
echo -e "   <UPSTART_SYSVINIT_DIRECTORY>.\n\t${BOLD}sudo ${0} /mnt/etc/docker/ /mnt/etc/default/${NORMAL}"
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

#       Default help and, usage, version arguments
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] ; then
        display_help | more
        exit 0
fi
if [ "$1" == "--usage" ] || [ "$1" == "-usage" ] || [ "$1" == "usage" ] || [ "$1" == "-u" ] ; then
        display_usage | more
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
WORK_DIRECTORY=${1:-${DEFAULT_WORK_DIRECTORY}}
UPSTART_SYSVINIT_DIRECTORY=${2:-${DEFAULT_UPSTART_SYSVINIT_DIRECTORY}}
# >>>   FUTURE  CONFIGURATION_STRING=${3:-Custom_dockerd_Configuration_File}
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  WORK_DIRECTORY >${WORK_DIRECTORY}< UPSTART_SYSVINIT_DIRECTORY >${UPSTART_SYSVINIT_DIRECTORY}< CONFIGURATION_STRING >${CONFIGURATION_STRING}<" 1>&2 ; fi
echo -e "\n\tChanges made to ${WORK_DIRECTORY}dockerd-configuration-file will be\n\tadded to Upstart and Systemd configuration files for dockerd." 1>&2

#       Root is required to copy certs
if ! [ $(id -u) = 0 ] ; then
        display_help | more
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Use sudo ${0}" 1>&2
#       Help hint
        echo -e "\n\t${BOLD}>>   SCRIPT MUST BE RUN AS ROOT   <<\n${NORMAL}"    1>&2
        exit 1
fi

#	Check for ${WORK_DIRECTORY}
if [ ! -d "${WORK_DIRECTORY}" ] ; then
	get_date_stamp ; echo -e "\n${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Is Docker installed?  Directory ${WORK_DIRECTORY} not found." 1>&2
	exit 1
elif [ ! -f "${WORK_DIRECTORY}setup-dockerd.sh" ] ; then
	#	Move files into /etc/docker ${WORK_DIRECTORY} if not already moved
	echo -e "\n\tMove files to ${WORK_DIRECTORY}\n"
	mv 10-override.begin			"${WORK_DIRECTORY}"
	mv dockerd-configuration-file		"${WORK_DIRECTORY}"
	mv dockerd-configuration-file.service	"${WORK_DIRECTORY}"
	mv README.md				"${WORK_DIRECTORY}"
	mv setup-dockerd.sh			"${WORK_DIRECTORY}"
	mv start-dockerd-with-systemd.begin	"${WORK_DIRECTORY}"
	mv start-dockerd-with-systemd.end	"${WORK_DIRECTORY}"
	mv uninstall-dockerd-scripts.sh		"${WORK_DIRECTORY}"
	$(cd "${WORK_DIRECTORY}" ; chown root.root *)
	$(cd "${WORK_DIRECTORY}" ; chmod go-rxw *)
else
	get_date_stamp ; echo -e "\n${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Skipping installation because ${WORK_DIRECTORY}setup-dockerd.sh is already installed.  Updating Docker daemon with changes in ${WORK_DIRECTORY}dockerd-configuration-file.\n" 1>&2
fi
 
###	Configure dockerd (Upstart and SysVinit configuration file) on Ubuntu 14.04
#		Any changes to dockerd-configuration-file will be added to ${UPSTART_SYSVINIT_DIRECTORY}docker
echo -e "\tUpdate files for dockerd (Upstart and SysVinit configuration file)\n\tfor Ubuntu 14.04."	1>&2
#	Check for dockerd configuration file
if [ -f "${UPSTART_SYSVINIT_DIRECTORY}docker" ] ; then
	#	copy ${UPSTART_SYSVINIT_DIRECTORY}docker to ${WORK_DIRECTORY}docker.org
	cp "${UPSTART_SYSVINIT_DIRECTORY}docker"  "${WORK_DIRECTORY}docker.org"
	if grep -qF "${CONFIGURATION_STRING}"  "${WORK_DIRECTORY}docker.org" ; then 
		if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Remove previous dockerd configuration." 1>&2 ; fi
		#	Locate line number of ${CONFIGURATION_STRING} in ${WORK_DIRECTORY}docker
		LINE=$(grep -n "${CONFIGURATION_STRING}"  "${WORK_DIRECTORY}docker.org" | cut -f1 -d:)
		LINE=$(echo ${LINE} | awk '{print $1 - 1}')
		#	Write line one to ${LINE} number into ${WORK_DIRECTORY}docker
		head -n +${LINE} "${WORK_DIRECTORY}docker.org" > "${WORK_DIRECTORY}docker"
	else
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Copy ${WORK_DIRECTORY}docker.org to ${WORK_DIRECTORY}docker without ${CONFIGURATION_STRING} section." 1>&2
		cp "${WORK_DIRECTORY}docker.org"  "${WORK_DIRECTORY}docker"
	fi

#	Append ${WORK_DIRECTORY}dockerd-configuration-file onto ${WORK_DIRECTORY}docker
	if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Append ${WORK_DIRECTORY}dockerd-configuration-file onto ${WORK_DIRECTORY}docker." 1>&2 ; fi
	cat "${WORK_DIRECTORY}dockerd-configuration-file" >> "${WORK_DIRECTORY}docker"
	if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Move ${WORK_DIRECTORY}docker to ${UPSTART_SYSVINIT_DIRECTORY}docker" 1>&2 ; fi
	mv "${WORK_DIRECTORY}docker"  "${UPSTART_SYSVINIT_DIRECTORY}docker"
fi
echo -e "\t. . . dockerd for Ubuntu 14.04 has been updated." 1>&2
echo -e "\n\tIf you are using upstart, \n\tRun '${BOLD}sudo service docker restart${NORMAL}'\n\tfor dockerd to read ${UPSTART_SYSVINIT_DIRECTORY}docker.\n"	1>&2

###	Configure dockerd (systemd) on Ubuntu 16.04
#		Any changes to dockerd-configuration-file will be added to ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
START_SYSTEMD_SCRIPT="start-dockerd-with-systemd.sh"
echo -e "\tUpdate files for dockerd (systemd configuration file)\n\ton Ubuntu 16.04.\n"	1>&2
cat "${WORK_DIRECTORY}start-dockerd-with-systemd.begin" > "${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}"
cat "${WORK_DIRECTORY}dockerd-configuration-file" >> "${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}"
cat "${WORK_DIRECTORY}start-dockerd-with-systemd.end" >> "${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}"
chmod 700 "${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}"
"${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}"

#	Add /etc/systemd/system/dockerd-configuration-file.service to systemd
cp "${WORK_DIRECTORY}/dockerd-configuration-file.service"  /etc/systemd/system/
systemctl daemon-reload
echo -e "\n\tIf you are using systemd, Run\n\t'${BOLD}sudo systemctl enable dockerd-configuration-file.service${NORMAL}'\n\tto start on boot."	1>&2
echo -e "\tRun '${BOLD}sudo systemctl enable docker${NORMAL}'\n\tto start on boot."	1>&2
echo -e "\tRun '${BOLD}sudo systemctl restart docker${NORMAL}'\n"	1>&2

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
