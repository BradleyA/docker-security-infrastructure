#!/bin/bash
# 	uninstall-dockerd-scripts.sh  3.28.341  2018-05-08_16:23:59_CDT  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.27  
# 	   add instruction to remove this script when complete 
# 	uninstall-dockerd-scripts.sh  3.27.340  2018-05-08_10:54:15_CDT  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.26  
# 	   testing complete, additional testing maybe needed, ready for use 
# 	uninstall-dockerd-scripts.sh  3.25.338  2018-05-08_10:34:15_CDT  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.24  
# 	   cleanup command help messages 
#
#	set -v
#	set -x
#
display_help() {
echo -e "\n${0} - uninstall scripts that support dockerd on Systemd and Upstart"
echo -e "\nUSAGE\n   sudo ${0} "
echo    "   sudo ${0} [OPTIONS]"
echo    "   sudo ${0} [--help | -help | help | -h | h | -? | ?] [--version | -v]"
echo -e "\nDESCRIPTION\nThis script has to be run as root to remove scripts and files from /etc/docker"
echo    "and /etc/systemd/system."
echo -e "\nOPTIONS"
echo    "   WORK_DIRECTORY               working directory,"
echo    "                                default is /etc/docker/"
echo    "   UPSTART_SYSVINIT_DIRECTORY   Ubuntu 14.04 (Upstart) directory,"
echo    "                                default is /etc/default/"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-scripts/tree/master/dockerd-configuration-options"
echo -e "\nEXAMPLES\n   To remove scripts and files using defulat directories, run"
echo -e "\tsudo ${0}\n"
echo -e "   To use non-default directories for WORK_DIRECTORY (/mnt/etc/docker/) and"
echo    "   UPSTART_SYSVINIT_DIRECTORY (/mnt/etc/default/), run"
echo -e "\tsudo ${0} /mnt/etc/docker/ /mnt/etc/default/\n"
}
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] || [ "$1" == "?" ] ; then
	display_help
	exit 0
fi
if [ "$1" == "--version" ] || [ "$1" == "-v" ] || [ "$1" == "version" ] ; then
        head -2 ${0} | awk {'print$2"\t"$3'}
        exit 0
fi
###
WORK_DIRECTORY=${1:-/etc/docker/}
UPSTART_SYSVINIT_DIRECTORY=${2:-/etc/default/}
CONFIGURATION_STRING=${3:-Custom_dockerd_Configuration_File}
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
#
echo -e "\n${NORMAL}${0} ${LINENO} [${BOLD}INFO${NORMAL}]:	Begin uninstalling scripts and supporting files.\n"	1>&2
#	Must be root to run this script
if ! [ $(id -u) = 0 ] ; then
	echo "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:	Use sudo ${0}"	1>&2
	exit 1
fi
#
###	Remove dockerd (Upstart and SysVinit configuration file) on Ubuntu 14.04
#
#	Check for ${WORK_DIRECTORY}
if [ ! -d ${WORK_DIRECTORY} ] ; then
	echo "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:	Is Docker installed?  Directory ${WORK_DIRECTORY} not found."	1>&2
else
#	Removing files from ${WORK_DIRECTORY}
	echo "${NORMAL}${0} ${LINENO} [${BOLD}INFO${NORMAL}]:	Removing files from ${WORK_DIRECTORY}."	1>&2
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
		echo -e "${NORMAL}\n${0} ${LINENO} [${BOLD}INFO${NORMAL}]:      ${UPSTART_SYSVINIT_DIRECTORY}docker not found."
	fi
	rm -f ${WORK_DIRECTORY}docker.org
fi
echo -e "${NORMAL}\n${0} ${LINENO} [${BOLD}INFO${NORMAL}]:	If you are using upstart, Run\n\t'${BOLD}sudo service docker restart${NORMAL}' for dockerd to read ${UPSTART_SYSVINIT_DIRECTORY}docker.\n"	1>&2
#
###	Remove dockerd (systemd) on Ubuntu 16.04
#
#	Remove /etc/systemd/system/dockerd-configuration-file.service 
rm -f /etc/systemd/system/dockerd-configuration-file.service
#	Remove directories docker.service.d and docker.service.wants
rm -rf /etc/systemd/system/docker.service.d
rm -rf /etc/systemd/system/docker.service.wants
#
systemctl daemon-reload
#
echo    "${NORMAL}${0} ${LINENO} [${BOLD}INFO${NORMAL}]:	Run '${BOLD}sudo systemctl restart docker${NORMAL}'"	1>&2
echo    "${NORMAL}${0} ${LINENO} [${BOLD}INFO${NORMAL}]:        Run '${BOLD}rm ${0}${NORMAL}'"  1>&2
###
