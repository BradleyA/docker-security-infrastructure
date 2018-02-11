#!/bin/bash
#	check-host-tls.sh	3.6.276	2018-02-10_19:26:37_CST uadmin six-rpi3b.cptx86.com 3.6-9-g8424312 
#	docker-scripts/docker-TLS; modify format of display_help; closes #6 
#	check-host-tls.sh	3.5	2018-02-04_09:02:47_CST uadmin six-rpi3b.cptx86.com
#	add note for checking remote host
#	check-host-tls.sh	3.4	2018-02-01_17:18:43_CST uadmin six-rpi3b.cptx86.com
#	added logic for display_help()
#	check-host-tls.sh	1.2	2018-01-28_23:17:45_CST uadmin four-rpi3b.cptx86.com
#	tested files & dir check & correct section permissions
#	check-host-tls.sh	1.0	2018-01-25_22:17:05_CST uadmin rpi3b-four.cptx86.com
#	initial commit
#
#	set -x
#	set -v
#
display_help() {
echo -e "\n${0} - Check public, private keys, and CA for host"
echo    "   UNDER DEVELOPMENT to add REMOTEHOST.  Currently works for local host only."
echo -e "\nUSAGE\n   sudo ${0} "
echo    "   ${0} [--help | -help | help | -h | h | -? | ?]"
echo -e "\nDESCRIPTION\nThis script has to be run as root to check host public, private keys, and CA"
echo    "in /etc/docker/certs.d/daemon directory.  This directory was selected to place"
echo    "dockerd TLS certifications because docker registry stores it's TLS"
echo    "certifications in /etc/docker/certs.d.  The certification files and"
echo    "and directory permissions are also checked."
echo    " >>> This script currently DOES NOT CHECK REMOTE HOSTS.(UNDER DEVELOPMENT) <<<"
echo -e "\nOPTIONS"
echo    "   REMOTEHOST  (UNDER DEVELOPMENT) name of remote host to check for"
echo    "               certifications, no default"
echo -e "   CERTDIR     (UNDER DEVELOPMENT) dockerd certification directory, default"
echo    "               /etc/docker/certs.d/daemon/"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS"
echo -e "\nEXAMPLES\n   Administration user checks local host TLS public, private keys,"
echo -e "   CA, and file and directory permissions.\n\tsudo ${0}\n"
}
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] || [ "$1" == "?" ] ; then
	display_help
	exit 0
fi
### 
#	REMOTEHOST=${1:-`hostname -f`}
REMOTEHOST=`hostname -f`
CERTDIR=${1:-/etc/docker/certs.d/daemon/}
# >>>	REMOTEHOST: check if ${REMOTEHOST} -eq ${HOSTS} if true check for root on local host
# >>>	REMOTEHOST:    if NOT EQUAL because no need for local hosts root  <<<
# >>>	REMOTEHOST:  NOTE: scp & ssh does not work as root 	<<<<<<<<
# >>>	REMOTEHOST:  NOTE: display a message that running this script as root is not required to check remote host,
# >>>	REMOTEHOST:	 host will be required once connected to the remote host
#
#	Must be root to run this script
if ! [ $(id -u) = 0 ] ; then
	display_help
	echo "${0} ${LINENO} [ERROR]:   Use sudo ${0}"	1>&2
	echo -e "\n>>   SCRIPT MUST BE RUN AS ROOT <<"	1>&2
	exit 1
fi
#	Check for ${CERTDIR} directory
if [ ! -d ${CERTDIR} ] ; then
	display_help
	echo -e "${0} ${LINENO} [ERROR]:	${CERTDIR} does not exist"   1>&2
	exit 1
fi
echo -e "${0} ${LINENO} [INFO]:	Checking ${REMOTEHOST} TLS\n\tcertifications and directory permissions."   1>&2
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
#	Verify and correct file permissions for ${CERTDIR}ca.pem
if [ $(stat -Lc %a ${CERTDIR}ca.pem) != 444 ]; then
	echo -e "${0} ${LINENO} [ERROR]:        File permissions for ${CERTDIR}ca.pem\n\tare not 444.  Correcting $(stat -Lc %a ${CERTDIR}ca.pem) to 0444 file permissions" 1>&2
	chmod 0444 ${CERTDIR}ca.pem
fi
#	Verify and correct file permissions for ${CERTDIR}cert.pem
if [ $(stat -Lc %a ${CERTDIR}cert.pem) != 444 ]; then
	echo -e "${0} ${LINENO} [ERROR]:        File permissions for ${CERTDIR}cert.pem\n\tare not 444.  Correcting $(stat -Lc %a ${CERTDIR}cert.pem) to 0444 file permissions"       1>&2
	chmod 0444 ${CERTDIR}cert.pem
fi
#	Verify and correct file permissions for ${CERTDIR}key.pem
if [ $(stat -Lc %a ${CERTDIR}key.pem) != 400 ]; then
	echo -e "${0} ${LINENO} [ERROR]:        File permissions for ${CERTDIR}key.pem\n\tare not 400.  Correcting $(stat -Lc %a ${CERTDIR}key.pem) to 0400 file permissions"        1>&2
	chmod 0400 ${CERTDIR}key.pem
fi
#	Verify and correct directory permissions for ${CERTDIR} directory
if [ $(stat -Lc %a ${CERTDIR}) != 700 ]; then
	echo -e "${0} ${LINENO} [ERROR]:        Directory permissions for ${CERTDIR}\n\tare not 700.  Correcting $(stat -Lc %a ${CERTDIR}) to 700 directory permissions"        1>&2
	chmod 700 ${CERTDIR}
fi
#
#	May want to create a version of this script that automates this process for SRE tools,
#	but keep this script for users to run manually,
#	open ticket and remove this comment
#
