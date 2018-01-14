#!/bin/bash
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
CONFIGURATION_STRING="Custom Dockerd Configuration File"
#
###	Configure dockerd (Upstart and SysVinit configuration file) on Ubuntu 14.04
#
#	As systemd complete all work in $WORK_DIRECTORY before moving the completed file in to /etc/defailt
#	Check for dockerd configuration file
if [ -f ${UPSTART_SYSVINIT_DIRECTORY}docker ] then
	echo "found ${UPSTART_SYSVINIT_DIRECTORY}docker"
#	copy ${UPSTART_SYSVINIT_DIRECTORY}docker to ${WORK_DIRECTORY}docker.org
	cp ${UPSTART_SYSVINIT_DIRECTORY}docker ${WORK_DIRECTORY}docker.org
	if [ grep -qF ${CONFIGURATION_STRING} ${WORK_DIRECTORY}docker.org ] then 
		echo "found ${CONFIGURATION_STRING} in ${WORK_DIRECTORY}docker.org"
#		Locate line number of ${CONFIGURATION_STRING} in ${WORK_DIRECTORY}docker
		LINE=`grep -n ${CONFIGURATION_STRING} ${WORK_DIRECTORY}docker.org | cut -f1 -d:`
#		Move line one to $LINE number into ${WORK_DIRECTORY}docker
		tail -n +$LINE ${WORK_DIRECTORY}docker.org > ${WORK_DIRECTORY}docker
	else
		echo "copy ${WORK_DIRECTORY}docker.org to ${WORK_DIRECTORY}docker without ${CONFIGURATION_STRING}"
		cp ${WORK_DIRECTORY}docker.org ${WORK_DIRECTORY}docker
	fi
#	Remove working copy ${WORK_DIRECTORY}docker.org
### >>>		Uncomment after debuging <<<   ###
#	rm ${WORK_DIRECTORY}docker.org
#	Append ${WORK_DIRECTORY}dockerd-configuration-file onto ${WORK_DIRECTORY}docker
	cat ${WORK_DIRECTORY}dockerd-configuration-file >> ${WORK_DIRECTORY}docker
	echo "Move ${WORK_DIRECTORY}docker to ${UPSTART_SYSVINIT_DIRECTORY}docker"
	mv ${WORK_DIRECTORY}docker ${UPSTART_SYSVINIT_DIRECTORY}docker
fi
#
###	Configure dockerd (systemd) on Ubuntu 16.04
#
START_SYSTEMD_SCRIPT="start-dockerd-with-systemd.sh"
#
cat start-dockerd-with-systemd.begin > ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
#
#	Any changes to dockerd-configuration-file will be added to the override file during 
#		the next boot or when ${START_SYSTEMD_SCRIPT} is run.
#
#	Append ${WORK_DIRECTORY}dockerd-configuration-file onto ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
cat ${WORK_DIRECTORY}dockerd-configuration-file >> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
#
cat start-dockerd-with-systemd.end >> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
