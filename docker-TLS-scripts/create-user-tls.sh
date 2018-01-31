#!/bin/bash
#	create-user-tls.sh	3.3	2018-01-31_09:09:37_CST uadmin six-rpi3b.cptx86.com
#	Improve user feed back messages
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
	echo -e "\t${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private,\n\tnot on system."  1>&2
	echo    "\tRunning create-site-private-public-tls.sh will create directories"
	echo    "\tand site private and public keys.  Then run sudo"
	echo    "\tcreate-new-openssl.cnf-tls.sh to modify openssl.cnf file.  Then run"
	echo    "\tcreate-host-tls.sh or create-user-tls.sh as many times as you want."
	exit 1
fi
#
cd ${USERHOME}${ADMTLSUSER}/.docker/docker-ca
#	Check if ca-priv-key.pem file on system
if ! [ -e ${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem ] ; then
	echo -e "${0} ${LINENO} [ERROR]:        Site private key\n\t${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/ca-priv-key.pem\n\tis not in this location."   1>&2
	echo -e "\tEither move it from your site secure location to"
	echo -e "\t${USERHOME}${ADMTLSUSER}/.docker/docker-ca/.private/"
	echo -e "\tOr run create-site-private-public-tls.sh and sudo"
	echo -e "\tcreate-new-openssl.cnf-tls.sh to create a new one."
	exit 1
fi
#	Check if ${TLSUSER}-user-priv-key.pem file on system
if [ -e ${TLSUSER}-user-priv-key.pem ] ; then
	echo -e "${0} ${LINENO} [ERROR]:	${TLSUSER}-user-priv-key.pem already exists,\n\trenaming existing keys so new keys can be created."   1>&2
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
openssl x509 -req -days ${NUMBERDAYS} -sha256 -in ${TLSUSER}-user.csr -CA ca.pem -CAkey .private/ca-priv-key.pem -CAcreateserial -out ${TLSUSER}-user-cert.pem || { echo "${0} ${LINENO} [ERROR]:	Wrong pass phrase for .private/ca-priv-key.pem: " ; exit 1; }
#	Removing certificate signing requests (CSR)
echo -e "\n${0} ${LINENO} [INFO]:	Removing certificate signing requests (CSR) and set file permissions for ${TLSUSER} key pairs.\n"	1>&2
#
rm ${TLSUSER}-user.csr
chmod 0400 ${TLSUSER}-user-priv-key.pem
chmod 0444 ${TLSUSER}-user-cert.pem
#
echo -e "${0} ${LINENO} [INFO]:	Instructions for setting up\n\tpublic, private, and certificate files for ${TLSUSER}.\n"	1>&2
echo    "Copy CA's public key from working directory to ~${TLSUSER}/.docker."
echo    "	sudo mkdir -p  ~${TLSUSER}/.docker"
echo    "	sudo chmod 700 ~${TLSUSER}/.docker"
echo    "	sudo cp -p ca.pem ~${TLSUSER}/.docker"
echo    "	   or if copying to remove host (two.cptx86.com)"
echo    "		ssh ${ADMTLSUSER}@two.cptx86.com sudo mkdir -p  ~${TLSUSER}/.docker"
echo    "		ssh ${ADMTLSUSER}@two.cptx86.com sudo chmod 700 ~${TLSUSER}/.docker"
# >>>>>	TEst if this next line will even works without being root
echo    "		scp -p ca.pem ${ADMTLSUSER}@two.cptx86.com:~${TLSUSER}/.docker"
echo -e "\nCopy key pair files from working directory to ~${TLSUSER}/.docker."
echo    "	sudo cp -p ${TLSUSER}-user-cert.pem ~${TLSUSER}/.docker"
echo    "	sudo cp -p ${TLSUSER}-user-priv-key.pem ~${TLSUSER}/.docker"
echo    "	   or if copying to remove host (two.cptx86.com)"
echo    "		scp -p ${TLSUSER}-user-cert.pem ${ADMTLSUSER}@two.cptx86.com:~${TLSUSER}/.docker"
echo    "		scp -p ${TLSUSER}-user-priv-key.pem ${ADMTLSUSER}@two.cptx86.com:~${TLSUSER}/.docker"
echo -e "\nCreate symbolic links to point to default Docker TLS file names."
echo    "	sudo ln -s ~${TLSUSER}/.docker/${TLSUSER}-user-cert.pem ~${TLSUSER}/.docker/cert.pem"
echo    "	sudo ln -s ~${TLSUSER}/.docker/${TLSUSER}-user-priv-key.pem ~${TLSUSER}/.docker/key.pem"
echo    "	sudo chown -R ${TLSUSER}:${TLSUSER} ~${TLSUSER}/.docker"
echo    "	   or if remove host, two, and for user ${TLSUSER}"
echo    "		ssh ${TLSUSER}@two.cptx86.com sudo ln -s ~${TLSUSER}/.docker/${TLSUSER}-user-cert.pem ~${TLSUSER}/.docker/cert.pem"
echo    "		ssh ${TLSUSER}@two.cptx86.com sudo ln -s ~${TLSUSER}/.docker/${TLSUSER}-user-priv-key.pem ~${TLSUSER}/.docker/key.pem"
echo    "		ssh ${TLSUSER}@two.cptx86.com sudo chown -R ${TLSUSER}:${TLSUSER} ~${TLSUSER}/.docker"
echo -e "\nTo set environment variables permanently, add them to the user's"
echo    "\t.bashrc.  These environment variables will be set each time the user"
echo    "\tlogs into the computer system.  Edit your .bashrc file (or the"
echo    "\tcorrect shell if different) and append the following two lines."
echo    "\t	vi  ${TLSUSER}/.bashrc"
echo    "\texport DOCKER_HOST=tcp://`hostname -f`:2376"
echo    "\texport DOCKER_TLS_VERIFY=1"
###
