#!/bin/bash
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
echo '#!/bin/bash'	>  ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
echo '#'		>> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
echo '#       set -v'	>> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
echo '        set -x'	>> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
#
#	Any changes to dockerd-configuration-file will be added to the override file during 
#		the next boot or when ${START_SYSTEMD_SCRIPT} is run.
#
#	Append ${WORK_DIRECTORY}dockerd-configuration-file onto ${WORK_DIRECTORY}docker
	cat ${WORK_DIRECTORY}dockerd-configuration-file >> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
#
echo 'DROP_IN_DIRECTORY="/etc/systemd/system/docker.service.d"'		>> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
echo 'OVERRIDE_FILE="10-override"'		>> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
echo 'WORK_DIRECTORY="/etc/docker/"'		>> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
echo '#	Copy $WORK_DIRECTORY/$OVERRIDE_FILE to $WORK_DIRECTORY/$OVERRIDE_FILE.conf'		>> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
echo '/bin/cp --force $WORK_DIRECTORY/$OVERRIDE_FILE $WORK_DIRECTORY/$OVERRIDE_FILE.conf'		>> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
echo '#	Append the following line with $DOCKER_OPTS onto ${WORK_DIRECTORY}10-override.conf'		>> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
echo '/bin/echo "ExecStart=/usr/bin/dockerd $DOCKER_OPTS" >> $WORK_DIRECTORY/$OVERRIDE_FILE.conf'		>> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
echo '#       Create docker.service drop-in directory for override file ($OVERRIDE_FILE.conf)'		>> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
echo '/bin/mkdir -p ${DROP_IN_DIRECTORY}'		>> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
echo '#	Move override file into docker.service.d directory'		>> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
echo '/bin/mv --force $WORK_DIRECTORY/$OVERRIDE_FILE.conf $DROP_IN_DIRECTORY'		>> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
echo '#	Unable to get docker.service to reload during boot for 10-override.conf file changes if any to be included in dockerd.'		>> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
echo '#	/bin/systemctl reload docker.service'		>> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
echo '#	This is the warning I receive when uncommenting the previous line.'		>> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
echo '#		Warning: docker.service changed on disk. Run 'systemctl daemon-reload' to reload units.'		>> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
echo '#	/bin/systemctl daemon-reload'		>> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}
echo '#	No change when using this line,  I think systemd is not up yet so systemctl daemon-reload can not be used.'		>> ${WORK_DIRECTORY}${START_SYSTEMD_SCRIPT}

/bin/echo "ExecStart=/usr/bin/dockerd $DOCKER_OPTS" >> $WORK_DIRECTORY/$OVERRIDE_FILE.conf
/bin/echo "4"  &>> /tmp/start.docker
#       Create systemd drop-in directory for docker.service drop-in $OVERRIDE_FILE
/bin/mkdir -p ${DROP_IN_DIRECTORY}  &>> /tmp/start.docker
/bin/echo "5"  &>> /tmp/start.docker
#       Move $WORK_DIRECTORY/$OVERRIDE_FILE to $DROP_IN_DIRECTORY
/bin/mv --force $WORK_DIRECTORY/$OVERRIDE_FILE.conf $DROP_IN_DIRECTORY  &>> /tmp/start.docker
/bin/echo "6"  &>> /tmp/start.docker
#       Merge override file into docker.service
#       /bin/systemctl reload docker.service  &>> /tmp/start.docker
#       Warning: docker.service changed on disk. Run 'systemctl daemon-reload' to reload units.
/bin/echo "7"  &>> /tmp/start.docker
#       
/bin/systemctl daemon-reload &>> /tmp/start.docker
/bin/echo "8"  &>> /tmp/start.docker

