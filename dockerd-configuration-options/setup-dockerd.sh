#!/bin/bash
# 	dockerd-configuration-options/setup-dockerd.sh  3.73.430  2018-10-22T20:56:08.318039-05:00 (CDT)  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.72  
# 	   setup-dockerd.sh Change echo or print DEBUG INFO WARNING ERROR close #27 
# 	setup-dockerd.sh  3.43.392  2018-08-12_12:32:51_CDT  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.42  
# 	   added note about skipping install and configurating daemon chnages 
# 	dockerd-configuration-options/setup-dockerd.sh  3.42.391  2018-08-12_10:59:20_CDT  https://github.com/BradleyA/docker-scripts  uadmin  three-rpi3b.cptx86.com 3.41-8-g21e9f27  
# 	   sync to standard script design changes 
# 	setup-dockerd.sh  3.30.367  2018-06-23_17:52:30_CDT  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.29  
# 	   added mv uninstall-dockerd-scripts.sh to /etc/docker 
#
###	setup-dockerd.sh - setup system to support dockerd on Systemd and Upstart
DEBUG=0                 # 0 = debug off, 1 = debug on
#	set -v
#	set -x
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
###
display_help() {
echo -e "\n${NORMAL}${0} - setup system to support dockerd on Systemd and Upstart."
echo -e "\nUSAGE\n   sudo ${0} "
echo    "   sudo ${0} [<WORK_DIRECTORY>] [<UPSTART_SYSVINIT_DIRECTORY>]"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION\nThis script has to be run as root to move files into /etc/docker and create"
echo    "or update the /etc/systemd/system/docker.service.d/10-override.conf"
echo    "file (Ubuntu 16.04, systemd) and the /etc/default/docker (Ubuntu"
echo    "14.04, Upstart). To change the docker daemon flags, sudo edit"
echo    "/etc/docker/dockerd-configuration-file and run sudo"
echo    "/etc/docker/setup-dockerd.sh. Docker daemon flag changes can be"
echo    "distributed to any Ubuntu cluster that use systemd or upstart by"
echo    "copying /etc/docker/dockerd-configuration-file to each system and"
echo    "running sudo /etc/docker/setup-dockerd.sh on each system."
echo -e "\nOPTIONS"
echo    "   WORK_DIRECTORY               working directory,"
echo    "                                default is /etc/docker/"
echo    "   UPSTART_SYSVINIT_DIRECTORY   Ubuntu 14.04 (Upstart) directory,"
echo    "                                default is /etc/default/"
#	echo    "   CONFIGURATION_STRING   >> no use case currently, future development <<<"
#	echo    "                          default is Custom_dockerd_Configuration_File"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-scripts/tree/master/dockerd-configuration-options"
echo -e "\nEXAMPLES\n   sudo ${0}\n"
echo -e "   sudo ${0} /mnt/etc/docker/ /mnt/etc/default/\n"
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

#       Added line because USER is not defined in crobtab jobs
if ! [ "${USER}" == "${LOGNAME}" ] ; then  USER=${LOGNAME} ; fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  USER  >${USER}<  LOGNAME >${LOGNAME}<" 1>&2 ; fi

#       UID and GID
USER_ID=`id -u`
GROUP_ID=`id -g`

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
WORK_DIRECTORY=${1:-/etc/docker/}
UPSTART_SYSVINIT_DIRECTORY=${2:-/etc/default/}
CONFIGURATION_STRING=${3:-Custom_dockerd_Configuration_File}
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  WORK_DIRECTORY >${WORK_DIRECTORY}< UPSTART_SYSVINIT_DIRECTORY >${UPSTART_SYSVINIT_DIRECTORY}< CONFIGURATION_STRING >${CONFIGURATION_STRING}<" 1>&2 ; fi
echo -e "\nChanges made to ${WORK_DIRECTORY}dockerd-configuration-file will be\nadded to Upstart and Systemd configuration files for dockerd.\n" 1>&2

#	Must be root to run this script
if ! [ $(id -u) = 0 ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Must be root to run this script.  Use ${BOLD}sudo ${0}${NORMAL}" 1>&2
	exit 1
fi

#	Check for ${WORK_DIRECTORY}
if [ ! -d ${WORK_DIRECTORY} ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Is Docker installed?  Directory ${WORK_DIRECTORY} not found." 1>&2
	exit 1
elif [ ! -f ${WORK_DIRECTORY}setup-dockerd.sh ] ; then
	#	Move files into /etc/docker ${WORK_DIRECTORY} if not already moved
	echo "Move files to ${WORK_DIRECTORY}."
	mv 10-override.begin			${WORK_DIRECTORY}
	mv dockerd-configuration-file		${WORK_DIRECTORY}
	mv dockerd-configuration-file.service	${WORK_DIRECTORY}
	mv README.md				${WORK_DIRECTORY}
	mv setup-dockerd.sh			${WORK_DIRECTORY}
	mv start-dockerd-with-systemd.begin	${WORK_DIRECTORY}
	mv start-dockerd-with-systemd.end	${WORK_DIRECTORY}
	mv uninstall-dockerd-scripts.sh		${WORK_DIRECTORY}
	chown root.root				${WORK_DIRECTORY}*
	chmod go-xw				${WORK_DIRECTORY}*
else
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[WARN]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Skipping installation because ${WORK_DIRECTORY}setup-dockerd.sh is already installed.  Updating Docker daemon with changes in ${WORK_DIRECTORY}dockerd-configuration-file." 1>&2
fi
 
###	Configure dockerd (Upstart and SysVinit configuration file) on Ubuntu 14.04
#		Any changes to dockerd-configuration-file will be added to ${UPSTART_SYSVINIT_DIRECTORY}docker
echo -e "\tUpdate files for dockerd (Upstart and SysVinit configuration file)\nfor Ubuntu 14.04."	1>&2
#	Check for dockerd configuration file
if [ -f ${UPSTART_SYSVINIT_DIRECTORY}docker ] ; then
	#	copy ${UPSTART_SYSVINIT_DIRECTORY}docker to ${WORK_DIRECTORY}docker.org
	cp ${UPSTART_SYSVINIT_DIRECTORY}docker ${WORK_DIRECTORY}docker.org
	if grep -qF ${CONFIGURATION_STRING} ${WORK_DIRECTORY}docker.org ; then 
		if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Remove previous dockerd configuration." 1>&2 ; fi
		#	Locate line number of ${CONFIGURATION_STRING} in ${WORK_DIRECTORY}docker
		LINE=`grep -n ${CONFIGURATION_STRING} ${WORK_DIRECTORY}docker.org | cut -f1 -d:`
		LINE=`echo ${LINE} | awk '{print $1 - 1}'`
		#	Write line one to ${LINE} number into ${WORK_DIRECTORY}docker
		head -n +${LINE} ${WORK_DIRECTORY}docker.org > ${WORK_DIRECTORY}docker
	else
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[WARN]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Copy ${WORK_DIRECTORY}docker.org to ${WORK_DIRECTORY}docker without ${CONFIGURATION_STRING} section." 1>&2
		cp ${WORK_DIRECTORY}docker.org ${WORK_DIRECTORY}docker
	fi

#	Append ${WORK_DIRECTORY}dockerd-configuration-file onto ${WORK_DIRECTORY}docker
	if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Append ${WORK_DIRECTORY}dockerd-configuration-file onto ${WORK_DIRECTORY}docker." 1>&2 ; fi
	cat ${WORK_DIRECTORY}dockerd-configuration-file >> ${WORK_DIRECTORY}docker
	if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Move ${WORK_DIRECTORY}docker to ${UPSTART_SYSVINIT_DIRECTORY}docker" 1>&2 ; fi
	mv ${WORK_DIRECTORY}docker ${UPSTART_SYSVINIT_DIRECTORY}docker
fi
echo -e "\tdockerd (Upstart and SysVinit configuration file)\n\tfor Ubuntu 14.04 has been updated." 1>&2
echo -e "If you are using upstart, Run '${BOLD}sudo service docker restart${NORMAL}'\nfor dockerd to read ${UPSTART_SYSVINIT_DIRECTORY}docker.\n"	1>&2

###	Configure dockerd (systemd) on Ubuntu 16.04
#		Any changes to dockerd-configuration-file will be added to ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
START_SYSTEMD_SCRIPT="start-dockerd-with-systemd.sh"
echo -e "\tUpdate files for dockerd (systemd configuration file)\non Ubuntu 16.04."	1>&2
cat ${WORK_DIRECTORY}start-dockerd-with-systemd.begin > ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
cat ${WORK_DIRECTORY}dockerd-configuration-file >> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
cat ${WORK_DIRECTORY}start-dockerd-with-systemd.end >> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
chmod 700 ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}

#	Add /etc/systemd/system/dockerd-configuration-file.service to systemd
cp ${WORK_DIRECTORY}/dockerd-configuration-file.service /etc/systemd/system/
systemctl daemon-reload
echo -e "\tIf you are using systemd, Run\n\t'${BOLD}sudo systemctl enable dockerd-configuration-file.service${NORMAL}'\n\tto start on boot."	1>&2
echo -e "Run '${BOLD}sudo systemctl enable docker${NORMAL}'\n\tto start on boot."	1>&2
echo    "Run '${BOLD}sudo systemctl restart docker${NORMAL}'"	1>&2

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Done." 1>&2
###
