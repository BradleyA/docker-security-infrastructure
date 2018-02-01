#!/bin/bash
#	copy-user-2-remote-host.sh	3.5	2018-02-01_15:58:23_CST uadmin six-rpi3b.cptx86.com
#	all known use cases tested, no known issues
#	./copy-user-2-remote-host.sh	3.4	2018-02-01_13:12:19_CST uadmin six-rpi3b.cptx86.com
#	added login for display_help()
#	./copy-user-2-remote-host.sh	3.3	2018-02-01_12:34:08_CST uadmin six-rpi3b.cptx86.com
#	debug complete for admin user copy user TLS keys to remote system ~/.docker
#	copy-user-remote-host.sh	3.2	2018-01-25_23:23:05_CST uadmin rpi3b-four.cptx86.com
#	changed variable names and added test login, need alot of testing
#	copy-user-remote-host	3.1	2017-12-19_15:32:23_CST utwo two.cptx86.com
#	Adding version number and upload latest
#
#	set -x
#	set -v
#
display_help() {
echo -e "\nCopy public and private key and CA for user to remote host."
echo    "This script uses five arguements;"
echo    "   TLSUSER - user requiring new TLS keys on remote host, default is user running script"
echo    "   REMOTEHOST - name of host to copy certificates to"
echo    "   USERHOME - location of admin user directory, default is /home/"
echo    "      Many sites have different home directories (/u/north-office/<user>)"
echo    "   ADMTLSUSER - site administrator account creating TLS keys, default is user running script"
echo    "      site administrator will have accounts on all systems"
echo    "   SSHPORT - SSH server port, default is port 22"
echo -e "Documentation: https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS-scripts\n"
echo -e "Example:\t${0} bob two.cptx96.com /u/north-office/ uadmin 22\n"
}
# >>>>> Test use cases
#	works -	use case 1 TLSUSER is able to copy TLS keys and CA to remote system with same user ID
#	works -	use case 2 uadmin is able to copy TLS keys and CA to remote system with another USER ID
#		and chown chmod and write to remote user home directory 
#	does not mater because using ~ - does the remote system have the same home directory for user on remote system
#
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] || [ "$1" == "?" ] ; then
	display_help
	exit 0
fi 
###
TLSUSER=${1:-${USER}}
REMOTEHOST=$2
USERHOME=${3:-/home/}
ADMTLSUSER=${4:-${USER}}
SSHPORT=${5:-22}
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
#	Check if ${TLSUSER}-user-priv-key.pem file on system
if ! [ -e ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/${TLSUSER}-user-priv-key.pem ] ; then
	echo -e "${0} ${LINENO} [ERROR]:	The ${TLSUSER}-user-priv-key.pem\n\tfile was not found in ${USERHOME}${ADMTLSUSER}/.docker/docker-ca."   1>&2
	echo -e "\tRunning create-user-tls.sh will create public and private keys."
	display_help
	exit 1
fi
#	Prompt for ${REMOTEHOST} if argement not entered
if [ -z ${REMOTEHOST} ] ; then
	echo    "Enter remote host where TLS keys are to be copied:"
	read REMOTEHOST
fi
#	Check if ${REMOTEHOST} string length is zero
if [ -z ${REMOTEHOST} ] ; then
	echo -e "${0} ${LINENO} [ERROR]:	Remote host is required.\n"       1>&2
	display_help
	exit 1
fi
#	Check if ${REMOTEHOST} is available on port ${SSHPORT}
if $(nc -z  ${REMOTEHOST} ${SSHPORT} >/dev/null) ; then
	echo -e "${0} ${LINENO} [INFO]:	May receive ${ADMTLSUSER} password prompt from ${REMOTEHOST}."
	ssh -t ${ADMTLSUSER}@${REMOTEHOST} " cd ~${TLSUSER} " || { echo "${0} ${LINENO} [ERROR]:	${TLSUSER} does not have home directory on ${REMOTEHOST}" ; exit 1; }
	echo -e "${0} ${LINENO} [INFO]:	Create directory, change\n\tfile permissions, and copy TLS keys to ${TLSUSER}@${REMOTEHOST}."
	cd ${USERHOME}${ADMTLSUSER}/.docker/docker-ca
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
	echo -e "${0} ${LINENO} [INFO]:	Transfer TLS keys to ${TLSUSER}@${REMOTEHOST}."
	scp -p  ./${TLSUSER}${REMOTEHOST}${TIMESTAMP}.tar ${ADMTLSUSER}@${REMOTEHOST}:/tmp
#	Check if ${TLSUSER} == ${ADMTLSUSER} because sudo is not required for user copying their certs
	if [ ${TLSUSER} == ${ADMTLSUSER} ] ; then
		echo " root not needed"
		ssh -t ${ADMTLSUSER}@${REMOTEHOST} " cd ~${TLSUSER} ; tar -xf /tmp/${TLSUSER}${REMOTEHOST}${TIMESTAMP}.tar ; rm /tmp/${TLSUSER}${REMOTEHOST}${TIMESTAMP}.tar ; chown -R ${TLSUSER}.${TLSUSER} .docker "
	else
		echo " root IS needed"
		ssh -t ${ADMTLSUSER}@${REMOTEHOST} " cd ~${TLSUSER} ; sudo tar -xf /tmp/${TLSUSER}${REMOTEHOST}${TIMESTAMP}.tar ; rm /tmp/${TLSUSER}${REMOTEHOST}${TIMESTAMP}.tar ; sudo chown -R ${TLSUSER}.${TLSUSER} .docker "
	fi
#	Remove ${TLSUSER}/.docker and tar file from ${USERHOME}${ADMTLSUSER}/.docker/docker-ca
	cd ..
	rm -rf ${TLSUSER}
	echo -e "${0} ${LINENO} [INFO]:	Done."
	exit 0
else
	echo -e "${0} ${LINENO} [ERROR]:	${REMOTEHOST} not responding on port ${SSHPORT}.\n"  1>&2
	display_help
	exit 1
fi
###
