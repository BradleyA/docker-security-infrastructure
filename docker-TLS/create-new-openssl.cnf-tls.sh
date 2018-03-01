#!/bin/bash
# 	docker-TLS/create-new-openssl.cnf-tls.sh  3.15.318  2018-02-28_21:41:27_CST  https://github.com/BradleyA/docker-scripts  uadmin  four-rpi3b.cptx86.com 3.14-2-g9866315  
# 	   ready for production 
# 	create-new-openssl.cnf-tls.sh  3.14.315  2018-02-27_21:01:40_CST  https://github.com/BradleyA/docker-scripts  uadmin  four-rpi3b.cptx86.com 3.13  
# 	   added BOLD and NORMAL with little testing 
#
#	set -x
#	set -v
#
display_help() {
echo -e "\n${0} - Modify /etc/ssl/openssl.conf file"
echo -e "\nUSAGE\n   sudo ${0}"
echo    "   ${0} [--help | -help | help | -h | h | -? | ?] [--version | -v]"
echo -e "\nDESCRIPTION\nThis script makes a change to openssl.cnf file which is required for"
echo    "create-user-tls.sh and create-host-tls.sh scripts.  It must be run as root."
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS"
echo -e "\nnEXAMPLES\n   sudo ${0}\n"
}
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] || [ "$1" == "?" ] ; then
	display_help
	exit 0
fi
if [ "$1" == "--version" ] || [ "$1" == "-v" ] || [ "$1" == "version" ] ; then
        head -2 ${0} | awk {'print$2"\t"$3'}
        exit 0
fi
###		
BACKUPFILE=/etc/ssl/openssl.cnf-`date +%Y-%m-%d_%H:%M:%S_%Z`
ORIGINALFILE=/etc/ssl/openssl.cnf
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
#       Must be root to run this script
if ! [ $(id -u) = 0 ] ; then
	display_help
        echo -e "${NORMAL}\n${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:	Use sudo ${0}"	1>&2
	echo -e "\n>>	SCRIPT MUST BE RUN AS ROOT TO MODIFY THE ${ORIGINALFILE}	<<\n"	1>&2
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
