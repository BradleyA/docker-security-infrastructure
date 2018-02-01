#!/bin/bash
#	create-new-openssl.cnf-tls.sh	3.2	2018-01-29_15:29:42_CST uadmin six-rpi3b.cptx86.com
#	add logic to test if changes to openssl have previously been made
#	create-new-openssl.cnf-tls	3.1	2017-12-19_15:42:25_CST uadmin rpi3b-two.cptx86.com
#	Adding version number
#
#	set -x
#	set -v
#
#	Modify /etc/ssl/openssl.conf file
#	This script makes changes to openssl.cnf file which are required for create-user-tls and create-host-tls scripts.
#	Documentation: https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS-scripts
###		
BACKUPFILE=/etc/ssl/openssl.cnf-`date +%Y-%m-%d_%H:%M:%S_%Z`
ORIGINALFILE=/etc/ssl/openssl.cnf
#       Must be root to run this script
if ! [ $(id -u) = 0 ] ; then
        echo -e "\n${0} ${LINENO} [ERROR]:   Use sudo ${0}"  1>&2
	echo -e "\n>>	SCRIPT MUST BE RUN AS ROOT TO MODIFY THE ${ORIGINALFILE}	<<\n"	1>&2
        exit 1
fi
#	Check if ${ORIGINALFILE} file has previously been modified
if ! grep -Fxq 'extendedKeyUsage = clientAuth,serverAuth' ${ORIGINALFILE} ; then
	echo    "	This script will make changes to ${ORIGINALFILE} file.  These changes are required"
	echo    "	before creating user and host TLS keys for Docker.  Run this script before running"
	echo -e "	the user and host TLS scripts.  It is not required to be run on hosts not creating\n\tTLS keys."
	echo -e "\n	Creating backup file of ${ORIGINALFILE} and naming it ${BACKUPFILE}"
	cp ${ORIGINALFILE} ${BACKUPFILE}
	echo -e "\n	Adding the extended KeyUsage at the beginning of the [ v3_ca ] section.\n"
	sed '/\[ v3_ca \]/a extendedKeyUsage = clientAuth,serverAuth' ${BACKUPFILE} > ${ORIGINALFILE}
else
        echo -e "\n${0} ${LINENO} [ERROR]:	${ORIGINALFILE} file has previously been modified.\n"	1>&2
fi
###
