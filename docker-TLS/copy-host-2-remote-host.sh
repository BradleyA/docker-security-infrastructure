#!/bin/bash
#	copy-host-2-remote-host.sh	1.0	2018-02-02_14:46:10_CST uadmin six-rpi3b.cptx86.com
#	initial commit
###	#
###	#	set -x
###	#	set -v
###	#
display_help() {
###	echo -e "\nCreate public, private keys and CA for host in ${HOME}/.docker/docker-ca"
###	echo    "This script uses two arguements;"
###	echo    "   FQDN - Fully qualified domain name of host requiring new TLS keys"
###	echo    "   NUMBERDAYS - number of days host CA is valid, default 365 days"
###	echo    "   USERHOME - location of admin user directory, default is /home/"
###	echo    "      Many sites have different home directories (/u/north-office/<user>)"
###	echo    "   ADMTLSUSER - site administrator account creating TLS keys, default is user running script"
###	echo    "      site administrator will have accounts on all systems"
###	echo -e "Documentation: https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS\n"
###	echo -e "Example::\t${0} two.cptx86.com 180 /u/north-office/ uadmin\n"
}
###	if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] || [ "$1" == "?" ] ; then
###		display_help
###		exit 0
###	fi
###	###		
###	FQDN=$1
###	NUMBERDAYS=${2:-365}
###	USERHOME=${3:-/home/}
###	ADMTLSUSER=${4:-${USER}}
###	#	Check if admin user has home directory on system
###	if [ ! -d ${USERHOME}${ADMTLSUSER} ] ; then
###		echo -e "${0} ${LINENO} [ERROR]:        ${ADMTLSUSER} does not have a home directory\n\ton this system or ${ADMTLSUSER} home directory is not ${USERHOME}${ADMTLSUSER}"  1>&2
###		display_help
###		exit 1
###	fi
###	#       Check if site CA directory on system
###	if [ ! -d ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private ] ; then
###		echo -e "${0} ${LINENO} [ERROR]:        default directory,"     1>&2
###		echo -e "\t${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private,\n\tnot on system."  1>&2
###		echo -e "\tRunning create-site-private-public-tls.sh will create directories"
###		echo -e "\tand site private and public keys.  Then run sudo"
###		echo -e "\tcreate-new-openssl.cnf-tls.sh to modify openssl.cnf file.  Then run"
###		echo -e "\tcreate-host-tls.sh or create-user-tls.sh as many times as you want."
###		display_help
###		exit 1
###	fi
###	#
###	cd ${USERHOME}${ADMTLSUSER}/.docker/docker-ca
###	#       Check if ca-priv-key.pem file on system
###	if ! [ -e ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem ] ; then
###		echo -e "${0} ${LINENO} [ERROR]:        Site private key\n\t${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem\n\tis not in this location."   1>&2
###		echo -e "\tEither move it from your site secure location to"
###		echo -e "\t${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/"
###		echo -e "\tOr run create-site-private-public-tls.sh and sudo"
###		echo -e "\tcreate-new-openssl.cnf-tls.sh to create a new one."
###		display_help
###		exit 1
###	fi
###	#	Prompt for ${FQDN} if argement not entered
###	if [ -z ${FQDN} ] ; then
###		echo -e "Enter fully qualified domain name (FQDN) requiring new TLS keys:"
###		read FQDN
###	fi
###	#	Check if ${FQDN} string length is zero
###	if [ -z ${FQDN} ] ; then
###		echo -e "${0} ${LINENO} [ERROR]:	A Fully Qualified Domain Name\n\t(FQDN) is required to create new host TLS keys."	1>&2
###		display_help
###		exit 1
###	fi
###	#	Check if ${FQDN}-priv-key.pem file exists
###	if [ -e ${FQDN}-priv-key.pem ] ; then
###		echo -e "${0} ${LINENO} [ERROR]:        ${FQDN}-priv-key.pem already\n\texists, renaming existing keys so new keys can be created."   1>&2
###		mv ${FQDN}-priv-key.pem ${FQDN}-priv-key.pem`date +%Y-%m-%d_%H:%M:%S_%Z`
###		mv ${FQDN}-cert.pem ${FQDN}-cert.pem`date +%Y-%m-%d_%H:%M:%S_%Z`
###	fi
###	#	Creating private key for host ${FQDN}
###	echo -e "${0} ${LINENO} [INFO]:	Creating private key for host\n\t${FQDN}."	1>&2
###	openssl genrsa -out ${FQDN}-priv-key.pem 2048
###	#	Create CSR for host ${FQDN}
###	echo -e "${0} ${LINENO} [INFO]:	Generate a Certificate Signing Request\n\t(CSR) for host ${FQDN}."	1>&2
###	openssl req -sha256 -new -key ${FQDN}-priv-key.pem -subj "/CN=${FQDN}/subjectAltName=${FQDN}" -out ${FQDN}.csr
###	#	Create and sign certificate for host ${FQDN}
###	echo -e "${0} ${LINENO} [INFO]:	Create and sign a ${NUMBERDAYS} day\n\tcertificate for host ${FQDN}."	1>&2
###	openssl x509 -req -days ${NUMBERDAYS} -sha256 -in ${FQDN}.csr -CA ca.pem -CAkey .private/ca-priv-key.pem -CAcreateserial -out ${FQDN}-cert.pem -extensions v3_req -extfile /usr/lib/ssl/openssl.cnf || { echo "${0} ${LINENO} [ERROR]:       Wrong pass phrase for .private/ca-priv-key.pem: " ; exit 1; }
###	openssl rsa -in ${FQDN}-priv-key.pem -out ${FQDN}-priv-key.pem
###	echo -e "${0} ${LINENO} [INFO]:	Removing certificate signing requests\n\t(CSR) and set file permissions for host ${FQDN} key pairs."	1>&2
###	rm ${FQDN}.csr
###	chmod 0400 ${FQDN}-priv-key.pem
###	chmod 0444 ${FQDN}-cert.pem
###	echo -e "${0} ${LINENO} [INFO]:	Instructions for setting up\n\tpublic, private, and certificate files for ${FQDN}.\n"	1>&2
###	echo    "Login to host ${FQDN} and create a Docker daemon TLS directory.  "
###	echo    "		ssh <admin-user>@${FQDN}"
###	echo    "		sudo mkdir -p /etc/docker/certs.d/daemon"
###	echo    "Change the directory permission for the Docker daemon TLS directory on\n\thost ${FQDN} and logout."
###	echo    "		sudo chmod 0700 /etc/docker/certs.d/daemon"
###	echo    "		logout"
###	echo    "Copy the keys from working directory to /tmp directory\n\ton host ${FQDN}."
###	echo    "		scp ./ca.pem <admin-user>@${FQDN}:'/tmp/ca.pem'"
###	echo    "		scp ./${FQDN}-cert.pem <admin-user>@${FQDN}:'/tmp/${FQDN}-cert.pem'"
###	echo    "		scp ./${FQDN}-priv-key.pem <admin-user>@${FQDN}:'/tmp/${FQDN}-priv-key.pem'"
###	echo    "Login to ${FQDN} and move key pair files from the /tmp directory\n\tto Docker daemon TLS directory."
###	echo    "		ssh <admin-user>@${FQDN}"
###	echo    "		cd /tmp"
###	echo    "		sudo mv *.pem /etc/docker/certs.d/daemon"
###	echo    "		sudo chown -R root.root /etc/docker/certs.d/daemon"
###	echo    "		sudo -i"
###	echo    "		cd /etc/docker/certs.d/daemon"
###	echo    "		ln -s ${FQDN}-cert.pem cert.pem"
###	echo    "		ln -s ${FQDN}-priv-key.pem key.pem"
###	echo    "		exit"
###	echo -e "Add TLS flags to dockerd so dockerd will know you are using TLS.\n\t(--tlsverify, --tlscacert, --tlscert, --tlskey)\n"
###	echo -e "Scripts to help with setup and operaations of Docker and TLS:\n\thttps://github.com/BradleyA/docker-scripts/tree/master/dockerd-configuration-options"
###	echo -e "\tThese dockerd-configuration-options scripts will help with\n\tconfiguration of dockerd on systems running Ubuntu 16.04\n\t(systemd) and Ubuntu 14.04 (Upstart)."
###	###
