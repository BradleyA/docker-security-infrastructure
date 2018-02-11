#!/bin/bash
#	check-user-tls.sh	3.6.266	2018-02-10_18:54:43_CST uadmin six-rpi3b.cptx86.com v0.1-260-g2013df8 
#	docker-scripts/docker-TLS; modify format of display_help; closes #6 
#	check-user-tls.sh	3.4	2018-02-01_18:57:23_CST uadmin six-rpi3b.cptx86.com
#	added logic for display_help()
#	./check-user-tls.sh	1.2	2018-01-28_22:51:08_CST uadmin four-rpi3b.cptx86.com
#	tested files & dir check & correct section permissions
#	check-user-tls.sh	1.1	2018-01-28_15:25:06_CST uadmin four-rpi3b.cptx86.com
#	add section to check file permissions and correct if not correct ${USERHOME}${TLSUSER}/.docker
#	check-user-tls.sh	1.0	2018-01-25_21:46:22_CST uadmin rpi3b-four.cptx86.com
#	change logic to allow user to check own certs without being root
#
#	set -x
#	set -v
#
display_help() {
echo -e "\n${0} - Check public, private keys, and CA for a user"
echo -e "\nUSAGE\n   ${0} <user-name> <home-directoty>"
echo    "   ${0} [--help | -help | help | -h | h | -? | ?]"
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
###
TLSUSER=${1:-${USER}}
USERHOME=${2:-/home/}
#	Root is required to check other users or user can check own certs
if ! [ $(id -u) = 0 -o ${USER} = ${TLSUSER} ] ; then
	display_help
	echo "${0} ${LINENO} [ERROR]:   Use sudo ${0}  ${TLSUSER}"	1>&2
	echo -e "\n>>   SCRIPT MUST BE RUN AS ROOT TO CHECK <another-user>/.docker DIRECTORY. <<\n"	1>&2
	exit 1
fi
#	Check if user has home directory on system
if [ ! -d ${USERHOME}${TLSUSER} ] ; then 
	display_help
	echo -e "${0} ${LINENO} [ERROR]:	${TLSUSER} does not have a home directory\n\ton this system or ${TLSUSER} home directory is not ${USERHOME}${TLSUSER}"	1>&2
	exit 1
fi
#	Check if user has .docker directory
if [ ! -d ${USERHOME}${TLSUSER}/.docker ] ; then 
	display_help
	echo -e "${0} ${LINENO} [ERROR]:	${TLSUSER} does not have a .docker directory"	1>&2
	exit 1
fi
#	View user certificate expiration date of ca.pem file
echo -e "\nView ${USERHOME}${TLSUSER}/.docker certificate expiration date of ca.pem file."
openssl x509 -in  ${USERHOME}${TLSUSER}/.docker/ca.pem -noout -enddate
#	View user certificate expiration date of cert.pem file
echo -e "\nView ${USERHOME}${TLSUSER}/.docker certificate expiration date of cert.pem file"
openssl x509 -in ${USERHOME}${TLSUSER}/.docker/cert.pem -noout -enddate
#	View user certificate issuer data of the ca.pem file.
echo -e "\nView ${USERHOME}${TLSUSER}/.docker certificate issuer data of the ca.pem file."
openssl x509 -in ${USERHOME}${TLSUSER}/.docker/ca.pem -noout -issuer
#	View user certificate issuer data of the cert.pem file.
echo -e "\nView ${USERHOME}${TLSUSER}/.docker certificate issuer data of the cert.pem file."
openssl x509 -in ${USERHOME}${TLSUSER}/.docker/cert.pem -noout -issuer
#	Verify that user public key in your certificate matches the public portion of your private key.
echo -e "\nVerify that user public key in your certificate matches the public portion of your private key."
(cd ${USERHOME}${TLSUSER}/.docker ; openssl x509 -noout -modulus -in cert.pem | openssl md5 ; openssl rsa -noout -modulus -in key.pem | openssl md5) | uniq
echo -e "If only one line of output is returned then the public key matches the public portion of your private key.\n"
#	Verify that user certificate was issued by the CA.
echo    "Verify that user certificate was issued by the CA."
openssl verify -verbose -CAfile ${USERHOME}${TLSUSER}/.docker/ca.pem ${USERHOME}${TLSUSER}/.docker/cert.pem
#	Verify and correct file permissions for ${USERHOME}${TLSUSER}/.docker/ca.pem
if [ $(stat -Lc %a ${USERHOME}${TLSUSER}/.docker/ca.pem) != 444 ]; then
	echo -e "${0} ${LINENO} [ERROR]:	File permissions for ${USERHOME}${TLSUSER}/.docker/ca.pem\n\tare not 444.  Correcting $(stat -Lc %a ${USERHOME}${TLSUSER}/.docker/ca.pem) to 0444 file permissions"	1>&2
	chmod 0444 ${USERHOME}${TLSUSER}/.docker/ca.pem
fi
#	Verify and correct file permissions for ${USERHOME}${TLSUSER}/.docker/cert.pem
if [ $(stat -Lc %a ${USERHOME}${TLSUSER}/.docker/cert.pem) != 444 ]; then
	echo -e "${0} ${LINENO} [ERROR]:	File permissions for ${USERHOME}${TLSUSER}/.docker/cert.pem\n\tare not 444.  Correcting $(stat -Lc %a ${USERHOME}${TLSUSER}/.docker/cert.pem) to 0444 file permissions"	1>&2
	chmod 0444 ${USERHOME}${TLSUSER}/.docker/cert.pem
fi
#	Verify and correct file permissions for ${USERHOME}${TLSUSER}/.docker/key.pem
if [ $(stat -Lc %a ${USERHOME}${TLSUSER}/.docker/key.pem) != 400 ]; then
	echo -e "${0} ${LINENO} [ERROR]:	File permissions for ${USERHOME}${TLSUSER}/.docker/key.pem\n\tare not 400.  Correcting $(stat -Lc %a ${USERHOME}${TLSUSER}/.docker/key.pem) to 0400 file permissions"	1>&2
	chmod 0400 ${USERHOME}${TLSUSER}/.docker/key.pem
fi
#	Verify and correct directory permissions for ${USERHOME}${TLSUSER}/.docker directory
if [ $(stat -Lc %a ${USERHOME}${TLSUSER}/.docker) != 700 ]; then
	echo -e "${0} ${LINENO} [ERROR]:	Directory permissions for ${USERHOME}${TLSUSER}/.docker\n\tare not 700.  Correcting $(stat -Lc %a ${USERHOME}${TLSUSER}/.docker) to 700 directory permissions"	1>&2
	chmod 700 ${USERHOME}${TLSUSER}/.docker
fi
#
#	May want to create a version of this script that automates this process for SRE tools,
#		but keep this script for users to run manually,
#	open ticket and remove this comment
###
