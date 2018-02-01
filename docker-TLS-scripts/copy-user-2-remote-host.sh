#!/bin/bash
#	copy-user-remote-host.sh	3.2	2018-01-25_23:23:05_CST uadmin rpi3b-four.cptx86.com
#	changed variable names and added test login, need alot of testing
#	copy-user-remote-host	3.1	2017-12-19_15:32:23_CST utwo two.cptx86.com
#	Adding version number and upload latest
#
#	set -x
#	set -v
#
#	Copy public and private key and CA for user to remote host
#	This script uses two arguements;
#		TLSUSER - user requiring new TLS keys on remote host, default is user running script
#		REMOTEHOST - name of host to copy certificates to
#               USERHOME - location of admin user directory, default is /home/
#                  Many sites have different home directories (/u/north-office/<user>)
#               ADMTLSUSER - administration user creating TLS accounts, default is user running script
#		SSHPORT - SSH server port, default port 22
#	Documentation: https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS-scripts
#
# >>>>> This scrip 
#	use case 1 TLSUSER is able to copy TLS keys and CA to remote system with same user ID
#	use case 2 uadmin is able to copy TLS keys and CA to remote system with another USER ID
#		and chown chmod and write to remote user home directory 
#	think about using tar to create transfer and untar then chown and chmod
#	need a host version that copies keys and cert to remote system in secure directory to untar
#	does the remote system have the same home directory for user on remote system
# >>>>>	Need to test to determine how to support this for uadmin to admin@remotesystem and uadmin to <otheruser>@remotesystem
#	
#	will require more logic to support all use cases and updated prompts
#	uadmin is the account for site and all clusters
#	may want to see how to support more than one uadmin account in clusters for this script
#	this opens up challenge with different users needing to chown and chgrp for different remote users
#	
#	
###
TLSUSER=${1:-${USER}}
REMOTEHOST=$2
USERHOME=${3:-/home/}
ADMTLSUSER=${4:-${USER}}
SSHPORT=${5:-22}
#
# >>>>> Add systax --help -? -h -help for scripts
#
#	Check if admin user has home directory on system
if [ ! -d ${USERHOME}${ADMTLSUSER} ] ; then
	echo -e "${0} ${LINENO} [ERROR]:        ${ADMTLSUSER} does not have a home directory\n\ton this system or ${ADMTLSUSER} home directory is not ${USERHOME}${ADMTLSUSER}"  1>&2
	exit 1
fi
#	Check if ${USERHOME}${ADMTLSUSER}/.docker/docker-ca directory on system
if [ ! -d ${USERHOME}${ADMTLSUSER}/.docker/docker-ca ] ; then
	echo -e "${0} ${LINENO} [ERROR]:        default directory,"     1>&2
	echo -e "\t${USERHOME}${ADMTLSUSER}/.docker/docker-ca,\n\tnot on system."  1>&2
	exit 1
fi
#	Check if ${TLSUSER}-user-priv-key.pem file on system
if ! [ -e ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/${TLSUSER}-user-priv-key.pem ] ; then
	echo -e "${0} ${LINENO} [ERROR]:	The ${TLSUSER}-user-priv-key.pem\n\tfile was not found in ${USERHOME}${ADMTLSUSER}/.docker/docker-ca."   1>&2
	exit 1
fi
#	Prompt for ${REMOTEHOST} if argement not entered
if [ -z ${REMOTEHOST} ] ; then
	echo    "Enter remote host where TLS keys are to be copied:"
	read REMOTEHOST
fi
#	Check if ${REMOTEHOST} string length is zero
if [ -z ${REMOTEHOST} ] ; then
	echo -e "${0} ${LINENO} [ERROR]:	Remote host is required."       1>&2
	exit 1
fi
#	check if ${REMOTEHOST} is available on port ${SSHPORT}
if $(nc -z  ${REMOTEHOST} ${SSHPORT} >/dev/null) ; then
	cd ${USERHOME}${ADMTLSUSER}/.docker/docker-ca
	echo -e "${0} ${LINENO} [INFO]:	Create directory, change\n\tpermissions, and copy TLS key to ${TLSUSER}@${REMOTEHOST}."
	mkdir -p ${TLSUSER}/.docker
	chmod 700 ${TLSUSER}/.docker
	cp -p ca.pem ${TLSUSER}/.docker
	cp -p ${TLSUSER}-user-cert.pem ${TLSUSER}/.docker
	cp -p ${TLSUSER}-user-priv-key.pem ${TLSUSER}/.docker
	TIMESTAMP=`date +%Y-%m-%d-%H-%M-%S-%Z`
	cd ${TLSUSER}/.docker
	ln -s ${TLSUSER}-user-cert.pem cert.pem
	ln -s ${TLSUSER}-user-priv-key.pem key.pem
	cd ..
	tar -cf ./${TLSUSER}${REMOTEHOST}${TIMESTAMP}.tar .docker
	scp -p  ./${TLSUSER}${REMOTEHOST}${TIMESTAMP}.tar ${ADMTLSUSER}@${REMOTEHOST}:/tmp
#	ssh -t ${ADMTLSUSER}@${REMOTEHOST} cd ~${TLSUSER} ; sudo tar -xf /tmp/${TLSUSER}${REMOTEHOST}${TIMESTAMP}.tar ; sudo chown -R  ${TLSUSER}.${TLSUSER} .docker
#	next line works last night
#	ssh -t ${ADMTLSUSER}@${REMOTEHOST} " cd ~${TLSUSER} ; pwd ; hostname -f ; sudo tar -xvf /tmp/${TLSUSER}${REMOTEHOST}${TIMESTAMP}.tar ; rm /tmp/${TLSUSER}${REMOTEHOST}${TIMESTAMP}.tar ;  sudo chown -R  ${TLSUSER}.${TLSUSER} .docker "
	ssh -t ${ADMTLSUSER}@${REMOTEHOST} " cd ~${TLSUSER} ; sudo tar -xf /tmp/${TLSUSER}${REMOTEHOST}${TIMESTAMP}.tar ; rm /tmp/${TLSUSER}${REMOTEHOST}${TIMESTAMP}.tar ;  sudo chown -R  ${TLSUSER}.${TLSUSER} .docker "
pwd
###	uncomment after debugging
#	Remove ${TLSUSER}/.docker and tar file of it
	cd ${USERHOME}${ADMTLSUSER}/.docker/docker-ca
#	rm -rf ${TLSUSER}
###
else
	echo -e "${0} ${LINENO} [ERROR]:	${REMOTEHOST} not responding on port ${SSHPORT}.\n"  1>&2
	exit 1
fi
###
