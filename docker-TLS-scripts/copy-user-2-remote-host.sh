#!/bin/bash
#	copy-client-remote-host.sh	3.2	2018-01-25_23:23:05_CST uadmin rpi3b-four.cptx86.com
#	changed variable names and added test login, need alot of testing
#	copy-user-remote-host	3.1	2017-12-19_15:32:23_CST utwo two.cptx86.com
#	Adding version number and upload latest
#
#	set -x
#	set -v
#
#	Copy public and private key and CA for user to remote host
#	This script uses two arguements;
#		TLSUSER - user
#		REMOTEHOST - name of host to copy certificates 
# >>>>> This script
#	Documentation: https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS-scripts
###
TLSUSER=$1
REMOTEHOST=$2
#	Working directory to create public and private certificates for clusters at site
WORKTLSDIR= ${HOME}/.docker/docker-ca/
#       Check if certificate directory exists
if [ ! -d ${WORKTLSDIR} ] ; then
        echo -e "${0} ${LINENO} [ERROR]:	${WORKTLSDIR} directory does not exist"   1>&2
        exit 1
fi
cd ${WORKTLSDIR}
#
if [ -z ${TLSUSER} ] ; then
        echo "Enter user name needing new TLS keys:"
        read TLSUSER
fi
# >>>>>	Need to test to determine how to support this for uadmin to admin@remotesystem and uadmin to <otheruser>@remotesystem
#	
#	will require more logic to support all use cases and updated prompts
#	uadmin is the account for site and all clusters
#	may want to see how to support more than one uadmin account in clusters for this script
#	this opens up challenge with different users needing to chown and chgrp for different remote users
#
if [ -z ${REMOTEHOST} ] ; then
        echo "Enter remote host to copy TLS keys:"
        read REMOTEHOST
fi
if [ -a "./.private/ca-priv-key.pem" ] ; then
        echo "${0} ${LINENO} [INFO]:	The ${WORKTLSDIR}.private/ directory found."	1>&2
else
        echo "${0} ${LINENO} [ERROR]:	Private key not found (${WORKTLSDIR}.private/ca-priv-key.pem)"	1>&2
        exit 1
fi
if [ -n ${TLSUSER} ] ; then
	echo -e "\n${0} ${LINENO} [INFO]:	Create directory, change permissions, and\n\tcopy ca.pem TLS key to ${TLSUSER}@${REMOTEHOST}.\n"	1>&2
	ssh ${TLSUSER}@${REMOTEHOST} mkdir -p  ~${TLSUSER}/.docker
	ssh ${TLSUSER}@${REMOTEHOST} chmod 700 ~${TLSUSER}/.docker
	scp -p ca.pem ${TLSUSER}@${REMOTEHOST}:~${TLSUSER}/.docker
	echo -e "\n${0} ${LINENO} [INFO]:	Copy key pair files signed by CA\n\t${REMOTEHOST}:~${TLSUSER}/.docker.\n"	1>&2
	scp -p ${TLSUSER}-user-cert.pem ${TLSUSER}@${REMOTEHOST}:~${TLSUSER}/.docker
	scp -p ${TLSUSER}-user-priv-key.pem ${TLSUSER}@${REMOTEHOST}:~${TLSUSER}/.docker
	echo -e "\n${0} ${LINENO} [INFO]:	Create symbolic links to point to the\n\tdefault Docker TLS file names.\n"	1>&2
	ssh ${TLSUSER}@${REMOTEHOST} ln -s ~${TLSUSER}/.docker/${TLSUSER}-user-cert.pem ~${TLSUSER}/.docker/cert.pem
	ssh ${TLSUSER}@${REMOTEHOST} ln -s ~${TLSUSER}/.docker/${TLSUSER}-user-priv-key.pem ~${TLSUSER}/.docker/key.pem
fi
