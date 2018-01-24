#!/bin/bash
#	copy-client-remote-host	3.1	2017-12-19_15:32:23_CST utwo two.cptx86.com
#	Adding version number and upload latest
#
#       set -x
#       set -v
#
#       Copy public and private key and CA for client to remote host
###               
CLIENT=$1
REMOTEHOST=$2
cd ${HOME}/.docker/docker-ca
if [ -z ${CLIENT} ]
then
        echo "Enter user name needing new TLS keys:"
        read CLIENT
fi
if [ -z ${REMOTEHOST} ]
then
        echo "Enter remote host to copy TLS keys:"
        read REMOTEHOST
fi
if [ -a "./.private/ca-priv-key.pem" ]
then
        echo "${0} ${LINENO} [INFO]:	The ${HOME}/.docker/docker-ca/.private/ directory found."	1>&2
else
        echo "${0} ${LINENO} [ERROR]:	Private key not found (${HOME}/.docker/docker-ca/.private/ca-priv-key.pem)"	1>&2
        exit
fi
if [ -n ${CLIENT} ]
then
	echo -e "\n${0} ${LINENO} [INFO]:	Create directory, change permissions, and\n\tcopy ca.pem TLS Key to ${CLIENT}@${REMOTEHOST}.\n"	1>&2
	ssh ${CLIENT}@${REMOTEHOST} mkdir -pv ~${CLIENT}/.docker
	ssh ${CLIENT}@${REMOTEHOST} chmod -v 700 ~${CLIENT}/.docker
	scp -p ca.pem ${CLIENT}@${REMOTEHOST}:~${CLIENT}/.docker
	echo -e "\n${0} ${LINENO} [INFO]:	Copy the key pair files signed by the CA\n\t${REMOTEHOST}:~${CLIENT}/.docker.\n"	1>&2
	scp -p ${CLIENT}-client-cert.pem ${CLIENT}@${REMOTEHOST}:~${CLIENT}/.docker
	scp -p ${CLIENT}-client-priv-key.pem ${CLIENT}@${REMOTEHOST}:~${CLIENT}/.docker
	echo -e "\n${0} ${LINENO} [INFO]:	Create symbolic links to point to the\n\tdefault Docker TLS file names.\n"	1>&2
	ssh ${CLIENT}@${REMOTEHOST} ln -vs ~${CLIENT}/.docker/${CLIENT}-client-cert.pem ~${CLIENT}/.docker/cert.pem
	ssh ${CLIENT}@${REMOTEHOST} ln -vs ~${CLIENT}/.docker/${CLIENT}-client-priv-key.pem ~${CLIENT}/.docker/key.pem
fi
