#!/bin/bash
#	check-user-tls.sh	1.0	2018-01-25_21:46:22_CST uadmin rpi3b-four.cptx86.com
#	change logic to allow user to check own certs without being root
#
#	set -x
#	set -v
#
#	View public and private key and CA for user
#
###
TLSUSER=$1
#	Where home directories are created. Some sites have different home directories (/u/north-office/<user>)
USERHOME=/home/
#	Check if user is entered as parameter
if ! [ -z ${TLSUSER} ] ; then
#       Root is required to check other users or user can check own certs
	if ! [ $(id -u) = 0 -o ${USER} = ${TLSUSER} ] ; then
        	echo "${0} ${LINENO} [ERROR]:   Use sudo ${0} <TLSUSER>"  1>&2
        	echo -e "\n>>   SCRIPT MUST BE RUN AS ROOT TO CHECK <another-user>/.docker DIRECTORY. <<\n"     1>&2
        	exit 1
	fi
else
	TLSUSER=${USER}
fi
#	Check if user has home directory on system
if [ ! -d ${USERHOME}${TLSUSER} ] ; then 
        echo -e "${0} ${LINENO} [ERROR]:	${TLSUSER} does not have a home directory\n\ton this system or ${TLSUSER} home directory is not ${USERHOME}${TLSUSER}"	1>&2
	exit 1
fi
#	Check if user has .docker directory
if [ ! -d ${USERHOME}${TLSUSER}/.docker ] ; then 
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
echo -e "\nView ${USERHOME}${TLSUSER}/.docker certificate issuer data of the cert.pem file.\n"
openssl x509 -in ${USERHOME}${TLSUSER}/.docker/cert.pem -noout -issuer
#	Verify that user public key in your certificate matches the public portion of your private key.
echo -e "\nVerify that user public key in your certificate matches the public portion of your private key."
(cd ${USERHOME}${TLSUSER}/.docker ; openssl x509 -noout -modulus -in cert.pem | openssl md5 ; openssl rsa -noout -modulus -in key.pem | openssl md5) | uniq
echo -e "If only one line of output is returned then the public key matches the public portion of your private key.\n"
#	Verify that user certificate was issued by the CA.
echo    "Verify that user certificate was issued by the CA."
openssl verify -verbose -CAfile ${USERHOME}${TLSUSER}/.docker/ca.pem ${USERHOME}${TLSUSER}/.docker/cert.pem
#
#	May want to create a verstion of this script that automates this process for SRE,
#		but keep this script for users to run manually,
#		but remove the root requirement from the manual version
#		because users can view their own ~/.docker directory
