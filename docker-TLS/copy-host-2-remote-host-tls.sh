#!/bin/bash
# 	copy-host-2-remote-host-tls.sh  3.49.405  2018-08-20_13:33:56_CDT  https://github.com/BradleyA/docker-scripts  uadmin  three-rpi3b.cptx86.com 3.48  
# 	   cleanup and testing for #15 
# 	copy-host-2-remote-host-tls.sh  3.45.399  2018-08-16_17:25:51_CDT  https://github.com/BradleyA/docker-scripts  uadmin  three-rpi3b.cptx86.com 3.44-2-g99631bc  
# 	   completed changes for remove nc -z and SSHPORT #15 
###
DEBUG=0                 # 0 = debug off, 1 = debug on
#	set -x
#	set -v
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
REMOTEHOST=$1
USERHOME=${2:-/home}
USERHOME=${USERHOME}"/"
ADMTLSUSER=${3:-${USER}} # design for futrue use
###
display_help() {
echo -e "\n${NORMAL}${0} - Copy public, private keys and CA to remote host"
echo -e "\nUSAGE\n   ${0} <remote-host> [<home-directory>]"
echo    "   ${0} [--help | -help | help | -h | h | -? | ?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION\nA user with administration authority uses this script to"
echo    "copy host TLS CA, public, and private keys from"
echo    "${USERHOME}${ADMTLSUSER}/.docker/docker-ca directory on this system to"
echo    "/etc/docker/certs.d directory on a remote system."
echo -e "\nThe administration user may receive password and/or passphrase prompts from a"
echo    "remote systen; running the following may stop the prompts in your cluster."
echo    "   ssh-copy-id <admin-user>@x.x.x.x"
echo -e "\nOPTIONS"
echo    "   REMOTEHOST   remote host to copy certificates to"
echo    "   USERHOME     location of administration user directory, default is /home/"
echo    "      Many sites have different home directories (/u/north-office/)"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS"
echo -e "\nEXAMPLES\n   ${0} two.cptx86.com\n\n   Administration user copies TLS keys and CA to remote host, two.cptx86.com,"
echo    "   using default home directory, /home/, default administration user running"
echo -e "   script.\n"
echo -e "   ${0} two.cptx86.com /u/north-office/ uadmin\n\n   Administration user copies TLS keys and CA to remote host, two.cptx86.com,"
echo    "   using local home directory, /u/north-office/, administrator account, uadmin."
if ! [ "${LANG}" == "en_US.UTF-8" ] ; then
        echo -e "${NORMAL}${0} ${LINENO} [${BOLD}WARNING${NORMAL}]:     Your language, ${LANG}, is not supported.\n\tWould you like to help?\n" 1>&2
fi
}
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] || [ "$1" == "?" ] ; then
	display_help
	exit 0
fi
if [ "$1" == "--version" ] || [ "$1" == "-version" ] || [ "$1" == "version" ] || [ "$1" == "-v" ] ; then
        head -2 ${0} | awk {'print$2"\t"$3'}
        exit 0
fi
###		
if [ "${DEBUG}" == "1" ] ; then echo -e "> DEBUG ${LINENO}  REMOTEHOST >${REMOTEHOST}< USERHOME >${USERHOME}< ADMTLSUSER >${ADMTLSUSER}<" 1>&2 ; fi
#	Check if admin user has home directory on system
if [ ! -d ${USERHOME}${ADMTLSUSER} ] ; then
	display_help
	echo -e "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:        ${ADMTLSUSER} does not have a home directory\n\ton this system or ${ADMTLSUSER} home directory is not ${USERHOME}${ADMTLSUSER}"	1>&2
	exit 1
fi
#	Check if ${USERHOME}${ADMTLSUSER}/.docker/docker-ca directory on system
if [ ! -d ${USERHOME}${ADMTLSUSER}/.docker/docker-ca ] ; then
	display_help
	echo -e "\n${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:   default directory,\n"     1>&2
	echo -e "\t${BOLD}${USERHOME}${ADMTLSUSER}/.docker/docker-ca${NORMAL}, not on system.\n"  1>&2
	echo -e "\tSee documentation for more information."
	exit 1
fi
cd ${USERHOME}${ADMTLSUSER}/.docker/docker-ca
#	Prompt for ${REMOTEHOST} if argement not entered
if [ -z ${REMOTEHOST} ] ; then
	echo    "Enter remote host where TLS keys are to be copied:"
	read REMOTEHOST
fi
#	Check if ${REMOTEHOST} string length is zero
if [ -z ${REMOTEHOST} ] ; then
	display_help
	echo -e "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:	Remote host is required.\n"	1>&2
	exit 1
fi
#	Check if ${REMOTEHOST}-priv-key.pem file on system
if ! [ -e ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/${REMOTEHOST}-priv-key.pem ] ; then
	display_help
	echo -e "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:	The ${REMOTEHOST}-priv-key.pem\n\tfile was not found in ${USERHOME}${ADMTLSUSER}/.docker/docker-ca."	1>&2
	echo -e "\tRunning create-host-tls.sh will create public and private keys."
	exit 1
fi
#	Check if ${REMOTEHOST} is available on ssh port
if $(ssh ${REMOTEHOST} 'exit' >/dev/null 2>&1 ) ; then
	echo -e "${NORMAL}${0} ${LINENO} [${BOLD}INFO${NORMAL}]:\n${ADMTLSUSER} may receive password and passphrase prompts from ${REMOTEHOST}.\nRunning ssh-copy-id ${ADMTLSUSER}@${REMOTEHOST} may stop the prompts.\n"
#	Check if /etc/docker directory on ${REMOTEHOST}
	if ! $(ssh -t ${ADMTLSUSER}@${REMOTEHOST} "test -d /etc/docker") ; then
		echo -e "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:	/etc/docker directory missing,"	1>&2
		echo -e "\tis docker installed on ${REMOTEHOST}."	1>&2
		exit 1
	fi
	TIMESTAMP=`date +%Y-%m-%d-%H-%M-%S-%Z`
#	Create working directory ~/.docker/docker-ca/${REMOTEHOST}
	mkdir -p ${REMOTEHOST}
	cd ${REMOTEHOST}
#	Backup ${REMOTEHOST}/etc/docker/certs.d
	echo -e "\n${NORMAL}${0} ${LINENO} [${BOLD}INFO${NORMAL}]:\n\tBackup ${REMOTEHOST}:/etc/docker/certs.d to `pwd`\n"	1>&2
	ssh -t ${ADMTLSUSER}@${REMOTEHOST} "sudo mkdir -p /etc/docker/certs.d/daemon ; cd /etc ; sudo tar -pcf /tmp/${REMOTEHOST}-${TIMESTAMP}.tar ./docker/certs.d/daemon ; sudo chown ${ADMTLSUSER}.${ADMTLSUSER} /tmp/${REMOTEHOST}-${TIMESTAMP}.tar ; chmod 0400 /tmp/${REMOTEHOST}-${TIMESTAMP}.tar"
	scp -p ${ADMTLSUSER}@${REMOTEHOST}:/tmp/${REMOTEHOST}-${TIMESTAMP}.tar .
	ssh -t ${ADMTLSUSER}@${REMOTEHOST} "rm /tmp/${REMOTEHOST}-${TIMESTAMP}.tar"
	tar -pxf ${REMOTEHOST}-${TIMESTAMP}.tar
#	Check if /etc/docker/certs.d/daemon/${REMOTEHOST}-priv-key.pem file exists on remote system
	if [ -e ./docker/certs.d/daemon/${REMOTEHOST}-priv-key.pem ] ; then
		echo -e "${NORMAL}${0} ${LINENO} [${BOLD}WARN${NORMAL}]:\n\t/etc/docker/certs.d/daemon/${REMOTEHOST}-priv-key.pem\n\talready exists, renaming existing keys so new keys can be installed."	1>&2
		mv ./docker/certs.d/daemon/${REMOTEHOST}-priv-key.pem ./docker/certs.d/daemon/${REMOTEHOST}-priv-key.pem-${TIMESTAMP}
		mv ./docker/certs.d/daemon/${REMOTEHOST}-cert.pem ./docker/certs.d/daemon/${REMOTEHOST}-cert.pem-${TIMESTAMP}
		mv ./docker/certs.d/daemon/ca.pem ./docker/certs.d/daemon/ca.pem-${TIMESTAMP}
		rm ./docker/certs.d/daemon/{cert,key}.pem
	fi
#	Create certification tar file and install it to ${REMOTEHOST}
	chmod 0700 ./docker/certs.d/daemon
	cp -p ../${REMOTEHOST}-priv-key.pem ./docker/certs.d/daemon
	cp -p ../${REMOTEHOST}-cert.pem ./docker/certs.d/daemon
	cp -p ../ca.pem ./docker/certs.d/daemon
	cd ./docker/certs.d/daemon
	ln -s ${REMOTEHOST}-priv-key.pem key.pem
	ln -s ${REMOTEHOST}-cert.pem cert.pem
	cd ../../..
	TIMESTAMP=`date +%Y-%m-%d-%H-%M-%S-%Z`
	tar -pcf ./${REMOTEHOST}-${TIMESTAMP}.tar ./docker/certs.d/daemon
	chmod 0600 ./${REMOTEHOST}-${TIMESTAMP}.tar
	scp -p ./${REMOTEHOST}-${TIMESTAMP}.tar ${ADMTLSUSER}@${REMOTEHOST}:/tmp
#	Create remote directory /etc/docker/certs.d/daemon
#	This directory was selected to place dockerd TLS certifications because
#	docker registry stores it's TLS certifications in /etc/docker/certs.d.
	echo -e "\n${NORMAL}${0} ${LINENO} [${BOLD}INFO${NORMAL}]:\n\tCopy dockerd certification to ${REMOTEHOST}\n"
	ssh -t ${ADMTLSUSER}@${REMOTEHOST} "cd /etc ; sudo tar -pxf /tmp/${REMOTEHOST}-${TIMESTAMP}.tar ; sudo chmod 0700 /etc/docker ; sudo chmod 0700 /etc/docker/certs.d ; sudo chown -R root.root ./docker ; rm /tmp/${REMOTEHOST}-${TIMESTAMP}.tar"
	cd ..

##################
# >>>	Remove ${TLSUSER}/.docker and tar file from ${USERHOME}${ADMTLSUSER}/.docker/docker-ca
#	rm -rf ${REMOTEHOST}
##################

#       Display instructions about certification environment variables
	echo -e "\n\nAdd TLS flags to dockerd so it will know to use TLS certifications (--tlsverify,"
	echo    "--tlscacert, --tlscert, --tlskey).  Scripts that will help with setup and"
	echo    "operations of Docker using TLS can be found:"
	echo    "https://github.com/BradleyA/docker-scripts/tree/master/dockerd-configuration-options"
	echo -e "\tThe dockerd-configuration-options scripts will help with"
	echo -e "\tconfiguration of dockerd on systems running Ubuntu 16.04"
	echo -e "\t(systemd) and Ubuntu 14.04 (Upstart).\n"
#
	echo    "If dockerd is already using TLS certifications then:"
	echo -e "\tUbuntu 16.04 (Systemd) ${BOLD}sudo systemctl restart docker${NORMAL}"
	echo -e "\tUbuntu 14.04 (Upstart) ${BOLD}sudo service docker restart${NORMAL}"
	echo -e "\n${0} ${LINENO} [INFO]:	Done."
	exit 0
else
	display_help
	echo -e "\n${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:\n\t${REMOTEHOST} not responding on ssh port.\n"	1>&2
	exit 1
fi
###
#       May want to create a version of this script that automates this process for SRE tools,
#       but keep this script for users to run manually,
#       open ticket and remove this comment
