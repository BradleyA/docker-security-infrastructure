#!/bin/bash
# 	create-user-tls.sh	3.7.291	2018-02-18_23:16:00_CST uadmin six-rpi3b.cptx86.com 3.7 
# 	   New release, ready for production 
# 	create-user-tls.sh	3.6.286	2018-02-15_13:21:37_CST uadmin six-rpi3b.cptx86.com 3.6-19-g7e77a24 
# 	   added --version and -v close #9 
#	create-user-tls.sh	3.6.276	2018-02-10_19:26:37_CST uadmin six-rpi3b.cptx86.com 3.6-9-g8424312 
#	docker-scripts/docker-TLS; modify format of display_help; closes #6 
#
#	set -x
#	set -v
#
display_help() {
echo -e "\n${0} - Create user public and private key and CA"
echo -e "\nUSAGE\n   ${0} <TLS-user> <#-of-days> <home-directory> <administrator>"
echo    "   ${0} [--help | -help | help | -h | h | -? | ?] [--version | -v]"
echo -e "\nDESCRIPTION\nRun this script any time a user requires a new Docker public and private"
echo    "TLS key."
echo -e "\nOPTIONS "
echo    "   TLSUSER      user requiring new TLS keys, default is user running script"
echo    "   NUMBERDAYS   number of days user keys are valid, default 90 days"
echo    "   USERHOME     location of admin user directory, default is /home/"
echo    "                Many sites have different home directories (/u/north-office/)"
echo    "   ADMTLSUSER   administration user creating TLS accounts, default is user"
echo    "                running script"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS"
echo -e "\nEXAMPLES\n   Create TLS keys for user bob for 30 days in /u/north-office/ uadmin\n\t${0} bob 30 /u/north-office/ uadmin\n"
}
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] || [ "$1" == "?" ] ; then
	display_help
	exit 0
fi
if [ "$1" == "--version" ] || [ "$1" == "-v" ] ; then
        head -2 ${0} | awk {'print$2"\t"$3'}
        exit 0
fi
###		
TLSUSER=${1:-${USER}}
NUMBERDAYS=${2:-90}
USERHOME=${3:-/home/}
ADMTLSUSER=${4:-${USER}}
#	Check if admin user has home directory on system
if [ ! -d ${USERHOME}${ADMTLSUSER} ] ; then
	display_help
	echo -e "${0} ${LINENO} [ERROR]:	${ADMTLSUSER} does not have a home directory\n\ton this system or ${ADMTLSUSER} home directory is not ${USERHOME}${ADMTLSUSER}"	1>&2
	exit 1
fi
#	Check if site CA directory on system
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
#	Check if ca-priv-key.pem file on system
if ! [ -e ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem ] ; then
	echo -e "${0} ${LINENO} [ERROR]:        Site private key\n\t${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem\n\tis not in this location."   1>&2
	display_help
	echo -e "\tEither move it from your site secure location to"
	echo -e "\t${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/"
	echo -e "\tOr run create-site-private-public-tls.sh and sudo"
	echo -e "\tcreate-new-openssl.cnf-tls.sh to create a new one."
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
