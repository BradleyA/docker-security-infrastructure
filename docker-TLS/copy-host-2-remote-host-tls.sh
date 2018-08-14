#!/bin/bash
# 	docker-TLS/copy-host-2-remote-host-tls.sh  3.42.391  2018-08-12_10:59:20_CDT  https://github.com/BradleyA/docker-scripts  uadmin  three-rpi3b.cptx86.com 3.41-8-g21e9f27  
# 	   sync to standard script design changes 
# 	docker-TLS/copy-host-2-remote-host-tls.sh  3.32.370  2018-08-05_11:49:59_CDT  https://github.com/BradleyA/docker-scripts  uadmin  three-rpi3b.cptx86.com 3.31-1-g513fe7d  
# 	   re-marking this file with later version of markit to support check-markit 
###
DEBUG=0                 # 0 = debug off, 1 = debug on
#	set -x
#	set -v
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
###
display_help() {
echo -e "\n${NORMAL}${0} - Copy public, private keys and CA to remote host."
echo -e "\nUSAGE\n   ${0} <remote-host> [<home-directory>] [<administrator>] [<ssh-port>]"
echo    "   ${0} [--help | -help | help | -h | h | -? | ?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION\nAn administration user can run this script to copy host TLS public, private"
echo    "keys, and CA to a remote host.  The administration user may receive password"
echo    "and passphrase prompts from a remote host; running"
echo    "   ssh-copy-id <admin-user>@x.x.x.x"
echo    "may stop the prompts in your cluster."
echo -e "\nOPTIONS"
echo    "   REMOTEHOST   remote host to copy certificates to"
echo    "   USERHOME     location of admin user directory, default is /home/"
echo    "      Many sites have different home directories (/u/north-office/)"
echo    "   ADMTLSUSER   site administrator account creating TLS keys,"
echo    "      default is user running script.  Site administrator will have accounts"
echo    "      on all systems in cluster."
echo    "   SSHPORT      SSH server port, default is port 22"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS"
echo -e "\nEXAMPLES\n   ${0} two.cptx86.com\n\n   Administrator user copies TLS keys and CA to remote host, two.cptx86.com,"
echo    "   using default home directory, /home/, default administrator, user running"
echo -e "   script.\n"
echo -e "   ${0} two.cptx86.com /u/north-office/ uadmin\n\n   Administrator user copies TLS keys and CA to remote host, two.cptx86.com,"
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
REMOTEHOST=$1
USERHOME=${2:-/home/}
ADMTLSUSER=${3:-${USER}}
SSHPORT=${4:-22}
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
#	Check if ${REMOTEHOST} is available on port ${SSHPORT} # >>> try if $(ssh ${NODE} exit >/dev/null) ; then:w

if $(nc -z  ${REMOTEHOST} ${SSHPORT} >/dev/null) ; then
	echo -e "${NORMAL}${0} ${LINENO} [${BOLD}INFO${NORMAL}]:	${ADMTLSUSER} may receive password and\n\tpassphrase prompts from ${REMOTEHOST}. Running ssh-copy-id\n\t${ADMTLSUSER}@${REMOTEHOST} may stop the prompts.\n"
#	Check if /etc/docker directory on ${REMOTEHOST}
	if ! $(ssh -tp ${SSHPORT} ${ADMTLSUSER}@${REMOTEHOST} "test -d /etc/docker") ; then
		display_help
		echo -e "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:	/etc/docker directory missing,"	1>&2
		echo -e "\tis docker installed on ${REMOTEHOST}."	1>&2
		exit 1
	fi
#	Check if /etc/docker/certs.d directory exists on remote system
	if $(ssh -tp ${SSHPORT} ${ADMTLSUSER}@${REMOTEHOST} "test -d /etc/docker/certs.d" ) ; then
#	Check if /etc/docker/certs.d/daemon/${REMOTEHOST}-priv-key.pem file exists on remote system
		if $(ssh -tp ${SSHPORT} ${ADMTLSUSER}@${REMOTEHOST} "test -e /etc/docker/certs.d/daemon/${REMOTEHOST}-priv-key.pem" ) ; then
			echo -e "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:	/etc/docker/certs.d/daemon/${REMOTEHOST}-priv-key.pem\n\talready exists, renaming existing keys so new keys can be created."	1>&2
			ssh -tp ${SSHPORT} ${ADMTLSUSER}@${REMOTEHOST} "sudo mv /etc/docker/certs.d/daemon/${REMOTEHOST}-priv-key.pem /etc/docker/certs.d/daemon/${REMOTEHOST}-priv-key.pem`date +%Y-%m-%d_%H:%M:%S_%Z`"
			ssh -tp ${SSHPORT} ${ADMTLSUSER}@${REMOTEHOST} "sudo mv /etc/docker/certs.d/daemon/${REMOTEHOST}-cert.pem /etc/docker/certs.d/daemon/${REMOTEHOST}-cert.pem`date +%Y-%m-%d_%H:%M:%S_%Z`"
			ssh -tp ${SSHPORT} ${ADMTLSUSER}@${REMOTEHOST} "sudo mv /etc/docker/certs.d/daemon/ca.pem /etc/docker/certs.d/daemon/ca.pem`date +%Y-%m-%d_%H:%M:%S_%Z`"
			ssh -tp ${SSHPORT} ${ADMTLSUSER}@${REMOTEHOST} "sudo rm /etc/docker/certs.d/daemon/{cert,key}.pem"
		fi
	fi
#	Create certification tar file and install it to ${REMOTEHOST}
	mkdir -p ${REMOTEHOST}/etc/docker/certs.d/daemon
	chmod 700 ${REMOTEHOST}/etc/docker/certs.d/daemon
	cp -p ${REMOTEHOST}-priv-key.pem ${REMOTEHOST}/etc/docker/certs.d/daemon
	cp -p ${REMOTEHOST}-cert.pem ${REMOTEHOST}/etc/docker/certs.d/daemon
	cp -p ca.pem ${REMOTEHOST}/etc/docker/certs.d/daemon
	TIMESTAMP=`date +%Y-%m-%d-%H-%M-%S-%Z`
	cd ${REMOTEHOST}/etc/docker/certs.d/daemon
	ln -s ${REMOTEHOST}-priv-key.pem key.pem
	ln -s ${REMOTEHOST}-cert.pem cert.pem
	cd ../../../..
	tar -cf ./${REMOTEHOST}${TIMESTAMP}.tar ./etc/docker/certs.d/daemon
	echo -e "\n${NORMAL}${0} ${LINENO} [${BOLD}INFO${NORMAL}]: Transfer TLS keys to\n\t${REMOTEHOST}.\n"
	scp -pP ${SSHPORT} ./${REMOTEHOST}${TIMESTAMP}.tar ${ADMTLSUSER}@${REMOTEHOST}:/tmp
#	Create remote directory /etc/docker/certs.d/daemon
#	This directory was selected to place dockerd TLS certifications because
#	docker registry stores it's TLS certifications in /etc/docker/certs.d.
	echo -e "\n${NORMAL}${0} ${LINENO} [${BOLD}INFO${NORMAL}]:	Create dockerd certification\n\tdirectory on ${REMOTEHOST}\n"
#	ssh -tp ${SSHPORT} ${ADMTLSUSER}@${REMOTEHOST} "sudo mkdir -p /etc/docker/certs.d/daemon ; sudo chmod -R 0700 /etc/docker/certs.d"
	ssh -tp ${SSHPORT} ${ADMTLSUSER}@${REMOTEHOST} "sudo mkdir -p /etc/docker/certs.d/daemon ; sudo chmod -R 0700 /etc/docker/certs.d ; cd / ; sudo tar -xf /tmp/${REMOTEHOST}${TIMESTAMP}.tar ; rm /tmp/${REMOTEHOST}${TIMESTAMP}.tar ; sudo chown -R root.root /etc/docker/certs.d"
#	Remove ${TLSUSER}/.docker and tar file from ${USERHOME}${ADMTLSUSER}/.docker/docker-ca
	cd ..
	rm -rf ${REMOTEHOST}
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
	echo -e "\tUbuntu 16.04 (Systemd) sudo systemctl restart docker"
	echo -e "\tUbuntu 14.04 (Upstart) sudo service docker restart"
	echo -e "\n${0} ${LINENO} [INFO]:	Done."
	exit 0
else
	display_help
	echo -e "\n${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:	${REMOTEHOST} not responding on port ${SSHPORT}.\n"	1>&2
	exit 1
fi
###
#       May want to create a version of this script that automates this process for SRE tools,
#       but keep this script for users to run manually,
#       open ticket and remove this comment
