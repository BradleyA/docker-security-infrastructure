#!/bin/bash
# 	uninstall-dockerd-scripts.sh  3.23.336  2018-05-08_07:39:15_CDT  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.22  
# 	   finished upstart section 
# 	uninstall-dockerd-scripts.sh  3.22.335  2018-05-07_22:26:50_CDT  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.21  
# 	   add exit line while working on script 
# 	uninstall-dockerd-scripts.sh  3.21.334  2018-05-07_11:08:06_CDT  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.20-6-g270eb14  
# 	   Initial submit 
#
#	set -v
#	set -x
#
display_help() {
echo -e "\n${0} - uninstall scripts that support dockerd on Systemd and Upstart."
echo -e "\nUSAGE\n   sudo ${0} "
echo    "   sudo ${0} [--help | -help | help | -h | h | -? | ?] [--version | -v]"
echo -e "\nDESCRIPTION\nThis script has to be run as root to remove files from /etc/docker and create"
echo    "XXXXX xxxxx or update the /etc/systemd/system/docker.service.d/10-override.conf"
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
echo -e "\nEXAMPLES\n   After editing /etc/docker/dockerd-configuration-file, run"
echo -e "\tsudo ${0}\n"
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
echo "THis is not complete.  Need a few days" ; exit 1
#	Check for ${WORK_DIRECTORY}
if [ ! -d ${WORK_DIRECTORY} ] ; then
	echo "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:	Is Docker installed?  Directory ${WORK_DIRECTORY} not found."	1>&2
	exit 1

 # >>> #	may want to continue even if /etc/docker is missing because the files are in other directories!

elif [ ! -f ${WORK_DIRECTORY}setup-dockerd.sh ] ; then
#	Removing files from ${WORK_DIRECTORY} if not already removed
	echo "${NORMAL}${0} ${LINENO} [${BOLD}INFO${NORMAL}]:	Removing files from ${WORK_DIRECTORY}."	1>&2
	rm -f ${WORK_DIRECTORY}10-override.begin
	rm -f ${WORK_DIRECTORY}dockerd-configuration-file
	rm -f ${WORK_DIRECTORY}dockerd-configuration-file.service
	rm -f ${WORK_DIRECTORY}README.md
	rm -f ${WORK_DIRECTORY}setup-dockerd.sh
	rm -f ${WORK_DIRECTORY}start-dockerd-with-systemd.begin
	rm -f ${WORK_DIRECTORY}start-dockerd-with-systemd.end
	rm -f ${WORK_DIRECTORY}start-dockerd-with-systemd.sh
fi
#	Check for dockerd configuration file
if [ -f ${UPSTART_SYSVINIT_DIRECTORY}docker ] ; then
#	copy ${WORK_DIRECTORY}docker.org to ${UPSTART_SYSVINIT_DIRECTORY}docker
        cp   ${WORK_DIRECTORY}docker.org    ${UPSTART_SYSVINIT_DIRECTORY}docker
fi
rm -f ${WORK_DIRECTORY}docker.org
echo -e "${NORMAL}\n${0} ${LINENO} [${BOLD}INFO${NORMAL}]:	If you are using upstart, Run\n\t'${BOLD}sudo service docker restart${NORMAL}' for dockerd to read ${UPSTART_SYSVINIT_DIRECTORY}docker.\n"	1>&2
#
###	Configure dockerd (systemd) on Ubuntu 16.04
#		Any changes to dockerd-configuration-file will be added to ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
#
START_SYSTEMD_SCRIPT="start-dockerd-with-systemd.sh"
#
echo -e "${NORMAL}${0} ${LINENO} [${BOLD}INFO${NORMAL}]:	Update files for dockerd (systemd configuration\n\tfile) on Ubuntu 16.04."	1>&2
cat ${WORK_DIRECTORY}start-dockerd-with-systemd.begin > ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
cat ${WORK_DIRECTORY}dockerd-configuration-file >> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
cat ${WORK_DIRECTORY}start-dockerd-with-systemd.end >> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
chmod 700 ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
#	Add /etc/systemd/system/dockerd-configuration-file.service to systemd
cp ${WORK_DIRECTORY}/dockerd-configuration-file.service /etc/systemd/system/
systemctl daemon-reload
#
echo -e "${NORMAL}\n${0} ${LINENO} [${BOLD}INFO${NORMAL}]:	If you are using systemd, Run\n\t'${BOLD}sudo systemctl enable dockerd-configuration-file.service${NORMAL}'\n\tto start on boot."	1>&2
echo -e "${NORMAL}${0} ${LINENO} [${BOLD}INFO${NORMAL}]:	Run '${BOLD}sudo systemctl enable docker${NORMAL}'\n\tto start on boot."	1>&2
echo    "${NORMAL}${0} ${LINENO} [${BOLD}INFO${NORMAL}]:	Run '${BOLD}sudo systemctl restart docker${NORMAL}'"	1>&2
###
