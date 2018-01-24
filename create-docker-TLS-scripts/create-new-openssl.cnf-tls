#!/bin/bash
#	create-new-openssl.cnf-tls	3.1	2017-12-19_15:42:25_CST uadmin rpi3b-two.cptx86.com
#	Adding version number
#
#	set -x
#	set -v
#
#	modify /etc/ssl/openssl.conf file
###		
BACKUPFILE=/etc/ssl/openssl.cnf-`date +%y%m%d`
#       Must be root to run this script
if ! [ $(id -u) = 0 ] ; then
        echo "${0} ${LINENO} [ERROR]:   Use sudo ${0}"  1>&2
	echo -e "\n>>	SCRIPT MUST BE RUN AS ROOT TO CHANGE THE /etc/ssl/openssl.cnf FILE	<<"	1>&2
        exit 1
fi
echo    "	This script will make changes to the openssl.cnf file.  These changes are required"
echo    "	before creating user and host TLS files for Docker.  Run this script before running"
echo    "	the user and host TLS scripts.  It is not required to be run on hosts not creating TLS files."
echo -e "\n	Creating backup file of /etc/ssl/openssl.cnf and naming it $BACKUPFILE"
cp /etc/ssl/openssl.cnf $BACKUPFILE
echo -e "\n	Adding the extended KeyUsage at the beginning of the [ v3_ca ] section.\n"
sed '/\[ v3_ca \]/a extendedKeyUsage = clientAuth,serverAuth' $BACKUPFILE > /etc/ssl/openssl.cnf
#	ls -l /etc/ssl
#	diff /etc/ssl/openssl.cnf $BACKUPFILE
