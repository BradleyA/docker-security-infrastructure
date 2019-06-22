#!/bin/bash
# 	docker-TLS/check-ca-tls.sh  3.285.752  2019-06-21T21:27:32.676784-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.284  
# 	   check-ca-tls.sh usage #56 
# 	docker-TLS/check-ca-tls.sh  3.283.750  2019-06-10T23:51:10.701588-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.282  
# 	   docker-TLS/check-ca-tls.sh - complete design - in development #56 
# 	docker-TLS/check-ca-tls.sh  3.276.743  2019-06-09T14:26:35.259926-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.275  
# 	   marked in development 
# 	docker-TLS/check-ca-tls.sh  3.275.742  2019-06-09T14:23:33.079346-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.274  
# 	   created new tool docker-TLS/check-ca-tls.sh,  need to add production standards 
echo -e ">>>>   >>>>   IN DEVELOPMENT   IN DEVELOPMENT   IN DEVELOPMENT   <<<<   <<<<"
echo -e ">>>>   >>>>   IN DEVELOPMENT   IN DEVELOPMENT   IN DEVELOPMENT   <<<<   <<<<"
#	check-ca-tls.sh - complete design - in development #56

### production standard 3.0 shellcheck
### production standard 5.1.160 Copyright
#       Copyright (c) 2019 Bradley Allen
#       MIT License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
### production standard 1.0 DEBUG variable
#       Order of precedence: environment variable, default code
if [ "${DEBUG}" == "" ] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
#       set -x
#       set -v
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
### production standard 7.0 Default variable value
DEFAULT_CERTDIR="${HOME}/.docker"
DEFAULT_CA_CERT="ca.pem"
DEFAULT_CA_PRIVATE_CERT="ca-priv-key.pem"
### production standard 8.0 --usage
display_usage() {
echo -e "\n${NORMAL}${0} - read start and end date of ${DEFAULT_CA_CERT}"
echo -e "\nUSAGE"
echo    "   ${0} [<CERTDIR>]"
echo    "   ${0}  <CERTDIR> [<CA_CERT>]"
echo -e "   ${0}  <CERTDIR>  <CA_CERT> [<CA_PRIVATE_CERT>]\n"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--usage | -usage | -u]"
echo    "   ${0} [--version | -version | -v]"
}


#	argument over ride default $HOME/.docker    -   DEFAULT_CERTDIR="/etc/docker/certs.d/daemon/"

#
if [ -s "${CERTDIR}/${CA_CERT}" ] ; then
	#       Get certificate start and expiration date of ${CA_CERT} file
	CA_CERT_START_DATE=$(openssl x509 -in "${CERTDIR}/${CA_CERT}" -noout -startdate | cut -d '=' -f 2)
	CA_CERT_START_DATE_2=$(date -u -d"${CA_CERT_START_DATE}" +%g%m%d%H%M.%S)
	CA_CERT_START_DATE=$(date -u -d"${CA_CERT_START_DATE}" +%Y-%m-%dT%H:%M:%S%z)
	CA_CERT_EXPIRE_DATE=$(openssl x509 -in "${CERTDIR}/${CA_CERT}" -noout -enddate | cut -d '=' -f 2)
	CA_CERT_EXPIRE_DATE=$(date -u -d"${CA_CERT_EXPIRE_DATE}" +%Y-%m-%dT%H:%M:%S%z)
	cp -f -p "${CERTDIR}/${CA_CERT}" "${CERTDIR}/${CA_CERT}_${CA_CERT_START_DATE}_${CA_CERT_EXPIRE_DATE}"
	chmod 0444 "${CERTDIR}/${CA_CERT}" "${CERTDIR}/${CA_CERT}_${CA_CERT_START_DATE}_${CA_CERT_EXPIRE_DATE}"
	touch -m -t "${CA_CERT_START_DATE_2}" "${CERTDIR}/${CA_CERT}_${CA_CERT_START_DATE}_${CA_CERT_EXPIRE_DATE}" "${CERTDIR}/${CA_CERT}"
	ls -l ${CERTDIR}/${CA_CERT}*
else
	echo "${CERTDIR}/${CA_CERT} not found in this directory $(pwd)"
fi

#	if [ -z ${CA_PRIVATE_CERT} ] ; then
#	cp -f -p ".private/${CA_PRIVATE_CERT}" ".private/${CA_PRIVATE_CERT}_${CA_CERT_START_DATE}_${CA_CERT_EXPIRE_DATE}"
#	touch 0400 ".private/${CA_PRIVATE_CERT}_${CA_CERT_START_DATE}_${CA_CERT_EXPIRE_DATE}"
#	fi
