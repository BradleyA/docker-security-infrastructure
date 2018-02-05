#!/bin/bash
#	./copy-host-2-remote-host.sh	3.2	2018-02-02_21:57:45_CST uadmin six-rpi3b.cptx86.com
#	Finished first round of testing
#	copy-host-2-remote-host.sh	3.1	2018-02-02_19:39:51_CST uadmin six-rpi3b.cptx86.com
#	first cut at entering code before testing
#	copy-host-2-remote-host.sh	1.0	2018-02-02_14:46:10_CST uadmin six-rpi3b.cptx86.com
#	initial commit
#
#	set -x
#	set -v
#
display_help() {
echo -e "\nCopy public, private keys and CA to remote host."
echo    "This script uses four arguements;"
echo    "   REMOTEHOST - name of host to copy certificates to"
echo    "   USERHOME - location of admin user directory, default is /home/"
echo    "      Many sites have different home directories (/u/north-office/<user>)"
echo -e "   ADMTLSUSER - site administrator account creating TLS keys,\n\tdefault is user running script"
echo    "      site administrator will have accounts on all systems"
echo    "   SSHPORT - SSH server port, default is port 22"

echo -e "Documentation: https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS\n"
echo -e "Example::\t${0} two.cptx86.com /u/north-office/ uadmin 22\n"
}
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] || [ "$1" == "?" ] ; then
	display_help
	exit 0
fi
###		
REMOTEHOST=$1
USERHOME=${2:-/home/}
ADMTLSUSER=${3:-${USER}}
SSHPORT=${4:-22}
#	Check if admin user has home directory on system
if [ ! -d ${USERHOME}${ADMTLSUSER} ] ; then
	echo -e "${0} ${LINENO} [ERROR]:        ${ADMTLSUSER} does not have a home directory\n\ton this system or ${ADMTLSUSER} home directory is not ${USERHOME}${ADMTLSUSER}"  1>&2
	display_help
	exit 1
fi
#	Check if ${USERHOME}${ADMTLSUSER}/.docker/docker-ca directory on system
if [ ! -d ${USERHOME}${ADMTLSUSER}/.docker/docker-ca ] ; then
	echo -e "${0} ${LINENO} [ERROR]:        default directory,"     1>&2
	echo -e "\t${USERHOME}${ADMTLSUSER}/.docker/docker-ca,\n\tnot on system."  1>&2
	echo -e "\tRunning create-site-private-public-tls.sh will create directories"
	echo -e "\tand site private and public keys.  Then run sudo"
	echo -e "\tcreate-new-openssl.cnf-tls.sh to modify openssl.cnf file."
	display_help
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
	echo -e "${0} ${LINENO} [ERROR]:        Remote host is required.\n"       1>&2
	display_help
	exit 1
fi
#	Check if ${REMOTEHOST}-priv-key.pem file on system
if ! [ -e ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/${REMOTEHOST}-priv-key.pem ] ; then
	echo -e "${0} ${LINENO} [ERROR]:        The ${REMOTEHOST}-priv-key.pem\n\tfile was not found in ${USERHOME}${ADMTLSUSER}/.docker/docker-ca."   1>&2
	echo -e "\tRunning create-host-tls.sh will create public and private keys."
	display_help
	exit 1
fi
#	Check if ${REMOTEHOST} is available on port ${SSHPORT}
if $(nc -z  ${REMOTEHOST} ${SSHPORT} >/dev/null) ; then
	echo -e "${0} ${LINENO} [INFO]:	${ADMTLSUSER} may receive password and\n\tpassphrase prompts from ${REMOTEHOST}. Running ssh-copy-id\n\t${ADMTLSUSER}@${REMOTEHOST} may stop the prompts."
#	Check if /etc/docker directory on ${REMOTEHOST}
	if ! $(ssh -t ${ADMTLSUSER}@${REMOTEHOST} "test -d /etc/docker") ; then
		echo -e "${0} ${LINENO} [ERROR]:	/etc/docker directory missing,"	1>&2
		echo -e "\tis docker installed on ${REMOTEHOST}."	1>&2
		display_help
		exit 1
	fi
#	Check if /etc/docker/certs.d directory exists on remote system
	if $(ssh -t ${ADMTLSUSER}@${REMOTEHOST} "test -d /etc/docker/certs.d" ) ; then
#	Check if /etc/docker/certs.d/daemon/${REMOTEHOST}-priv-key.pem file exists on remote system
		if $(ssh -t ${ADMTLSUSER}@${REMOTEHOST} "test -e /etc/docker/certs.d/daemon/${REMOTEHOST}-priv-key.pem" ) ; then
			echo -e "${0} ${LINENO} [ERROR]:	/etc/docker/certs.d/daemon/${REMOTEHOST}-priv-key.pem\n\talready exists, renaming existing keys so new keys can be created."	1>&2
			ssh -t ${ADMTLSUSER}@${REMOTEHOST} "sudo mv /etc/docker/certs.d/daemon/${REMOTEHOST}-priv-key.pem /etc/docker/certs.d/daemon/${REMOTEHOST}-priv-key.pem`date +%Y-%m-%d_%H:%M:%S_%Z`"
			ssh -t ${ADMTLSUSER}@${REMOTEHOST} "sudo mv /etc/docker/certs.d/daemon/${REMOTEHOST}-cert.pem /etc/docker/certs.d/daemon/${REMOTEHOST}-cert.pem`date +%Y-%m-%d_%H:%M:%S_%Z`"
			ssh -t ${ADMTLSUSER}@${REMOTEHOST} "sudo mv /etc/docker/certs.d/daemon/ca.pem /etc/docker/certs.d/daemon/ca.pem`date +%Y-%m-%d_%H:%M:%S_%Z`"
			ssh -t ${ADMTLSUSER}@${REMOTEHOST} "sudo rm /etc/docker/certs.d/daemon/{cert,key}.pem"
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
	echo -e "${0} ${LINENO} [INFO]: Transfer TLS keys to\n\t${REMOTEHOST}."
	scp -p  ./${REMOTEHOST}${TIMESTAMP}.tar ${ADMTLSUSER}@${REMOTEHOST}:/tmp
#	Create remote directory /etc/docker/certs.d/daemon
#	This directory was selected to place dockerd TLS certifications because
#	docker registry stores it's TLS certifications in /etc/docker/certs.d.
	echo -e "${0} ${LINENO} [INFO]:	Create dockerd certification\n\tdirectory on ${REMOTEHOST}"
#	ssh -t ${ADMTLSUSER}@${REMOTEHOST} "sudo mkdir -p /etc/docker/certs.d/daemon ; sudo chmod -R 0700 /etc/docker/certs.d"
	ssh -t ${ADMTLSUSER}@${REMOTEHOST} "sudo mkdir -p /etc/docker/certs.d/daemon ; sudo chmod -R 0700 /etc/docker/certs.d ; cd / ; sudo tar -xf /tmp/${REMOTEHOST}${TIMESTAMP}.tar ; rm /tmp/${REMOTEHOST}${TIMESTAMP}.tar ; sudo chown -R root.root /etc/docker/certs.d"
#	Remove ${TLSUSER}/.docker and tar file from ${USERHOME}${ADMTLSUSER}/.docker/docker-ca
	cd ..
	rm -rf ${REMOTEHOST}
#       Display instructions about certification environment variables
	echo -e "\nAdd TLS flags to dockerd so it will know to use TLS certifications (--tlsverify,"
	echo    "--tlscacert, --tlscert, --tlskey).  Scripts that will help with setup and"
	echo    "operations of Docker using TLS can be found:"
	echo    "https://github.com/BradleyA/docker-scripts/tree/master/dockerd-configuration-options"
	echo -e "\tThe dockerd-configuration-options scripts will help with"
	echo -e "\tconfiguration of dockerd on systems running Ubuntu 16.04"
	echo -e "\t(systemd) and Ubuntu 14.04 (Upstart).\n"
#
	echo    "If dockerd is already using TLS certifications then:"
	echo -e "\tUbuntu 16.04 (systemd) sudo systemctl restart docker"
	echo -e "\tUbuntu 14.04 (systemd) sudo service docker restart"
	echo -e "${0} ${LINENO} [INFO]:	Done."
	exit 0
else
	echo -e "${0} ${LINENO} [ERROR]:	${REMOTEHOST} not responding on port ${SSHPORT}.\n"  1>&2
	display_help
	exit 1
fi
###
