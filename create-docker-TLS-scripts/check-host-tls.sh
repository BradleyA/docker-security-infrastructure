#!/bin/bash
#	check-host-tls.sh	1.1	2018-01-25_08:37:40_CST uadmin rpi3b-four.cptx86.com
#	initial commit
#
#       set -x
#       set -v
#
#	View public and private key and CA for host
#		
### 
echo "need to write a script to check host certs"
exit


BACKUPFILE=/etc/ssl/openssl.cnf-`date +%y%m%d`
#       Must be root to run this script
if ! [ $(id -u) = 0 ] ; then
        echo "${0} ${LINENO} [ERROR]:   Use sudo ${0}"  1>&2
        echo -e "\n>>   SCRIPT MUST BE RUN AS ROOT TO CHANGE THE /etc/ssl/openssl.cnf FILE      <<"     1>&2
        exit 1
fi




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



View the client certificate expiration date of the ca.pem file by entering the following command.
openssl x509 -in $HOME/.docker/ca.pem -noout -enddate
notAfter=Jan 23 22:45:14 2021 GMT

View the client certificate expiration date of the cert.pem file by entering the following command.
openssl x509 -in $HOME/.docker/cert.pem -noout -enddate
notAfter=Jul 24 16:13:08 2017 GMT
If the client certificate has expired, go to Create Keys for User, page 111.

View the client certificate issuer data of the ca.pem file by entering the following command.
openssl x509 -in $HOME/.docker/ca.pem -noout -issuer
issuer= /C=US/ST=Texas/L=Cedar Park/O=Company Name/OU=IT/CN=two.cptx86.com

View the client certificate issuer data of the cert.pem file by entering the following command.
openssl x509 -in $HOME/.docker/cert.pem -noout -issuer
issuer= /C=US/ST=Texas/L=Cedar Park/O=Company Name/OU=IT/CN=two.cptx86.com

Verify that the client public key in your certificate matches the public portion of your private key, enter the following.1
(cd $HOME/.docker ; openssl x509 -noout -modulus -in cert.pem | openssl md5 ; openssl rsa -noout -modulus -in key.pem | openssl md5) | uniq
(stdin)= 775c9b663941c0e36d91cd8583a649fa
If only one line of output is returned then the public key matches the public portion of your private key.  For more information about the Linux command uniq, enter man uniq.

Verify that the client certificate was issued by the CA.
openssl verify -verbose -CAfile $HOME/.docker/ca.pem $HOME/.docker/cert.pem
/home/utwo/.docker/cert.pem: OK


#	example code to start with 
#	CLIENT=$1
#	DAY=$2
#	
#
#		cd $HOME/.docker/docker-ca
#		if [ -z $CLIENT ]
#		then
#			echo "Enter user name needing new TLS keys:"
#			read CLIENT
#		fi
#		if [ -z $DAY ]
#		then
#			echo "Enter number of days user $CLIENT needs the TLS keys:"
#			read DAY
#		fi
#		if [ -a "./.private/ca-priv-key.pem" ]
#		then
#			echo ">>	The $HOME/.docker/docker-ca/.private/ directory does exist."
#		else
#			echo ">>>	ERR Private key not found ($HOME/.docker/docker-ca/.private/ca-priv-key.pem) <<<"
#			exit
#		fi
#		if [ -n $CLIENT ]
#		then
#			echo -e "\n>>	Creating client private key for user $CLIENT.\n"
#			openssl genrsa -out $CLIENT-client-priv-key.pem 2048
#		
#			echo -e "\n>>	Generate a Certificate Signing Request (CSR) for user $CLIENT.\n"
#			openssl req -subj '/subjectAltName=client' -new -key $CLIENT-client-priv-key.pem -out $CLIENT-client.csr
#		
#			echo -e ">>	Create and sign a $DAY day certificate for user $CLIENT.\n"
#			openssl x509 -req -days $DAY -sha256 -in $CLIENT-client.csr -CA ca.pem -CAkey .private/ca-priv-key.pem -CAcreateserial -out $CLIENT-client-cert.pem
#		
#			echo -e "\n>>	Removing certificate signing requests (CSR) and set file permissions for $CLIENT key pairs.\n"
#			rm $CLIENT-client.csr
#			chmod 0400 $CLIENT-client-priv-key.pem
#			chmod 0444 $CLIENT-client-cert.pem
#		else
#			echo "***** This script requires a user name as the first argument and number of days the certificates is valid as the second argument. *****"
#			exit
#		fi
#		echo -e ">>	The following are instructions for setting up the public, private, and certificate files for $CLIENT.\n"
#		echo "Copy the CA's public key (also called certificate) from the working directory to ~$CLIENT/.docker."
#		echo "	sudo mkdir -pv ~$CLIENT/.docker"
#		echo "	sudo chmod 700 ~$CLIENT/.docker"
#		echo "	sudo cp -pv ca.pem ~$CLIENT/.docker"
#		echo "		or if copying to remove host, five, and to user $CLIENT"
#		echo "		ssh $CLIENT@five.cptx86.com mkdir -pv ~$CLIENT/.docker"
#		echo "		ssh $CLIENT@five.cptx86.com chmod 700 ~$CLIENT/.docker"
#		echo "		scp -p ca.pem $CLIENT@five.cptx86.com:~$CLIENT/.docker"
#		echo -e "\nCopy the key pair files signed by the CA from the working directory to ~$CLIENT/.docker."
#		echo "	sudo cp -pv $CLIENT-client-cert.pem ~$CLIENT/.docker"
#		echo "	sudo cp -pv $CLIENT-client-priv-key.pem ~$CLIENT/.docker"
#		echo "		or if copying to remove host, five, and for user $CLIENT"
#		echo "		scp -p $CLIENT-client-cert.pem $CLIENT@five.cptx86.com:~$CLIENT/.docker"
#		echo "		scp -p $CLIENT-client-priv-key.pem $CLIENT@five.cptx86.com:~$CLIENT/.docker"
#		echo -e "\nCreate symbolic links to point to the default Docker TLS file names."
#		echo "	sudo ln -s ~$CLIENT/.docker/$CLIENT-client-cert.pem ~$CLIENT/.docker/cert.pem"
#		echo "	sudo ln -s ~$CLIENT/.docker/$CLIENT-client-priv-key.pem ~$CLIENT/.docker/key.pem"
#		echo "	sudo chown -R $CLIENT:$CLIENT ~$CLIENT/.docker"
#		echo "		or if remove host, five, and for user $CLIENT"
#		echo "		ssh $CLIENT@five.cptx86.com ln -s ~$CLIENT/.docker/$CLIENT-client-cert.pem ~$CLIENT/.docker/cert.pem"
#		echo "		ssh $CLIENT@five.cptx86.com ln -s ~$CLIENT/.docker/$CLIENT-client-priv-key.pem ~$CLIENT/.docker/key.pem"
#		echo -e "\nIn bash you can set environment variables permanently by adding them to the user's .bashrc.  These"
#		echo "environment variables will be set each time the user logs into the test computer system.  Edit your .bashrc"
#		echo "file (or the correct shell if different) and append the following two lines."
#		echo "	vi  $CLIENT/.bashrc"
#		echo -e "\nexport DOCKER_HOST=tcp://`hostname -f`:2376"
#		echo "	export DOCKER_TLS_VERIFY=1"
