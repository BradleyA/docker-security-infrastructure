#!/bin/bash
#	./create-new-openssl.cnf-tls.sh	3.4	2018-02-01_19:52:46_CST uadmin six-rpi3b.cptx86.com
#	added logic for display_help()
#	create-new-openssl.cnf-tls.sh	3.2	2018-01-29_15:29:42_CST uadmin six-rpi3b.cptx86.com
#	add logic to test if changes to openssl have previously been made
#	create-new-openssl.cnf-tls	3.1	2017-12-19_15:42:25_CST uadmin rpi3b-two.cptx86.com
#	Adding version number
#
#	set -x
#	set -v
#
display_help() {
echo -e "\nModify /etc/ssl/openssl.conf file"
echo    "This script makes changes to openssl.cnf file which are required for"
echo    "create-user-tls and create-host-tls scripts.  It must be run as root."
echo -e "Documentation: https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS\n"
echo -e "Example:\tsudo ${0}\n"
}
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] || [ "$1" == "?" ] ; then
	display_help
	exit 0
fi
###		
BACKUPFILE=/etc/ssl/openssl.cnf-`date +%Y-%m-%d_%H:%M:%S_%Z`
ORIGINALFILE=/etc/ssl/openssl.cnf
#       Must be root to run this script
if ! [ $(id -u) = 0 ] ; then
        echo -e "\n${0} ${LINENO} [ERROR]:   Use sudo ${0}"  1>&2
	echo -e "\n>>	SCRIPT MUST BE RUN AS ROOT TO MODIFY THE ${ORIGINALFILE}	<<\n"	1>&2
	display_help
        exit 1
fi
#	Check if ${ORIGINALFILE} file has previously been modified
if ! grep -Fxq 'extendedKeyUsage = clientAuth,serverAuth' ${ORIGINALFILE} ; then
	echo    "This script will make changes to ${ORIGINALFILE} file."
	echo    "These changes are required before creating user and host TLS keys for Docker."
	echo    "Run this script before running the user and host TLS scripts.  It is not"
	echo    "required to be run on hosts not creating tTLS keys."
	echo -e "\nCreating backup file of ${ORIGINALFILE} and naming it ${BACKUPFILE}"
	cp ${ORIGINALFILE} ${BACKUPFILE}
	echo -e "\n${0} ${LINENO} [INFO]:	Adding the extended KeyUsage\n\tat the beginning of [ v3_ca ] section."	1>&2
	sed '/\[ v3_ca \]/a extendedKeyUsage = clientAuth,serverAuth' ${BACKUPFILE} > ${ORIGINALFILE}
else
	echo -e "\n${0} ${LINENO} [ERROR]:	${ORIGINALFILE} file has previously been modified.\n"	1>&2
fi
###
