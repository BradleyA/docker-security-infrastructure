#!/bin/bash
#	setup-dockerd.sh	1.46	2018-01-15_19:26:41_CST uadmin rpi3b-four.cptx86.com
#	completed first edits for Configure dockerd (systemd) on Ubuntu 16.04 section
#	setup-dockerd.sh	1.45	2018-01-14_21:23:20_CST uadmin rpi3b-four.cptx86.com
#	subtract 1 from ${LINE}
#	setup-dockerd.sh	1.44	2018-01-14_19:56:17_CST uadmin rpi3b-four.cptx86.com
#	rework move files section to check if files already moved
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
#	set -x
#
WORK_DIRECTORY="/etc/docker/"
UPSTART_SYSVINIT_DIRECTORY="/etc/default/"
CONFIGURATION_STRING="Custom_dockerd_Configuration_File"
#
echo -e "\n${0} ${LINENO} [INFO]:	Changes made to ${WORK_DIRECTORY}dockerd-configuration-file will be add to Upstart and Systemd configuration files for dockerd.\n"	1>&2
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
echo "${0} ${LINENO} [INFO]:	Update files for dockerd (Upstart and SysVinit configuration file) for Ubuntu 14.04."	1>&2
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
		echo "${0} ${LINENO} [INFO]:	Copy ${WORK_DIRECTORY}docker.org to ${WORK_DIRECTORY}docker without ${CONFIGURATION_STRING} section."	1>&2
		cp ${WORK_DIRECTORY}docker.org ${WORK_DIRECTORY}docker
	fi
	echo "${0} ${LINENO} [INFO]:	Append ${WORK_DIRECTORY}dockerd-configuration-file onto ${WORK_DIRECTORY}docker."	1>&2
#	Append ${WORK_DIRECTORY}dockerd-configuration-file onto ${WORK_DIRECTORY}docker
	cat ${WORK_DIRECTORY}dockerd-configuration-file >> ${WORK_DIRECTORY}docker
	echo "${0} ${LINENO} [INFO]:	Move ${WORK_DIRECTORY}docker to ${UPSTART_SYSVINIT_DIRECTORY}docker"	1>&2
	mv ${WORK_DIRECTORY}docker ${UPSTART_SYSVINIT_DIRECTORY}docker
fi
echo "${0} ${LINENO} [INFO]:	dockerd (Upstart and SysVinit configuration file) for Ubuntu 14.04 has been updated."	1>&2
echo -e "\n${0} ${LINENO} [INFO]:	Run 'sudo service docker restart' for dockerd to read ${UPSTART_SYSVINIT_DIRECTORY}docker or reboot.\n"	1>&2
#
###	Configure dockerd (systemd) on Ubuntu 16.04
#		Any changes to dockerd-configuration-file will be added to ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
#
START_SYSTEMD_SCRIPT="start-dockerd-with-systemd.sh"
#
echo    "${0} ${LINENO} [INFO]:	Update files for dockerd (systemd) on Ubuntu 16.04."	1>&2
cat ${WORK_DIRECTORY}start-dockerd-with-systemd.begin > ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
cat ${WORK_DIRECTORY}dockerd-configuration-file >> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
cat ${WORK_DIRECTORY}start-dockerd-with-systemd.end >> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
chmod 700 ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
#	Add /etc/systemd/system/dockerd-configuration-file.service to systemd
cp ${WORK_DIRECTORY}/dockerd-configuration-file.service /etc/systemd/system/
systemctl daemon-reload
#
echo -e "\n${0} ${LINENO} [INFO]:	Run 'sudo systemctl enable dockerd-configuration-file' to start on boot."	1>&2
echo    "${0} ${LINENO} [INFO]:	Run 'sudo systemctl daemon-reload' to start on boot."	1>&2
#	echo    "${0} ${LINENO} [INFO]:	Run 'sudo systemctl start dockerd-configuration-file' to start."	1>&2
echo    "${0} ${LINENO} [INFO]:	Run 'sudo systemctl start docker'"	1>&2
echo    "${0} ${LINENO} [INFO]:	Run 'sudo systemctl enable docker' to dockerd to start on boot."	1>&2
