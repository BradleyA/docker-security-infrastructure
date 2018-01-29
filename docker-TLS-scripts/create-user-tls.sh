#!/bin/bash
#	create-user-tls	3.1	2017-12-19_15:19:59_CST uadmin rpi3b-two.cptx86.com
#	Adding version number and upload latest
#
#	set -x
#	set -v
#
#	Create public and private key and CA for user
#       This script uses two arguements;
#               TLSUSER - user
#               DAY - number of days user keys & CA are valid
#       This script creates public, private keys and CA for user.
#       Documentation: https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS-scripts
###		
TLSUSER=$1
DAY=$2
cd ${HOME}/.docker/docker-ca
if [ -z ${TLSUSER} ]
then
	echo "Enter user name needing new TLS keys:"
	read TLSUSER
fi
if [ -z ${DAY} ]
then
	echo "Enter number of days user ${TLSUSER} needs the TLS keys:"
	read DAY
fi
if [ -a "./.private/ca-priv-key.pem" ]
then
	echo "${0} ${LINENO} [INFO]:	The ${HOME}/.docker/docker-ca/.private/ directory does exist."	1>&2
else
	echo "${0} ${LINENO} [ERROR]:	Private key not found (${HOME}/.docker/docker-ca/.private/ca-priv-key.pem)"	1>&2
	exit
fi
if [ -n ${TLSUSER} ]
then
	echo -e "\n${0} ${LINENO} [INFO]:	Creating private key for user ${TLSUSER}.\n"	1>&2
	openssl genrsa -out ${TLSUSER}-user-priv-key.pem 2048

	echo -e "\n${0} ${LINENO} [INFO]:	Generate a Certificate Signing Request (CSR) for user ${TLSUSER}.\n"	1>&2
	openssl req -subj '/subjectAltName=client' -new -key ${TLSUSER}-user-priv-key.pem -out ${TLSUSER}-user.csr

	echo -e "${0} ${LINENO} [INFO]:	Create and sign a ${DAY} day certificate for user ${TLSUSER}.\n"	1>&2
	openssl x509 -req -days ${DAY} -sha256 -in ${TLSUSER}-user.csr -CA ca.pem -CAkey .private/ca-priv-key.pem -CAcreateserial -out ${TLSUSER}-user-cert.pem

	echo -e "\n${0} ${LINENO} [INFO]:	Removing certificate signing requests (CSR) and set file permissions for ${TLSUSER} key pairs.\n"	1>&2
	rm ${TLSUSER}-user.csr
	chmod 0400 ${TLSUSER}-user-priv-key.pem
	chmod 0444 ${TLSUSER}-user-cert.pem
else
	echo -e "${0} ${LINENO} [INFO]:***** This script requires a user name as the first\n\targument and number of days the certificates is valid as the second argument. *****"	1>&2
	exit
fi
echo -e "${0} ${LINENO} [INFO]:	The following are instructions for setting up the public, private, and certificate files for ${TLSUSER}.\n"	1>&2
echo "Copy the CA's public key (also called certificate) from the working directory to ~${TLSUSER}/.docker."
echo "	sudo mkdir -pv ~${TLSUSER}/.docker"
echo "	sudo chmod 700 ~${TLSUSER}/.docker"
echo "	sudo cp -pv ca.pem ~${TLSUSER}/.docker"
echo "		or if copying to remove host, five, and to user ${TLSUSER}"
echo "		ssh ${TLSUSER}@five.cptx86.com mkdir -pv ~${CLIENT}/.docker"
echo "		ssh ${CLIENT}@five.cptx86.com chmod 700 ~${CLIENT}/.docker"
echo "		scp -p ca.pem ${CLIENT}@five.cptx86.com:~${CLIENT}/.docker"
echo -e "\nCopy the key pair files signed by the CA from the working directory to ~${CLIENT}/.docker."
echo "	sudo cp -pv ${CLIENT}-user-cert.pem ~${CLIENT}/.docker"
echo "	sudo cp -pv ${CLIENT}-user-priv-key.pem ~${CLIENT}/.docker"
echo "		or if copying to remove host, five, and for user ${CLIENT}"
echo "		scp -p ${CLIENT}-user-cert.pem ${CLIENT}@five.cptx86.com:~${CLIENT}/.docker"
echo "		scp -p ${CLIENT}-user-priv-key.pem ${CLIENT}@five.cptx86.com:~${CLIENT}/.docker"
echo -e "\nCreate symbolic links to point to the default Docker TLS file names."
echo "	sudo ln -s ~${CLIENT}/.docker/${CLIENT}-user-cert.pem ~${CLIENT}/.docker/cert.pem"
echo "	sudo ln -s ~${CLIENT}/.docker/${CLIENT}-user-priv-key.pem ~${CLIENT}/.docker/key.pem"
echo "	sudo chown -R ${CLIENT}:${CLIENT} ~${CLIENT}/.docker"
echo "		or if remove host, five, and for user ${CLIENT}"
echo "		ssh ${CLIENT}@five.cptx86.com ln -s ~${CLIENT}/.docker/${CLIENT}-user-cert.pem ~${CLIENT}/.docker/cert.pem"
echo "		ssh ${CLIENT}@five.cptx86.com ln -s ~${CLIENT}/.docker/${CLIENT}-user-priv-key.pem ~${CLIENT}/.docker/key.pem"
echo -e "\nIn bash you can set environment variables permanently by adding them to the user's .bashrc.  These"
echo "environment variables will be set each time the user logs into the test computer system.  Edit your .bashrc"
echo "file (or the correct shell if different) and append the following two lines."
echo "	vi  ${CLIENT}/.bashrc"
echo -e "\nexport DOCKER_HOST=tcp://`hostname -f`:2376"
echo    "export DOCKER_TLS_VERIFY=1"
