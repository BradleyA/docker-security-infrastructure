#!/bin/bash
# 	check-user-tls.sh  3.34.373  2018-08-05_23:18:30_CDT  https://github.com/BradleyA/docker-scripts  uadmin  three-rpi3b.cptx86.com 3.33  
# 	   improve output of script #13 
# 	docker-TLS/check-user-tls.sh  3.32.370  2018-08-05_11:49:59_CDT  https://github.com/BradleyA/docker-scripts  uadmin  three-rpi3b.cptx86.com 3.31-1-g513fe7d  
# 	   re-marking this file with later version of markit to support check-markit 
#
#	set -x
#	set -v
###
DEBUG=0                 # 0 = debug off, 1 = debug on
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
display_help() {
echo -e "\n${0} - Check public, private keys, and CA for a user"
echo -e "\nUSAGE\n   ${0} <user-name> <home-directoty>"
echo    "   ${0} [--help | -help | help | -h | h | -? | ?] [--version | -v]"
echo -e "\nDESCRIPTION\nUsers can check their public, private keys, and CA in /home or other"
echo    "non-default home directories.  The file and directory permissions are also"
echo    "checked.  Administrators can check other users certificates by using"
echo    "sudo ${0} <TLS-user>."
echo -e "\nOPTIONS"
echo    "   TLSUSER   user, default is user running script"
echo    "   USERHOME  location of user home directory, default /home/"
echo    "      Many sites have different home directories locations (/u/north-office/)"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS"
echo -e "\nEXAMPLES\n   User sam can check their certificates\n\t${0}"
echo -e "   User sam checks their certificates in a non-default home directory\n\t${0} sam /u/north-office/"
echo -e "   Administrator checks user bob certificates\n\tsudo ${0} bob"
echo -e "   Administrator checks user sam certificates in a different home directory\n\tsudo ${0} sam /u/north-office/"
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
TLSUSER=${1:-${USER}}
USERHOME=${2:-/home/}
LOCALHOSTNAME=`hostname -f`
#	Root is required to check other users or user can check their own certs
if ! [ $(id -u) = 0 -o ${USER} = ${TLSUSER} ] ; then
	display_help
	echo "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:   Use sudo ${0}  ${TLSUSER}"	1>&2
	echo -e "${BOLD}\n>>   SCRIPT MUST BE RUN AS ROOT TO CHECK <another-user>/.docker DIRECTORY. <<\n${NORMAL}"	1>&2
	exit 1
fi
#	Check if user has home directory on system
if [ ! -d ${USERHOME}${TLSUSER} ] ; then 
	display_help
	echo -e "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:	${TLSUSER} does not have a home directory\n\ton this system or ${TLSUSER} home directory is not ${USERHOME}${TLSUSER}"	1>&2
	exit 1
fi
#	Check if user has .docker directory
if [ ! -d ${USERHOME}${TLSUSER}/.docker ] ; then 
	display_help
	echo -e "${NORMAL}\n${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:	${TLSUSER} does not have a .docker directory"	1>&2
	exit 1
fi
#	Check if user has .docker ca.pem file
if [ ! -e ${USERHOME}${TLSUSER}/.docker/ca.pem ] ; then 
	echo -e "${NORMAL}\n${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:	${TLSUSER} does not have a .docker/ca.pem file"	1>&2
	exit 1
fi
#	Check if user has .docker cert.pem file
if [ ! -e ${USERHOME}${TLSUSER}/.docker/cert.pem ] ; then 
	echo -e "${NORMAL}\n${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:	${TLSUSER} does not have a .docker/cert.pem file"	1>&2
	exit 1
fi
#	Check if user has .docker key.pem file
if [ ! -e ${USERHOME}${TLSUSER}/.docker/key.pem ] ; then 
	echo -e "${NORMAL}\n${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:	${TLSUSER} does not have a .docker/key.pem file"	1>&2
	exit 1
fi
#	View user certificate expiration date of ca.pem file
TEMP=`openssl x509 -in  ${USERHOME}${TLSUSER}/.docker/ca.pem -noout -enddate`
echo -e "\n${NORMAL}View ${USERHOME}${TLSUSER}/.docker certificate ${BOLD}expiration date of ca.pem ${NORMAL}file:\n\t${BOLD}${TEMP}${NORMAL}"
#	View user certificate expiration date of cert.pem file
TEMP=`openssl x509 -in ${USERHOME}${TLSUSER}/.docker/cert.pem -noout -enddate`
echo -e "\nView ${USERHOME}${TLSUSER}/.docker certificate ${BOLD}expiration date of cert.pem ${NORMAL}file:\n\t${BOLD}${TEMP}${NORMAL}"
#	View user certificate issuer data of the ca.pem file.
TEMP=`openssl x509 -in ${USERHOME}${TLSUSER}/.docker/ca.pem -noout -issuer`
echo -e "\nView ${USERHOME}${TLSUSER}/.docker certificate ${BOLD}issuer data of the ca.pem ${NORMAL}file:\n\t${BOLD}${TEMP}${NORMAL}"
#	View user certificate issuer data of the cert.pem file.
TEMP=`openssl x509 -in ${USERHOME}${TLSUSER}/.docker/cert.pem -noout -issuer`
echo -e "\nView ${USERHOME}${TLSUSER}/.docker certificate ${BOLD}issuer data of the cert.pem ${NORMAL}file:\n\t${BOLD}${TEMP}${NORMAL}"
#	Verify that user public key in your certificate matches the public portion of your private key.
echo -e "\nVerify that user public key in your certificate matches the public portion\n\tof your private key."
(cd ${USERHOME}${TLSUSER}/.docker ; openssl x509 -noout -modulus -in cert.pem | openssl md5 ; openssl rsa -noout -modulus -in key.pem | openssl md5) | uniq
echo -e "${BOLD}WARNING:${NORMAL}  -> If ONLY ONE line of output is returned then the public key\n\tmatches the public portion of your private key.\n"
#	Verify that user certificate was issued by the CA.
echo -e "Verify that user certificate was issued by the CA:${BOLD}"
openssl verify -verbose -CAfile ${USERHOME}${TLSUSER}/.docker/ca.pem ${USERHOME}${TLSUSER}/.docker/cert.pem  || { echo -e "${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:	User certificate for ${TLSUSER} on ${LOCALHOSTNAME} was NOT issued by CA." ; exit 1; }
#	Verify and correct file permissions for ${USERHOME}${TLSUSER}/.docker/ca.pem
echo -e "\n${NORMAL}Verify and correct file permissions for ${USERHOME}${TLSUSER}/.docker"
if [ $(stat -Lc %a ${USERHOME}${TLSUSER}/.docker/ca.pem) != 444 ]; then
	echo -e "${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:	File permissions for ${USERHOME}${TLSUSER}/.docker/ca.pem\n\tare not 444.  Correcting $(stat -Lc %a ${USERHOME}${TLSUSER}/.docker/ca.pem) to 0444 file permissions"	1>&2
	chmod 0444 ${USERHOME}${TLSUSER}/.docker/ca.pem
fi
#	Verify and correct file permissions for ${USERHOME}${TLSUSER}/.docker/cert.pem
if [ $(stat -Lc %a ${USERHOME}${TLSUSER}/.docker/cert.pem) != 444 ]; then
	echo -e "${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:	File permissions for ${USERHOME}${TLSUSER}/.docker/cert.pem\n\tare not 444.  Correcting $(stat -Lc %a ${USERHOME}${TLSUSER}/.docker/cert.pem) to 0444 file permissions"	1>&2
	chmod 0444 ${USERHOME}${TLSUSER}/.docker/cert.pem
fi
#	Verify and correct file permissions for ${USERHOME}${TLSUSER}/.docker/key.pem
if [ $(stat -Lc %a ${USERHOME}${TLSUSER}/.docker/key.pem) != 400 ]; then
	echo -e "${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:	File permissions for ${USERHOME}${TLSUSER}/.docker/key.pem\n\tare not 400.  Correcting $(stat -Lc %a ${USERHOME}${TLSUSER}/.docker/key.pem) to 0400 file permissions"	1>&2
	chmod 0400 ${USERHOME}${TLSUSER}/.docker/key.pem
fi
#	Verify and correct directory permissions for ${USERHOME}${TLSUSER}/.docker directory
if [ $(stat -Lc %a ${USERHOME}${TLSUSER}/.docker) != 700 ]; then
	echo -e "${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:	Directory permissions for ${USERHOME}${TLSUSER}/.docker\n\tare not 700.  Correcting $(stat -Lc %a ${USERHOME}${TLSUSER}/.docker) to 700 directory permissions"	1>&2
	chmod 700 ${USERHOME}${TLSUSER}/.docker
fi
#
echo -e "\nUse script ${BOLD}create-user-tls.sh${NORMAL} to update user TLS if user TLS certificate\n\thas expired."
echo -e "\n${0} ${LINENO} [${BOLD}INFO${NORMAL}]:	Done.\n"	1>&2
#
#	May want to create a version of this script that automates this process for SRE tools,
#		but keep this script for users to run manually,
#	open ticket and remove this comment
###
