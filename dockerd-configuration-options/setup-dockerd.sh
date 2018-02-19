#!/bin/bash
# 	setup-dockerd.sh	3.7.290	2018-02-18_23:07:16_CST uadmin six-rpi3b.cptx86.com 3.6-23-gccdac10 
# 	   New release, ready for production 
#
#	set -v
#	set -x
#
display_help() {
echo -e "\n${0} - setup system to support dockerd on Systemd and Upstart."
echo -e "\nUSAGE\n   sudo ${0} "
echo    "   sudo ${0} [--help | -help | help | -h | h | -? | ?] [--version | -v]"
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
echo    "   WORK_DIRECTORY             . working directory,"
echo    "                                default is /etc/docker/"
echo    "   UPSTART_SYSVINIT_DIRECTORY   Ubuntu 14.04 (Upstart) directory,"
echo    "                                default is /etc/default/"
echo    "   CONFIGURATION_STRING         >> NEED TO COMPLETE <<<,"
echo    "                                default is Custom_dockerd_Configuration_File"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-scripts/tree/master/dockerd-configuration-options"
echo -e "\nEXAMPLES\n   >>> NEED TO COMPLETE Example description goes here <<< "
echo -e "\tsudo ${0}\n"
}
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] || [ "$1" == "?" ] ; then
	display_help
	exit 0
fi
if [ "$1" == "--version" ] || [ "$1" == "-v" ] ; then
        head -2 ${0} | awk {'print$2"\t"$3'}
        exit 0
fi
###
WORK_DIRECTORY=${1:-/etc/docker/}
UPSTART_SYSVINIT_DIRECTORY=${2:-/etc/default/}
CONFIGURATION_STRING=${3:-Custom_dockerd_Configuration_File}
#
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
#
echo -e "\n${0} ${LINENO} [INFO]:	Changes made to\n\t${WORK_DIRECTORY}dockerd-configuration-file will be added to Upstart and\n\tSystemd configuration files for dockerd.\n"	1>&2
#	Must be root to run this script
if ! [ $(id -u) = 0 ] ; then
	echo "${0} ${LINENO} [ERROR]:	Use sudo ${0}"	1>&2
	exit 1
fi
#	Check for ${WORK_DIRECTORY}
if [ ! -d ${WORK_DIRECTORY} ] ; then
	echo "${0} ${LINENO} [ERROR]:	Is Docker installed?  Directory ${WORK_DIRECTORY} not found."	1>&2
	exit 1
elif [ ! -f ${WORK_DIRECTORY}setup-dockerd.sh ] ; then
#	Move files into /etc/docker ${WORK_DIRECTORY} if not already moved
	echo "${0} ${LINENO} [INFO]:	Move files to ${WORK_DIRECTORY}."	1>&2
	mv 10-override.begin			${WORK_DIRECTORY}
	mv dockerd-configuration-file		${WORK_DIRECTORY}
	mv dockerd-configuration-file.service	${WORK_DIRECTORY}
	mv README.md				${WORK_DIRECTORY}
	mv setup-dockerd.sh			${WORK_DIRECTORY}
	mv start-dockerd-with-systemd.begin	${WORK_DIRECTORY}
	mv start-dockerd-with-systemd.end	${WORK_DIRECTORY}
	chown root.root				${WORK_DIRECTORY}*
	chmod go-xw				${WORK_DIRECTORY}*
fi
#
###	Configure dockerd (Upstart and SysVinit configuration file) on Ubuntu 14.04
#		Any changes to dockerd-configuration-file will be added to ${UPSTART_SYSVINIT_DIRECTORY}docker
#
echo -e "${0} ${LINENO} [INFO]:	Update files for dockerd (Upstart and SysVinit\n\tconfiguration file) for Ubuntu 14.04."	1>&2
#	Check for dockerd configuration file
if [ -f ${UPSTART_SYSVINIT_DIRECTORY}docker ] ; then
#	copy ${UPSTART_SYSVINIT_DIRECTORY}docker to ${WORK_DIRECTORY}docker.org
	cp ${UPSTART_SYSVINIT_DIRECTORY}docker ${WORK_DIRECTORY}docker.org
	if grep -qF ${CONFIGURATION_STRING} ${WORK_DIRECTORY}docker.org ; then 
		echo "${0} ${LINENO} [INFO]:	Remove previous dockerd configuration."	1>&2
#		Locate line number of ${CONFIGURATION_STRING} in ${WORK_DIRECTORY}docker
		LINE=`grep -n ${CONFIGURATION_STRING} ${WORK_DIRECTORY}docker.org | cut -f1 -d:`
		LINE=`echo ${LINE} | awk '{print $1 - 1}'`
#		Write line one to ${LINE} number into ${WORK_DIRECTORY}docker
		head -n +${LINE} ${WORK_DIRECTORY}docker.org > ${WORK_DIRECTORY}docker
	else
		echo -e "${0} ${LINENO} [INFO]:	Copy ${WORK_DIRECTORY}docker.org to\n\t${WORK_DIRECTORY}docker without ${CONFIGURATION_STRING} section."	1>&2
		cp ${WORK_DIRECTORY}docker.org ${WORK_DIRECTORY}docker
	fi
	echo -e "${0} ${LINENO} [INFO]:	Append ${WORK_DIRECTORY}dockerd-configuration-file\n\tonto ${WORK_DIRECTORY}docker."	1>&2
#	Append ${WORK_DIRECTORY}dockerd-configuration-file onto ${WORK_DIRECTORY}docker
	cat ${WORK_DIRECTORY}dockerd-configuration-file >> ${WORK_DIRECTORY}docker
	echo "${0} ${LINENO} [INFO]:	Move ${WORK_DIRECTORY}docker to ${UPSTART_SYSVINIT_DIRECTORY}docker"	1>&2
	mv ${WORK_DIRECTORY}docker ${UPSTART_SYSVINIT_DIRECTORY}docker
fi
echo -e "${0} ${LINENO} [INFO]:	dockerd (Upstart and SysVinit configuration\n\tfile) for Ubuntu 14.04 has been updated."	1>&2
echo -e "\n${0} ${LINENO} [INFO]:	If you are using upstart, Run\n\t'${BOLD}sudo service docker restart${NORMAL}' for dockerd to read ${UPSTART_SYSVINIT_DIRECTORY}docker.\n"	1>&2
#
###	Configure dockerd (systemd) on Ubuntu 16.04
#		Any changes to dockerd-configuration-file will be added to ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
#
START_SYSTEMD_SCRIPT="start-dockerd-with-systemd.sh"
#
echo -e "${0} ${LINENO} [INFO]:	Update files for dockerd (systemd configuration\n\tfile) on Ubuntu 16.04."	1>&2
cat ${WORK_DIRECTORY}start-dockerd-with-systemd.begin > ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
cat ${WORK_DIRECTORY}dockerd-configuration-file >> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
cat ${WORK_DIRECTORY}start-dockerd-with-systemd.end >> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
chmod 700 ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
#	Add /etc/systemd/system/dockerd-configuration-file.service to systemd
cp ${WORK_DIRECTORY}/dockerd-configuration-file.service /etc/systemd/system/
systemctl daemon-reload
#
echo -e "\n${0} ${LINENO} [INFO]:	If you are using systemd, Run\n\t'${BOLD}sudo systemctl enable dockerd-configuration-file.service${NORMAL}'\n\tto start on boot."	1>&2
echo -e "${0} ${LINENO} [INFO]:	Run '${BOLD}sudo systemctl enable docker${NORMAL}'\n\tto start on boot."	1>&2
echo    "${0} ${LINENO} [INFO]:	Run '${BOLD}sudo systemctl restart docker${NORMAL}'"	1>&2
###
