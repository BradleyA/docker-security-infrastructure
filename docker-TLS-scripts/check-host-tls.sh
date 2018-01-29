#!/bin/bash
#	check-host-tls.sh	1.2	2018-01-28_23:17:45_CST uadmin four-rpi3b.cptx86.com
#	tested files & dir check & correct section permissions
#	check-host-tls.sh	1.0	2018-01-25_22:17:05_CST uadmin rpi3b-four.cptx86.com
#	initial commit
#
#       set -x
#       set -v
#
#	Check public, private keys, and CA for host
#
#       This script uses one arguement;
#               CERTDIR - dockerd certification directory, default /etc/docker/certs.d/daemon/
### 
CERTDIR=${1:-/etc/docker/certs.d/daemon/}
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
#       Verify and correct file permissions for ${CERTDIR}ca.pem
if [ $(stat -Lc %a ${CERTDIR}ca.pem) != 444 ]; then
        echo -e "${0} ${LINENO} [ERROR]:        File permissions for ${CERTDIR}ca.pem\n\tare not 444.  Correcting $(stat -Lc %a ${CERTDIR}ca.pem) to 0444 file permissions" 1>&2
        chmod 0444 ${CERTDIR}ca.pem
fi
#       Verify and correct file permissions for ${CERTDIR}cert.pem
if [ $(stat -Lc %a ${CERTDIR}cert.pem) != 444 ]; then
        echo -e "${0} ${LINENO} [ERROR]:        File permissions for ${CERTDIR}cert.pem\n\tare not 444.  Correcting $(stat -Lc %a ${CERTDIR}cert.pem) to 0444 file permissions"       1>&2
        chmod 0444 ${CERTDIR}cert.pem
fi
#       Verify and correct file permissions for ${CERTDIR}key.pem
if [ $(stat -Lc %a ${CERTDIR}key.pem) != 400 ]; then
        echo -e "${0} ${LINENO} [ERROR]:        File permissions for ${CERTDIR}key.pem\n\tare not 400.  Correcting $(stat -Lc %a ${CERTDIR}key.pem) to 0400 file permissions"        1>&2
        chmod 0400 ${CERTDIR}key.pem
fi
#       Verify and correct directory permissions for ${CERTDIR} directory
if [ $(stat -Lc %a ${CERTDIR}) != 700 ]; then
        echo -e "${0} ${LINENO} [ERROR]:        Directory permissions for ${CERTDIR}\n\tare not 700.  Correcting $(stat -Lc %a ${CERTDIR}) to 700 directory permissions"        1>&2
        chmod 700 ${CERTDIR}
fi
#
#       May want to create a version of this script that automates this process for SRE tools,
#               but keep this script for users to run manually,
#
