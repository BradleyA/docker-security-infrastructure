#!/bin/bash
#	create-user-tls.sh	3.4	2018-02-01_21:03:44_CST uadmin six-rpi3b.cptx86.com
#	added logic for display_help():w
#	create-user-tls.sh	3.3	2018-01-31_09:09:37_CST uadmin six-rpi3b.cptx86.com
#	Improve user feed back messages
#	create-user-tls.sh	3.2	2018-01-30_19:15:34_CST uadmin six-rpi3b.cptx86.com
#	during testing added more checks for files and directories
#	create-user-tls	3.1	2017-12-19_15:19:59_CST uadmin rpi3b-two.cptx86.com
#	Adding version number and upload latest
#
#	set -x
#	set -v
#
display_help() {
echo -e "\nCreate public and private key and CA for user"
echo    "This script uses four arguements;"
echo    "   TLSUSER - user requiring new TLS keys, default is user running script"
echo    "   NUMBERDAYS - number of days user keys are valid, default 90 days"
echo    "   USERHOME - location of admin user directory, default is /home/"
echo    "      Many sites have different home directories (/u/north-office/<user>)"
echo    "   ADMTLSUSER - administration user creating TLS accounts, default is user running script"
echo    "This script creates public, private keys and CA for a user."
echo -e "Documentation: https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS-scripts\n"
echo -e "Example:\t${0} bob 30 /u/north-office/ uadmin\n"
}
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] || [ "$1" == "?" ] ; then
	display_help
	exit 0
fi
###		
TLSUSER=${1:-${USER}}
NUMBERDAYS=${2:-90}
USERHOME=${3:-/home/}
ADMTLSUSER=${4:-${USER}}
#	Check if admin user has home directory on system
if [ ! -d ${USERHOME}${ADMTLSUSER} ] ; then
	echo -e "${0} ${LINENO} [ERROR]:        ${ADMTLSUSER} does not have a home directory\n\ton this system or ${ADMTLSUSER} home directory is not ${USERHOME}${ADMTLSUSER}"  1>&2
	display_help
	exit 1
fi
#	Check if site CA directory on system
if [ ! -d ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private ] ; then
	echo -e "${0} ${LINENO} [ERROR]:        default directory,"	1>&2
	echo -e "\t${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private,\n\tnot on system."  1>&2
	echo -e "\tRunning create-site-private-public-tls.sh will create directories"
	echo -e "\tand site private and public keys.  Then run sudo"
	echo -e "\tcreate-new-openssl.cnf-tls.sh to modify openssl.cnf file.  Then run"
	echo -e "\tcreate-host-tls.sh or create-user-tls.sh as many times as you want."
	display_help
	exit 1
fi
#
cd ${USERHOME}${ADMTLSUSER}/.docker/docker-ca
#	Check if ca-priv-key.pem file on system
if ! [ -e ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem ] ; then
	echo -e "${0} ${LINENO} [ERROR]:        Site private key\n\t${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem\n\tis not in this location."   1>&2
	echo -e "\tEither move it from your site secure location to"
	echo -e "\t${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/"
	echo -e "\tOr run create-site-private-public-tls.sh and sudo"
	echo -e "\tcreate-new-openssl.cnf-tls.sh to create a new one."
	display_help
	exit 1
fi
#	Check if ${TLSUSER}-user-priv-key.pem file on system
if [ -e ${TLSUSER}-user-priv-key.pem ] ; then
	echo -e "${0} ${LINENO} [ERROR]:	${TLSUSER}-user-priv-key.pem already exists,\n\trenaming existing keys so new keys can be created."   1>&2
	mv ${TLSUSER}-user-priv-key.pem ${TLSUSER}-user-priv-key.pem`date +%Y-%m-%d_%H:%M:%S_%Z`
	mv ${TLSUSER}-user-cert.pem ${TLSUSER}-user-cert.pem`date +%Y-%m-%d_%H:%M:%S_%Z`
fi
#	Creating private key for user ${TLSUSER}
echo    "${0} ${LINENO} [INFO]:	Creating private key for user ${TLSUSER}."	1>&2
openssl genrsa -out ${TLSUSER}-user-priv-key.pem 2048
#	Generate a Certificate Signing Request (CSR)
echo -e "${0} ${LINENO} [INFO]:	Generate a Certificate Signing\n\tRequest (CSR) for user ${TLSUSER}."	1>&2
openssl req -subj '/subjectAltName=client' -new -key ${TLSUSER}-user-priv-key.pem -out ${TLSUSER}-user.csr
#	Create and sign a ${NUMBERDAYS} day certificate
echo -e "${0} ${LINENO} [INFO]:	Create and sign a ${NUMBERDAYS} day\n\tcertificate for user ${TLSUSER}."	1>&2
openssl x509 -req -days ${NUMBERDAYS} -sha256 -in ${TLSUSER}-user.csr -CA ca.pem -CAkey .private/ca-priv-key.pem -CAcreateserial -out ${TLSUSER}-user-cert.pem || { echo "${0} ${LINENO} [ERROR]:	Wrong pass phrase for .private/ca-priv-key.pem: " ; exit 1; }
#	Removing certificate signing requests (CSR)
echo -e "${0} ${LINENO} [INFO]:	Removing certificate signing\n\trequests (CSR) and set file permissions for ${TLSUSER} key pairs."	1>&2
#
rm ${TLSUSER}-user.csr
chmod 0400 ${TLSUSER}-user-priv-key.pem
chmod 0444 ${TLSUSER}-user-cert.pem
echo -e "${0} ${LINENO} [INFO]: Done."
###
