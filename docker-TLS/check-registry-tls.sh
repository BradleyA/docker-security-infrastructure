
# 	docker-TLS/check-registry-tls.sh  3.139.551  2019-03-06T16:05:05.253103-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure-scripts.git  uadmin  six-rpi3b.cptx86.com 3.138  
# 	   set file permission for certs 
# 	docker-TLS/check-registry-tls.sh  3.130.542  2019-03-01T22:11:03.984554-06:00 (CST)  https://github.com/BradleyA/docker-security-infrastructure-scripts.git  uadmin  six-rpi3b.cptx86.com 3.129  
# 	   need to open issue to create docker-TLS/create-registry-tls.sh 

###
echo "In development"
exit


# 



echo    "An administration user can run this script to create Docker private registry"
echo    "certificates on any host in the directory; \${HOME}/.docker/.  It will create"
echo    "a working directory, registry-certs-<REGISTRY_HOST>-<REGISTRY_PORT>.  The"
echo    "<REGISTRY_PORT> number is not required when creating private registry"
echo    "certificates.  I use the <REGISTRY_PORT> number to keep track of multiple"
echo    "certificates for multiple private registries on the same host.  The"
echo    "<REGISTRY_HOST> and <REGISTRY_PORT> number is required when copying the"
echo    "ca.crt into the /etc/docker/certs.d/<REGISTRY_HOST>:<REGISTRY_PORT>/"
echo    "directory on each host using the private registry."
echo -e "\nConfiguration"
echo    "   /usr/local/"
echo    "   └── docker-registry-<REGISTRY_PORT>/certs/ <-- Certificate directory"
echo    "      ├── domain.crt                          <-- registry certificate"
echo    "      └── domain.key                          <-- registry key"
echo    "   /etc/docker/certs.d/"
echo    "   └── <REGISTRY_HOST>:<REGISTRY_PORT>/       <-- Certificate directory"
echo    "      └── ca.crt                              <-- Certificate authority"

