#!/bin/bash
#	create-host-tls	3.1	2017-12-18_20:16:56_CST uthree
#	Adding version number
#
#	set -x
#	set -v
#
#	Create public and private key and CA for host
###		
FQDN=$1
DAY=$2
mkdir -pv ${HOME}/.docker/docker-ca
cd ${HOME}/.docker/docker-ca
if [ -z ${FQDN} ]
then
	echo "Enter fully qualified domain name (FQDN, hostname and domain name) needing new TLS keys (example:`hostname -f`):"
	read FQDN
fi
if [ -z ${DAY} ]
then
	echo "Enter number of days host ${FQDN} needs the TLS keys:"
	read DAY
fi
if [ -a "./.private/ca-priv-key.pem" ]
then
	echo "${0} ${LINENO} [INFO]:	The ${HOME}/.docker/docker-ca/.private/ directory does exist."	1>&2
	rm -f ${FQDN}-priv-key.pem ${FQDN}-cert.pem ${FQDN}.csr
else
	echo -e "${0} ${LINENO} [ERROR]:	Private key not found (${HOME}/.docker/docker-ca/.private/ca-priv-key.pem)"	1>&2
	echo -e "\n>>>  Create or restore the area private key before continuing.  To create a new  <<<"
	echo ">>>       area private key run the script _________ and place the file in directory <<<"
	echo ">>>       noted above.  <<<"
	exit
fi
if [ -n ${FQDN} ]
then
	echo -e "\n${0} ${LINENO} [INFO]:	Creating private key for host ${FQDN}\n"	1>&2
	openssl genrsa -out ${FQDN}-priv-key.pem 2048
	echo -e "\n${0} ${LINENO} [INFO]:	Generate a Certificate Signing Request (CSR) for host ${FQDN}.\n"	1>&2
#	openssl req -sha256 -new -key ${FQDN}-priv-key.pem -subj "/CN=${FQDN}" -out ${FQDN}.csr
	openssl req -sha256 -new -key ${FQDN}-priv-key.pem -subj "/CN=${FQDN}/subjectAltName=${FQDN}" -out ${FQDN}.csr
	echo -e "${0} ${LINENO} [INFO]:	Create and sign a ${DAY} day certificate for host ${FQDN}\n"	1>&2
	openssl x509 -req -days ${DAY} -sha256 -in ${FQDN}.csr -CA ca.pem -CAkey .private/ca-priv-key.pem -CAcreateserial -out ${FQDN}-cert.pem -extensions v3_req -extfile /usr/lib/ssl/openssl.cnf
	openssl rsa -in ${FQDN}-priv-key.pem -out ${FQDN}-priv-key.pem
	echo -e "\n${0} ${LINENO} [INFO]:	Removing certificate signing requests (CSR) and set file permissions for host ${FQDN} key pairs.\n"	1>&2
	rm ${FQDN}.csr
	chmod 0400 ${FQDN}-priv-key.pem
	chmod 0444 ${FQDN}-cert.pem
else
	echo "${0} ${LINENO} [INFO]:	***** This script uses a host name as the first argument and number of days the certificates is valid as the second argument. *****"	1>&2
	exit
fi
echo -e "${0} ${LINENO} [INFO]:	Instructions for setting up the public, private, and certificate files.\n"	1>&2
echo "Login to host ${FQDN} and create a Docker daemon TLS directory.  "
echo "		ssh <user>@${FQDN}"
echo "		sudo mkdir -p /etc/docker/certs.d/daemon"
echo "Change the directory permission for the Docker daemon TLS directory on host ${FQDN} and logout."
echo "		sudo chmod 0700 /etc/docker/certs.d/daemon"
echo "		logout"
echo "Copy the keys from the working directory on host two to /tmp directory on host ${FQDN}."
echo "		scp ./ca.pem <user>@${FQDN}:'/tmp/ca.pem'"
echo "		scp ./${FQDN}-cert.pem <user>@${FQDN}:'/tmp/${FQDN}-cert.pem'"
echo "		scp ./${FQDN}-priv-key.pem <user>@${FQDN}:'/tmp/${FQDN}-priv-key.pem'"
echo "Login to host ${FQDN} and move the key pair files signed by the CA from the /tmp directory to the Docker daemon TLS directory."
echo "		ssh <user>@${FQDN}"
echo "		cd /tmp"
echo "		sudo mv *.pem /etc/docker/certs.d/daemon"
echo "		sudo chown -R root.root /etc/docker/certs.d/daemon"
echo "		sudo -i"
echo "		cd /etc/docker/certs.d/daemon"
echo "		ln -s ${FQDN}-cert.pem cert.pem"
echo "		ln -s ${FQDN}-priv-key.pem key.pem"
echo "		exit"
echo -e "\nAdd the TLS flags to dockerd so dockerd will know you are using TLS. (--tlsverify, --tlscacert, --tlscert, --tlskey)\n"
echo -e "\nThe scripts in https://github.com/BradleyA/docker-scripts/tree/master/dockerd-configuration-options"
echo -e "will help configure dockerd on systems running Ubuntu 16.04 (systemd) and Ubuntu 14.04 (Upstart).\n\n"

echo "For systems running Ubuntu 14.04 (Upstart) you can just follow these steps and not use dockerd-configuration-options scripts."
echo "Modify the Docker daemon startup configuration file on host ${FQDN} and restart Docker."
echo "		sudo vi /etc/default/docker"
echo -e "DOCKER_OPTS=\"\ "
echo "      --graph=/usr/local/docker \ "
echo "      --dns 192.168.1.202 \ "
echo "      --dns 8.8.8.8 \ "
echo "      --dns 8.8.4.4 \ "
echo "      --log-level warn \ "
echo "      --tlsverify \ "
echo "      --tlscacert=/etc/docker/certs.d/daemon/ca.pem \ "
echo "      --tlscert=/etc/docker/certs.d/daemon/${FQDN}-cert.pem \ "
echo "      --tlskey=/etc/docker/certs.d/daemon/${FQDN}-priv-key.pem \ "
echo "      -H=${FQDN}:2376 \ "
echo "      \""
echo -e "\n	sudo service docker restart"
echo -e "	logout"
