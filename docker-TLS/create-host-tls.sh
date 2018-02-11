#!/bin/bash
#	create-host-tls.sh	3.6.266	2018-02-10_18:54:43_CST uadmin six-rpi3b.cptx86.com v0.1-260-g2013df8 
#	docker-scripts/docker-TLS; modify format of display_help; closes #6 
#	create-host-tls.sh	3.4	2018-02-01_19:31:40_CST uadmin six-rpi3b.cptx86.com
#	added logic for display_help()
#	create-host-tls.sh	3.3	2018-01-31_09:08:41_CST uadmin six-rpi3b.cptx86.com
#	Improve user feed back messages
#	create-host-tls.sh	3.2	2018-01-31_07:18:02_CST uadmin six-rpi3b.cptx86.com
#	during testing added more checks for files and directories
#	create-host-tls	3.1	2017-12-18_20:16:56_CST uthree
#	Adding version number
#
#	set -x
#	set -v
#
display_help() {
echo -e "\n${0} - Create host public, private keys and CA"
echo -e "\nUSAGE\n   ${0} <FQDN> <#-of-days>  <home-directory> <administrator>" 
echo    "   ${0} [--help | -help | help | -h | h | -? | ?]"
echo -e "\nDESCRIPTION\nAn administration user can run this script to create host public, private keys"
echo    "and CA in working directory, ${HOME}/.docker/docker-ca."
echo -e "\nOPTIONS"
echo    "   FQDN         Fully qualified domain name of host requiring new TLS keys"
echo    "   NUMBERDAYS   number of days host CA is valid, default 365 days"
echo    "   USERHOME     location of admin user directory, default is /home/"
echo    "                sites have different home directories (/u/north-office/)"
echo    "   ADMTLSUSER   site administrator creating TLS keys, default is user running"
echo    "                script."
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS"
echo -e "\nEXAMPLES\n   ${0} two.cptx86.com 180 /u/north-office/ uadmin\n"
}
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] || [ "$1" == "?" ] ; then
	display_help
	exit 0
fi
###		
FQDN=$1
NUMBERDAYS=${2:-365}
USERHOME=${3:-/home/}
ADMTLSUSER=${4:-${USER}}
#	Check if admin user has home directory on system
if [ ! -d ${USERHOME}${ADMTLSUSER} ] ; then
	display_help
	echo -e "${0} ${LINENO} [ERROR]:	${ADMTLSUSER} does not have a home directory\n\ton this system or ${ADMTLSUSER} home directory is not ${USERHOME}${ADMTLSUSER}"	1>&2
	exit 1
fi
#       Check if site CA directory on system
if [ ! -d ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private ] ; then
	display_help
	echo -e "${0} ${LINENO} [ERROR]:	default directory,"	1>&2
	echo -e "\t${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private,\n\tnot on system."	1>&2
	echo -e "\tRunning create-site-private-public-tls.sh will create directories"
	echo -e "\tand site private and public keys.  Then run sudo"
	echo -e "\tcreate-new-openssl.cnf-tls.sh to modify openssl.cnf file.  Then run"
	echo -e "\tcreate-host-tls.sh or create-user-tls.sh as many times as you want."
	exit 1
fi
#
cd ${USERHOME}${ADMTLSUSER}/.docker/docker-ca
#       Check if ca-priv-key.pem file on system
if ! [ -e ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem ] ; then
	display_help
	echo -e "${0} ${LINENO} [ERROR]:	Site private key\n\t${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem\n\tis not in this location."	1>&2
	echo -e "\tEither move it from your site secure location to"
	echo -e "\t${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/"
	echo -e "\tOr run create-site-private-public-tls.sh and sudo"
	echo -e "\tcreate-new-openssl.cnf-tls.sh to create a new one."
	exit 1
fi
#	Prompt for ${FQDN} if argement not entered
if [ -z ${FQDN} ] ; then
	echo -e "Enter fully qualified domain name (FQDN) requiring new TLS keys:"
	read FQDN
fi
#	Check if ${FQDN} string length is zero
if [ -z ${FQDN} ] ; then
	display_help
	echo -e "${0} ${LINENO} [ERROR]:	A Fully Qualified Domain Name\n\t(FQDN) is required to create new host TLS keys."	1>&2
	exit 1
fi
#	Check if ${FQDN}-priv-key.pem file exists
if [ -e ${FQDN}-priv-key.pem ] ; then
	echo -e "${0} ${LINENO} [ERROR]:        ${FQDN}-priv-key.pem already\n\texists, renaming existing keys so new keys can be created."   1>&2
	mv ${FQDN}-priv-key.pem ${FQDN}-priv-key.pem`date +%Y-%m-%d_%H:%M:%S_%Z`
	mv ${FQDN}-cert.pem ${FQDN}-cert.pem`date +%Y-%m-%d_%H:%M:%S_%Z`
fi
#	Creating private key for host ${FQDN}
echo -e "${0} ${LINENO} [INFO]:	Creating private key for host\n\t${FQDN}."	1>&2
openssl genrsa -out ${FQDN}-priv-key.pem 2048
#	Create CSR for host ${FQDN}
echo -e "${0} ${LINENO} [INFO]:	Generate a Certificate Signing Request\n\t(CSR) for host ${FQDN}."	1>&2
openssl req -sha256 -new -key ${FQDN}-priv-key.pem -subj "/CN=${FQDN}/subjectAltName=${FQDN}" -out ${FQDN}.csr
#	Create and sign certificate for host ${FQDN}
echo -e "${0} ${LINENO} [INFO]:	Create and sign a ${NUMBERDAYS} day\n\tcertificate for host ${FQDN}."	1>&2
openssl x509 -req -days ${NUMBERDAYS} -sha256 -in ${FQDN}.csr -CA ca.pem -CAkey .private/ca-priv-key.pem -CAcreateserial -out ${FQDN}-cert.pem -extensions v3_req -extfile /usr/lib/ssl/openssl.cnf || { echo "${0} ${LINENO} [ERROR]:       Wrong pass phrase for .private/ca-priv-key.pem: " ; exit 1; }
openssl rsa -in ${FQDN}-priv-key.pem -out ${FQDN}-priv-key.pem
echo -e "${0} ${LINENO} [INFO]:	Removing certificate signing requests\n\t(CSR) and set file permissions for host ${FQDN} key pairs."	1>&2
rm ${FQDN}.csr
chmod 0400 ${FQDN}-priv-key.pem
chmod 0444 ${FQDN}-cert.pem
echo -e "${0} ${LINENO} [INFO]:	Done.\n"	1>&2
###
