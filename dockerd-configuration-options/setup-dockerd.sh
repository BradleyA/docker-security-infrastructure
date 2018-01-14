#!/bin/bash
#	setup-dockerd.sh	1.43	2018-01-14_16:10:18_CST uadmin rpi3b-four.cptx86.com
#	change quotes around string on if [ grep ] line
#	setup-dockerd.sh	1.42	2018-01-14_14:05:44_CST uadmin rpi3b-four.cptx86.com
#	correct errors during debug run
#	setup-dockerd.sh	1.41	2018-01-14_09:37:25_CST uadmin rpi3b-four.cptx86.com
#	correct systax of if ; then ; else
#	setup-dockerd.sh	1.4	2018-01-14_09:26:57_CST uadmin rpi3b-four.cptx86.com
#	update format of echo statements
#	setup-dockerd.sh	1.3	2018-01-14_09:04:21_CST uadmin rpi3b-four.cptx86.com
#	added code to check if script is being run as root and move files into /etc/docker
#	setup-dockerd.sh	1.1	2018-01-13_20:14:44_CST uadmin rpi3b-four.cptx86.com
#	complete Initial work and ready for testing
#	setup-dockerd.sh	1.0	2018-01-13_11:26:31_CST uadmin rpi3b-four.cptx86.com
#	Initial commit
#
#	set -v
	set -x
#
#
WORK_DIRECTORY="/etc/docker/"
UPSTART_SYSVINIT_DIRECTORY="/etc/default/"
CONFIGURATION_STRING="cptx86"
#
echo -e "\n${0} [INFO]:	Changes made to ${WORK_DIRECTORY}dockerd-configuration-file will be copied to the correct locations.\n"	1>&2
#	Must be root to run this script
if ! [ $(id -u) = 0 ] ; then
   echo "${0} [ERROR]:	Use sudo ./${0} to run this script"	1>&2
   exit 1
fi
#	Check for ${WORK_DIRECTORY}
if [ -d ${WORK_DIRECTORY} ] ; then
#	Move files into /etc/docker ${WORK_DIRECTORY}
	mv 10-override.begin			${WORK_DIRECTORY}
	mv dockerd-configuration-file		${WORK_DIRECTORY}
	mv dockerd-configuration-file.service	${WORK_DIRECTORY}
	mv README.md				${WORK_DIRECTORY}
	mv setup-dockerd.sh			${WORK_DIRECTORY}
	mv start-dockerd-with-systemd.begin	${WORK_DIRECTORY}
	mv start-dockerd-with-systemd.end	${WORK_DIRECTORY}
else
	echo "${0} [ERROR]:	Is Docker installed?  Directory ${WORK_DIRECTORY} not found."	1>&2
	exit 1
fi
#
###	Configure dockerd (Upstart and SysVinit configuration file) on Ubuntu 14.04
#
echo "${0} [INFO]:	Update files for dockerd (Upstart and SysVinit configuration file) on Ubuntu 14.04."	1>&2
#	Check for dockerd configuration file
if [ -f ${UPSTART_SYSVINIT_DIRECTORY}docker ] ; then
	echo "${0} [INFO]:	Found ${UPSTART_SYSVINIT_DIRECTORY}docker"	1>&2
#	copy ${UPSTART_SYSVINIT_DIRECTORY}docker to ${WORK_DIRECTORY}docker.org
	cp ${UPSTART_SYSVINIT_DIRECTORY}docker ${WORK_DIRECTORY}docker.org
	if [ grep -qF ${CONFIGURATION_STRING} ${WORK_DIRECTORY}docker.org ] ; then 
		echo "${0} [INFO]:	Found ${CONFIGURATION_STRING} in ${WORK_DIRECTORY}docker.org"	1>&2
#		Locate line number of ${CONFIGURATION_STRING} in ${WORK_DIRECTORY}docker
		LINE=grep -n ${CONFIGURATION_STRING} ${WORK_DIRECTORY}docker.org | cut -f1 -d:
#		Move line one to $LINE number into ${WORK_DIRECTORY}docker
		tail -n +${LINE} ${WORK_DIRECTORY}docker.org > ${WORK_DIRECTORY}docker
	else
		echo "${0} [INFO]:	copy ${WORK_DIRECTORY}docker.org to ${WORK_DIRECTORY}docker without ${CONFIGURATION_STRING}"	1>&2
		cp ${WORK_DIRECTORY}docker.org ${WORK_DIRECTORY}docker
	fi
#	Remove working copy ${WORK_DIRECTORY}docker.org
### >>>		Uncomment after debuging <<<   ###
#	rm ${WORK_DIRECTORY}docker.org
#	Append ${WORK_DIRECTORY}dockerd-configuration-file onto ${WORK_DIRECTORY}docker
	cat ${WORK_DIRECTORY}dockerd-configuration-file >> ${WORK_DIRECTORY}docker
	echo "${0} [INFO]:	Move ${WORK_DIRECTORY}docker to ${UPSTART_SYSVINIT_DIRECTORY}docker"	1>&2
	mv ${WORK_DIRECTORY}docker ${UPSTART_SYSVINIT_DIRECTORY}docker
	echo -e "\n\n${0} [INFO]:     dockerd (Upstart and SysVinit configuration file) on Ubuntu 14.04 is configured.\n"	1>&2
fi
#
###	Configure dockerd (systemd) on Ubuntu 16.04
#
#	Any changes to dockerd-configuration-file will be added to ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
echo "${0} [INFO]:	Update files for dockerd (systemd) on Ubuntu 16.04."	1>&2
#
START_SYSTEMD_SCRIPT="start-dockerd-with-systemd.sh"
#
cat ${WORK_DIRECTORY}start-dockerd-with-systemd.begin > ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
#	Append ${WORK_DIRECTORY}dockerd-configuration-file onto ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
cat ${WORK_DIRECTORY}dockerd-configuration-file >> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
#
cat ${WORK_DIRECTORY}start-dockerd-with-systemd.end >> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
chmod 700 ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
#
echo -e "\n\n${0} [INFO]:	Run sudo ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT} to complete dockerd systemd setup.\n"	1>&2
