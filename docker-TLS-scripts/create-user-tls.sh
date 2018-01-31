#!/bin/bash
#	create-user-tls.sh	3.2	2018-01-30_19:15:34_CST uadmin six-rpi3b.cptx86.com
#	during testing added more checks for files and directories
#	create-user-tls	3.1	2017-12-19_15:19:59_CST uadmin rpi3b-two.cptx86.com
#	Adding version number and upload latest
#
#	set -x
#	set -v
#
#	Create public and private key and CA for user
#       This script uses four arguements;
#		TLSUSER - user requiring new TLS keys, default is user running script
#               NUMBERDAYS - number of days user keys are valid, default 90 days
#		USERHOME - location of admin user directory, default is /home/
#                  Many sites have different home directories (/u/north-office/<user>)
#               ADMTLSUSER - administration user creating TLS accounts, default is user running script
#       This script creates public, private keys and CA for user.
#       Documentation: https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS-scripts
###		
TLSUSER=${1:-${USER}}
NUMBERDAYS=${2:-90}
USERHOME=${3:-/home/}
ADMTLSUSER=${4:-${USER}}
#
# >>>>>	Add systax --help -? -h -help for scripts
#
#	Check if admin user has home directory on system
if [ ! -d ${USERHOME}${ADMTLSUSER} ] ; then
        echo -e "${0} ${LINENO} [ERROR]:        ${ADMTLSUSER} does not have a home directory\n\ton this system or ${ADMTLSUSER} home directory is not ${USERHOME}${ADMTLSUSER}"  1>&2
        exit 1
fi
#	Check if site CA directory on system
if [ ! -d ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private ] ; then
        echo -e "${0} ${LINENO} [ERROR]:        default directory,"	1>&2
	echo    "${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private, not on system."  1>&2
        exit 1
fi
#
cd ${USERHOME}${ADMTLSUSER}/.docker/docker-ca
#       Check if ca-priv-key.pem file exists
if ! [ -e ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem ] ; then
        echo -e "${0} ${LINENO} [ERROR]:        Site private key\n\t${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem is missing."   1>&2
        exit 1
fi
#       Check if ${TLSUSER}-user-priv-key.pem file exists
if [ -e ${TLSUSER}-user-priv-key.pem ] ; then
        echo -e "${0} ${LINENO} [ERROR]:	${TLSUSER}-user-priv-key.pem already exists, renaming existing keys"   1>&2
        mv ${TLSUSER}-user-priv-key.pem ${TLSUSER}-user-priv-key.pem`date +%Y-%m-%d_%H:%M:%S_%Z`
        mv ${TLSUSER}-user-cert.pem ${TLSUSER}-user-cert.pem`date +%Y-%m-%d_%H:%M:%S_%Z`
fi
#	Creating private key for user ${TLSUSER}
echo -e "\n${0} ${LINENO} [INFO]:	Creating private key for user ${TLSUSER}.\n"	1>&2
openssl genrsa -out ${TLSUSER}-user-priv-key.pem 2048
#	Generate a Certificate Signing Request (CSR)
echo -e "\n${0} ${LINENO} [INFO]:	Generate a Certificate Signing Request (CSR) for user ${TLSUSER}.\n"	1>&2
openssl req -subj '/subjectAltName=client' -new -key ${TLSUSER}-user-priv-key.pem -out ${TLSUSER}-user.csr
#	Create and sign a ${NUMBERDAYS} day certificate
echo -e "${0} ${LINENO} [INFO]:	Create and sign a ${NUMBERDAYS} day certificate for user ${TLSUSER}.\n"	1>&2
openssl x509 -req -days ${NUMBERDAYS} -sha256 -in ${TLSUSER}-user.csr -CA ca.pem -CAkey .private/ca-priv-key.pem -CAcreateserial -out ${TLSUSER}-user-cert.pem || { echo '${0} ${LINENO} [ERROR]:	Wrong pass phrase for .private/ca-priv-key.pem: ' ; exit 1; }
#	Removing certificate signing requests (CSR)
echo -e "\n${0} ${LINENO} [INFO]:	Removing certificate signing requests (CSR) and set file permissions for ${TLSUSER} key pairs.\n"	1>&2
#
rm ${TLSUSER}-user.csr
chmod 0400 ${TLSUSER}-user-priv-key.pem
chmod 0444 ${TLSUSER}-user-cert.pem
#
echo -e "${0} ${LINENO} [INFO]:	The following are instructions for setting up the public, private, and certificate files for ${TLSUSER}.\n"	1>&2
echo "Copy the CA's public key (also called certificate) from the working directory to ~${TLSUSER}/.docker."
echo "	sudo mkdir -pv ~${TLSUSER}/.docker"
echo "	sudo chmod 700 ~${TLSUSER}/.docker"
echo "	sudo cp -pv ca.pem ~${TLSUSER}/.docker"
echo "		or if copying to remove host, five, and to user ${TLSUSER}"
echo "		ssh ${TLSUSER}@five.cptx86.com mkdir -pv ~${TLSUSER}/.docker"
echo "		ssh ${TLSUSER}@five.cptx86.com chmod 700 ~${TLSUSER}/.docker"
echo "		scp -p ca.pem ${TLSUSER}@five.cptx86.com:~${TLSUSER}/.docker"
echo -e "\nCopy the key pair files signed by the CA from the working directory to ~${TLSUSER}/.docker."
echo "	sudo cp -pv ${TLSUSER}-user-cert.pem ~${TLSUSER}/.docker"
echo "	sudo cp -pv ${TLSUSER}-user-priv-key.pem ~${TLSUSER}/.docker"
echo "		or if copying to remove host, five, and for user ${TLSUSER}"
echo "		scp -p ${TLSUSER}-user-cert.pem ${TLSUSER}@five.cptx86.com:~${TLSUSER}/.docker"
echo "		scp -p ${TLSUSER}-user-priv-key.pem ${TLSUSER}@five.cptx86.com:~${TLSUSER}/.docker"
echo -e "\nCreate symbolic links to point to the default Docker TLS file names."
echo "	sudo ln -s ~${TLSUSER}/.docker/${TLSUSER}-user-cert.pem ~${TLSUSER}/.docker/cert.pem"
echo "	sudo ln -s ~${TLSUSER}/.docker/${TLSUSER}-user-priv-key.pem ~${TLSUSER}/.docker/key.pem"
echo "	sudo chown -R ${TLSUSER}:${TLSUSER} ~${TLSUSER}/.docker"
echo "		or if remove host, five, and for user ${TLSUSER}"
echo "		ssh ${TLSUSER}@five.cptx86.com ln -s ~${TLSUSER}/.docker/${TLSUSER}-user-cert.pem ~${TLSUSER}/.docker/cert.pem"
echo "		ssh ${TLSUSER}@five.cptx86.com ln -s ~${TLSUSER}/.docker/${TLSUSER}-user-priv-key.pem ~${TLSUSER}/.docker/key.pem"
echo -e "\nIn bash you can set environment variables permanently by adding them to the user's .bashrc.  These"
echo "environment variables will be set each time the user logs into the test computer system.  Edit your .bashrc"
echo "file (or the correct shell if different) and append the following two lines."
echo "	vi  ${TLSUSER}/.bashrc"
echo -e "\nexport DOCKER_HOST=tcp://`hostname -f`:2376"
echo    "export DOCKER_TLS_VERIFY=1"
###
