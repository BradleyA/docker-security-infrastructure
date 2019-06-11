#!/bin/bash
# 	docker-TLS/check-ca-tls.sh  3.283.750  2019-06-10T23:51:10.701588-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.282  
# 	   docker-TLS/check-ca-tls.sh - complete design - in development #56 
# 	docker-TLS/check-ca-tls.sh  3.276.743  2019-06-09T14:26:35.259926-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.275  
# 	   marked in development 
# 	docker-TLS/check-ca-tls.sh  3.275.742  2019-06-09T14:23:33.079346-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.274  
# 	   created new tool docker-TLS/check-ca-tls.sh,  need to add production standards 
echo -e ">>>>   >>>>   IN DEVELOPMENT   IN DEVELOPMENT   IN DEVELOPMENT   <<<<   <<<<"
echo -e ">>>>   >>>>   IN DEVELOPMENT   IN DEVELOPMENT   IN DEVELOPMENT   <<<<   <<<<"

#	check-ca-tls.sh - complete design - in development #56


CA_CERT="ca.pem"
CA_PRIVATE_CERT="ca-priv-key.pem"

if [ -s ${CA_CERT} ] ; then
	#       Get certificate start and expiration date of ${CA_CERT} file
	CA_CERT_START_DATE=$(openssl x509 -in "${CA_CERT}" -noout -startdate | cut -d '=' -f 2)
	CA_CERT_START_DATE_2=$(date -u -d"${CA_CERT_START_DATE}" +%g%m%d%H%M.%S)
	CA_CERT_START_DATE=$(date -u -d"${CA_CERT_START_DATE}" +%Y-%m-%dT%H:%M:%S%z)
	CA_CERT_EXPIRE_DATE=$(openssl x509 -in "${CA_CERT}" -noout -enddate | cut -d '=' -f 2)
	CA_CERT_EXPIRE_DATE=$(date -u -d"${CA_CERT_EXPIRE_DATE}" +%Y-%m-%dT%H:%M:%S%z)
	cp -f -p "${CA_CERT}" "${CA_CERT}_${CA_CERT_START_DATE}_${CA_CERT_EXPIRE_DATE}"
	chmod 0444 "${CA_CERT}" "${CA_CERT}_${CA_CERT_START_DATE}_${CA_CERT_EXPIRE_DATE}"
	touch -m -t "${CA_CERT_START_DATE_2}" "${CA_CERT}_${CA_CERT_START_DATE}_${CA_CERT_EXPIRE_DATE}" "${CA_CERT}"
	ls -l ${CA_CERT}*
else
	echo "${CA_CERT} not found in this directory $(pwd)"
fi

#	if [ -z ${CA_PRIVATE_CERT} ] ; then
#	cp -f -p ".private/${CA_PRIVATE_CERT}" ".private/${CA_PRIVATE_CERT}_${CA_CERT_START_DATE}_${CA_CERT_EXPIRE_DATE}"
#	touch 0400 ".private/${CA_PRIVATE_CERT}_${CA_CERT_START_DATE}_${CA_CERT_EXPIRE_DATE}"
#	fi
