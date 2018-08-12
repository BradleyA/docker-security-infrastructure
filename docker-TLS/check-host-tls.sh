#!/bin/bash
# 	docker-TLS/check-host-tls.sh  3.42.391  2018-08-12_10:59:20_CDT  https://github.com/BradleyA/docker-scripts  uadmin  three-rpi3b.cptx86.com 3.41-8-g21e9f27  
# 	   sync to standard script design changes 
# 	check-host-tls.sh  3.35.374  2018-08-05_23:21:09_CDT  https://github.com/BradleyA/docker-scripts  uadmin  three-rpi3b.cptx86.com 3.34  
# 	   improve output of script close #13 
###
DEBUG=0                 # 0 = debug off, 1 = debug on
#	set -x
#	set -v
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
display_help() {
echo -e "\n${NORMAL}${0} - Check public, private keys, and CA for host"
echo -e "\nUSAGE\n   sudo ${0} [CERTDIR]"
echo    "   ${0} [--help | -help | help | -h | h | -? | ?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION\nThis script has to be run as root to check public, private keys, and CA in"
echo    "/etc/docker/certs.d/daemon directory.  This directory was selected to place"
echo    "dockerd TLS certifications because docker registry stores it's TLS"
echo    "certifications in /etc/docker/certs.d.  The certification files and"
echo    "directory permissions are also checked."
echo -e "\nThis script works for the local host only.  To test remote hosts try:"
echo    "   ssh -tp 22 uadmin@six-rpi3b.cptx86.com 'sudo check-host-tls.sh'"
echo -e "\nOPTIONS"
echo -e "   CERTDIR     dockerd certification directory, default"
echo    "               /etc/docker/certs.d/daemon/"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS"
echo -e "\nEXAMPLES"
echo    "   sudo ${0}"
echo -e "\n   Administration user checks local host TLS public, private keys,"
echo -e "   CA, and file and directory permissions.\n"
if ! [ "${LANG}" == "en_US.UTF-8" ] ; then
        echo -e "${NORMAL}${0} ${LINENO} [${BOLD}WARNING${NORMAL}]:     Your language, ${LANG}, is not supported.\n\tWould you like to help?\n" 1>&2
fi
}
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] || [ "$1" == "?" ] ; then
	display_help
	exit 0
fi
if [ "$1" == "--version" ] || [ "$1" == "-version" ] || [ "$1" == "version" ] || [ "$1" == "-v" ] ; then
        head -2 ${0} | awk {'print$2"\t"$3'}
        exit 0
fi
### 
CERTDIR=${1:-/etc/docker/certs.d/daemon/}
if [ "${DEBUG}" == "1" ] ; then echo -e "> DEBUG ${LINENO}  CERTDIR >${CERTDIR}<" 1>&2 ; fi
#	Must be root to run this script
if ! [ $(id -u) = 0 ] ; then
	display_help
	echo "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:   Use sudo ${0}"	1>&2
	echo -e "\n>>   ${BOLD}SCRIPT MUST BE RUN AS ROOT${NORMAL} <<"	1>&2
	exit 1
fi
#	Check for ${CERTDIR} directory
if [ ! -d ${CERTDIR} ] ; then
	display_help
	echo -e "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:	${CERTDIR} does not exist"   1>&2
	exit 1
fi
echo -e "${NORMAL}${0} ${LINENO} [${BOLD}INFO${NORMAL}]:   Checking\n\t${BOLD}${REMOTEHOST}${NORMAL}TLS certifications and directory permissions."   1>&2
#	View dockerd daemon certificate expiration date of ca.pem file
TEMP=`openssl x509 -in ${CERTDIR}ca.pem -noout -enddate`
echo -e "\nView dockerd daemon certificate expiration date of ca.pem file:\n\t${BOLD}${TEMP}${NORMAL}"
#	View dockerd daemon certificate expiration date of cert.pem file
TEMP=`openssl x509 -in ${CERTDIR}cert.pem -noout -enddate`
echo -e "\nView dockerd daemon certificate expiration date of cert.pem file:\n\t${BOLD}${TEMP}${NORMAL}"
#	View dockerd daemon certificate issuer data of the ca.pem file
TEMP=`openssl x509 -in ${CERTDIR}ca.pem -noout -issuer`
echo -e "\nView dockerd daemon certificate issuer data of the ca.pem file:\n\t${BOLD}${TEMP}${NORMAL}"
#	View dockerd daemon certificate issuer data of the cert.pem file
TEMP=`openssl x509 -in ${CERTDIR}cert.pem -noout -issuer`
echo -e "\nView dockerd daemon certificate issuer data of the cert.pem file:\n\t${BOLD}${TEMP}${NORMAL}"
#	Verify that dockerd daemon certificate was issued by the CA.
TEMP=`openssl verify -verbose -CAfile ${CERTDIR}ca.pem ${CERTDIR}cert.pem`
echo -e "\nVerify that dockerd daemon certificate was issued by the CA:\n\t${BOLD}${TEMP}${NORMAL}"
#
echo -e "\nVerify and correct file permissions."
#	Verify and correct file permissions for ${CERTDIR}ca.pem
if [ $(stat -Lc %a ${CERTDIR}ca.pem) != 444 ]; then
	echo -e "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:        File permissions for ${CERTDIR}ca.pem\n\tare not 444.  Correcting $(stat -Lc %a ${CERTDIR}ca.pem) to 0444 file permissions" 1>&2
	chmod 0444 ${CERTDIR}ca.pem
fi
#	Verify and correct file permissions for ${CERTDIR}cert.pem
if [ $(stat -Lc %a ${CERTDIR}cert.pem) != 444 ]; then
	echo -e "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:        File permissions for ${CERTDIR}cert.pem\n\tare not 444.  Correcting $(stat -Lc %a ${CERTDIR}cert.pem) to 0444 file permissions"       1>&2
	chmod 0444 ${CERTDIR}cert.pem
fi
#	Verify and correct file permissions for ${CERTDIR}key.pem
if [ $(stat -Lc %a ${CERTDIR}key.pem) != 400 ]; then
	echo -e "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:        File permissions for ${CERTDIR}key.pem\n\tare not 400.  Correcting $(stat -Lc %a ${CERTDIR}key.pem) to 0400 file permissions"        1>&2
	chmod 0400 ${CERTDIR}key.pem
fi
#	Verify and correct directory permissions for ${CERTDIR} directory
if [ $(stat -Lc %a ${CERTDIR}) != 700 ]; then
	echo -e "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:        Directory permissions for ${CERTDIR}\n\tare not 700.  Correcting $(stat -Lc %a ${CERTDIR}) to 700 directory permissions"        1>&2
	chmod 700 ${CERTDIR}
fi
#
echo -e "\nUse script ${BOLD}create-host-tls.sh${NORMAL} to update host TLS if host TLS certificate\n\thas expired."
echo -e "\n${0} ${LINENO} [${BOLD}INFO${NORMAL}]:	Done.\n"	1>&2
#
#	May want to create a version of this script that automates this process for SRE tools,
#	but keep this script for users to run manually,
#	open ticket and remove this comment
###
