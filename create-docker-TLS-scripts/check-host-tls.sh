#!/bin/bash
#	check-host-tls.sh	1.0	2018-01-25_22:17:05_CST uadmin rpi3b-four.cptx86.com
#	initial commit
#
#       set -x
#       set -v
#
#	View public and private key and CA for host
#		
### 
#	system dockerd certification directory
CERTDIR=/etc/docker/certs.d/daemon/
#       Must be root to run this script
if ! [ $(id -u) = 0 ] ; then
        echo "${0} ${LINENO} [ERROR]:   Use sudo ${0}"  1>&2
        echo -e "\n>>   SCRIPT MUST BE RUN AS ROOT <<"     1>&2
        exit 1
fi
#       Check for ${CERTDIR} directory
if [ ! -d ${CERTDIR} ] ; then
        echo -e "${0} ${LINENO} [ERROR]:	${CERTDIR} does not exist"   1>&2
        exit 1
fi
#	View dockerd daemon certificate expiration date of ca.pem file
echo -e "\nView dockerd daemon certificate expiration date of ca.pem file."
openssl x509 -in ${CERTDIR}ca.pem -noout -enddate
#	View dockerd daemon certificate expiration date of cert.pem file
echo -e "\nView dockerd daemon certificate expiration date of cert.pem file"
openssl x509 -in ${CERTDIR}cert.pem -noout -enddate
#	View dockerd daemon certificate issuer data of the ca.pem file
echo -e "\nView dockerd daemon certificate issuer data of the ca.pem file"
openssl x509 -in ${CERTDIR}ca.pem -noout -issuer
#	View dockerd daemon certificate issuer data of the cert.pem file
echo -e "\nView dockerd daemon certificate issuer data of the cert.pem file"
openssl x509 -in ${CERTDIR}cert.pem -noout -issuer
#	Verify that dockerd daemon certificate was issued by the CA.
echo -e "\nVerify that dockerd daemon certificate was issued by the CA."
openssl verify -verbose -CAfile ${CERTDIR}ca.pem ${CERTDIR}cert.pem

