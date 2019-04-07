# docker-TLS

These bash scripts will create, copy, and check TLS public keys, private keys, and self-signed certificates for the docker user, daemon, and docker swarm.  After many reinstalls of OS's and Docker, I got tried of entering the cryptic command line text required to setup Docker to use TLS.

These bash scripts also help minimize the exposure to risk when incidents happen requiring you to be agile and replace impacted certificates quickly. 

**create-site-private-public-tls.sh** - Run this script first on your host that will be creating all your TLS keys other than your registry certifications.  It creates the site private and CA keys that all other TLS keys at your site will be using.  It creates the working directories  $HOME/.docker/docker-ca and $HOME/.docker/docker-ca/.private for your site public and private keys.  If you later choose to use a different host to continue creating your user and host TLS keys; copy the files in $HOME/.docker/docker-ca and $HOME/.docker/docker-ca/.private to the new host then run create-new-openssl.cnf-tls.sh scipt on the new host.

**create-new-openssl.cnf-tls.sh** - Run this script as an administration user second except for your registry certifications.  It is required to make changes to the /etc/ssl/openssl.cnf file on your host.  These changes are required to run **create-user-tls** and **create-host-tls** scripts.  This script is not required to run create-site-private-public-tls.sh script.  It is only required to be run once on a host that will be creating all your TLS host and user keys.  If you choose to use a different host to continue creating your user and host TLS keys, run this script on the new host to modify openssl.cnf file.

**create-user-tls.sh** - Run this script any time a user requires a new Docker public and private TLS key.

**create-host-tls.sh** - Run this script any time a host requires a new Docker public and private TLS key.

**copy-user-2-remote-host-tls.sh** - An administration user can run this script to copy user public, private TLS keys, and CA to a remote host.

**copy-host-2-remote-host-tls.sh** - An administration user can run this script to copy host public, private TLS keys, and CA to a remote host.

**check-user-tls.sh** - A user can check their public, private keys, and CA in $HOME/.docker or an administration user can check other users certificates by using sudo.

**check-host-tls.sh** - An administration user can check a host public, private keys, and CA in /etc/docker/certs.d/daemon by using sudo.


**create-registry-tls.sh** - Run this script to create Docker private registry certificates on any host in the directory; ~/.docker/.  It will create a working directory, ~/.docker/registry-certs-<REGISTRY_HOST>-<REGISTRY_PORT>.  The <REGISTRY_PORT>
number is not required when creating a private registry certificates.  It is used to keep track of multiple certificates for multiple private registries on the same host.  The scripts create-site-private-public-tls.sh and create-new-openssl.cnf-tls.sh are NOT required for a private registry.

**copy-registry-tls.sh** - A user with administration authority uses this script to copy Docker private registry certificates from ~/.docker/registry-certs-<REGISTRY_HOST>-<REGISTRY_PORT> directory on this system to systems in <SYSTEMS_FILE> which MUST include the <REGISTRY_HOST>.  The certificates (domain.{crt,key}) for the <REGISTRY_HOST> are coped to it, into the following directory: <DATA_DIR>/<CLUSTER>/docker-registry/<REGISTRY_HOST>-<REGISTRY_PORT>/certs/.  The daemon registry domain cert (ca.crt) is copied to all the systems found in <SYSTEMS_FILE> in the following directory, /etc/docker/certs.d/<REGISTRY_HOST>:<REGISTRY_PORT>/.

**check-registry-tls.sh** - 

## Install
To clone, change to the directory you want to download the scripts.  Use git to clone these scripts into your directory.  If you do not have git then enter; "sudo apt-get install git".  On the github page of this script use the "HTTPS clone URL" with the 'git clone' command. 
    
    git clone https://github.com/BradleyA/docker-security-infrastructure
    cd docker-security-infrastructure/docker-TLS
    
    sudo mkdir -p /usr/local/bin
    sudo chown $USER:$(id -g) /usr/local/bin
    chmod 0775 /usr/local/bin
    mv c* /usr/local/bin
    cd ../..
    rm -rf docker-security-infrastructure

## Usage
Run this script first on your host to create your site private and public TLS keys.  To change the default number of days (730 days = 2 years) enter a number of days as the parameter (example: create-site-private-public-tls 365 ).

    create-site-private-public-tls.sh <#days>

## Output
    $ ./create-site-private-public-tls.sh
    
    ./create-site-private-public-tls.sh 48 [INFO]:	Creating private key with passphrase in /home/uadmin/.docker/docker-ca/.private
    Generating RSA private key, 4096 bit long modulus
    .............................................................................................................++
    ................................................++
    e is 65537 (0x10001)
    Enter pass phrase for ca-priv-key.pem:
    Verifying - Enter pass phrase for ca-priv-key.pem:
    
    Once all the certificates and keys have been generated with this private key,
    it would be prudent to move the private key to a Universal Serial Bus (USB)
    memory stick.  Remove the private key from the system and store the USB memory
    stick in a locked fireproof location.
    
    ./create-site-private-public-tls.sh 55 [INFO]:	Creating public key good for
	730 days in /home/uadmin/.docker/docker-ca
    The public key is copied to all systems in an environment so that those
    systems trust signed certificates.  The following is a list of prompts from
    the following command and example answers are in parentheses.
    Country Name (US)
    State or Province Name (Texas)
    Locality Name (Cedar Park)
    Organization Name (Company Name)
    Organizational Unit Name (IT - SRE Team Central US)
    Common Name (two.cptx86.com)
    Email Address ()
    
    Enter pass phrase for .private/ca-priv-key.pem:
    You are about to be asked to enter information that will be incorporated
    into your certificate request.
    What you are about to enter is what is called a Distinguished Name or a DN.
    There are quite a few fields but you can leave some blank
    For some fields there will be a default value,
    If you enter '.', the field will be left blank.
    -----
    Country Name (2 letter code) [AU]:US
    State or Province Name (full name) [Some-State]:Texas
    Locality Name (eg, city) []:Cedar Park
    Organization Name (eg, company) [Internet Widgits Pty Ltd]:Company Name
    Organizational Unit Name (eg, section) []:IT - SRE Team Central US
    Common Name (e.g. server FQDN or YOUR name) []:two.cptx86.com
    Email Address []:
    
    ./create-site-private-public-tls.sh 74 [INFO]:	These certificate
	are valid for 730 days.
    It would be prudent to document the date when to renew these certificates and
    set an operations or project management calendar entry about 15 days before
    renewal as a reminder to schedule

## Usage
Run this script second on your host that will be used to create all your certificates.  This script makes a change to the openssl.cnf file.

    sudo ./create-new-openssl.cnf-tls.sh

## Output
    $ sudo ./create-new-openssl.cnf-tls.sh
    This script will make changes to /etc/ssl/openssl.cnf file.
    These changes are required before creating user and host TLS keys for Docker.
    Run this script before running the user and host TLS scripts.  It is not
    required to be run on hosts not creating tTLS keys.
    
    Creating backup file of /etc/ssl/openssl.cnf and naming it /etc/ssl/openssl.cnf-2018-02-04_13:23:04_CST
    
    ./create-new-openssl.cnf-tls.sh 41 [INFO]:	Adding the extended KeyUsage
	at the beginning of [ v3_ca ] section.

## Usage
Run this script for each user that requires a new Docker public and private TLS key.

    ./create-user-tls.sh <user> <#days> 

## Output
    $ ./create-user-tls.sh sally 30
    ./create-user-tls.sh 71 [INFO]:	Creating private key for user sally.
    Generating RSA private key, 2048 bit long modulus
    .........+++
    .....................................................+++
    e is 65537 (0x10001)
    ./create-user-tls.sh 74 [INFO]:	Generate a Certificate Signing
	Request (CSR) for user sally.
	./create-user-tls.sh 77 [INFO]:	Create and sign a 30 day
	certificate for user sally.
	Signature ok
	subject=/subjectAltName=client
	Getting CA Private Key
	Enter pass phrase for .private/ca-priv-key.pem:
	./create-user-tls.sh 80 [INFO]:	Removing certificate signing
	requests (CSR) and set file permissions for sally key pairs.
	./create-user-tls.sh 85 [INFO]: Done.
	
## Usage
Run this script for each host that requires a new Docker public and private TLS key.

    ./create-host-tls.sh <FQDN> <#days>

## Output
    $ ./create-host-tls.sh two.cptx86.com 185
    ./create-host-tls.sh 82 [INFO]:	Creating private key for host
	two.cptx86.com.
	Generating RSA private key, 2048 bit long modulus
	..................+++
	.................................................................................................................+++
	e is 65537 (0x10001)
	./create-host-tls.sh 85 [INFO]:	Generate a Certificate Signing Request
	(CSR) for host two.cptx86.com.
	./create-host-tls.sh 88 [INFO]:	Create and sign a 185 day
	certificate for host two.cptx86.com.
	Signature ok
	subject=/CN=two.cptx86.com/subjectAltName=two.cptx86.com
	Getting CA Private Key
	Enter pass phrase for .private/ca-priv-key.pem:
	writing RSA key
	./create-host-tls.sh 91 [INFO]:	Removing certificate signing requests
	(CSR) and set file permissions for host two.cptx86.com key pairs.
	./create-host-tls.sh 95 [INFO]:	Done.

## Usage
An administration user can run this script to copy user public, private TLS keys, and CA to a remote host.

    ./copy-user-2-remote-host-tls.sh <user> <remotehost> 
    
## Output
    $ ./copy-user-2-remote-host-tls.sh sally two.cptx86.com
    ./copy-user-2-remote-host-tls.sh 75 [INFO]:	uadmin may receive password and
	passphrase prompt from two.cptx86.com. Running
	ssh-copy-id uadmin@two.cptx86.com may stop the prompts.
	#################################################
	#         All connections are monitored         #
	#################################################
    Connection to two.cptx86.com closed.
    ./copy-user-2-remote-host-tls.sh 77 [INFO]:	Create directory, change
	file permissions, and copy TLS keys to sally@two.cptx86.com.
    ./copy-user-2-remote-host-tls.sh 90 [INFO]:	Transfer TLS keys to sally@two.cptx86.com.
	#################################################
	#         All connections are monitored         #
	#################################################
    sallytwo.cptx86.com2018-02-04-13-54-27-CST.tar                                   100%   10KB  10.0KB/s   00:00    
	#################################################
	#         All connections are monitored         #
	#################################################
    [sudo] password for uadmin:
    Connection to two.cptx86.com closed.
    
    To set environment variables permanently, add them to the user's
	.bashrc.  These environment variables will be set each time the user
	logs into the computer system.  Edit your .bashrc file (or the
	correct shell if different) and append the following two lines.
	export DOCKER_HOST=tcp://`hostname -f`:2376
	export DOCKER_TLS_VERIFY=1
    ./copy-user-2-remote-host-tls.sh 109 [INFO]:	Done.

## Usage
A user with administration authority (uadmin) uses this script to copy host TLS CA, public, and private keys from /home/uadmin/.docker/docker-ca directory on this system to /etc/docker/certs.d directory on a remote system.
The administration user may receive password and/or passphrase prompts from a remote systen; running the following may stop the prompts in your cluster.
   ssh-copy-id <admin-user>@x.x.x.x

    ./copy-host-2-remote-host-tls.sh one-rpi3b.cptx86.com

## Output

     $ ./copy-host-2-remote-host-tls.sh one-rpi3b.cptx86.com
     ./copy-host-2-remote-host-tls.sh 71 [INFO]:	uadmin may receive password and
	passphrase prompt from one-rpi3b.cptx86.com. Running ssh-copy-id
	uadmin@one-rpi3b.cptx86.com may stop the prompts.
	#################################################
	#         All connections are monitored         #
	#################################################
    Connection to one-rpi3b.cptx86.com closed.
	#################################################
	#         All connections are monitored         #
	#################################################
    Connection to one-rpi3b.cptx86.com closed.
    ./copy-host-2-remote-host-tls.sh 102 [INFO]: Transfer TLS keys to
	one-rpi3b.cptx86.com.
	#################################################
	#         All connections are monitored         #
	#################################################
    one-rpi3b.cptx86.com2018-02-05-08-46-39-CST.tar                      100%   20KB  20.0KB/s   00:00
    ./copy-host-2-remote-host-tls.sh 107 [INFO]:	Create dockerd certification
	directory on one-rpi3b.cptx86.com
	#################################################
	#         All connections are monitored         #
	#################################################
    [sudo] password for uadmin:
    Connection to one-rpi3b.cptx86.com closed.
    
    Add TLS flags to dockerd so it will know to use TLS certifications (--tlsverify,
    --tlscacert, --tlscert, --tlskey).  Scripts that will help with setup and
    operations of Docker using TLS can be found:
    https://github.com/BradleyA/docker/tree/master/dockerd-configuration-options
	The dockerd-configuration-options scripts will help with
	configuration of dockerd on systems running Ubuntu 16.04
	(systemd) and Ubuntu 14.04 (Upstart).
	
	If dockerd is already using TLS certifications then:
	Ubuntu 16.04 (systemd) sudo systemctl restart docker
	Ubuntu 14.04 (systemd) sudo service docker restart
	./copy-host-2-remote-host-tls.sh 125 [INFO]:	Done.

## Usage
A user can check their public, private keys, and CA in $HOME/.docker or a user can check other users certificates by using sudo.
    
    ./check-user-tls.sh <user>

## Output

    $ sudo ./check-user-tls.sh bob
    
    View /home/bob/.docker certificate expiration date of ca.pem file.
    notAfter=Feb  4 19:11:00 2020 GMT
    
    View /home/bob/.docker certificate expiration date of cert.pem file
    notAfter=May  6 15:07:05 2018 GMT
    
    View /home/bob/.docker certificate issuer data of the ca.pem file.
    issuer= /C=US/ST=Texas/L=Cedar Park/O=Company Name/OU=IT - SRE Team Central US/CN=two.cptx86.com
    
    View /home/bob/.docker certificate issuer data of the cert.pem file.
    issuer= /C=US/ST=Texas/L=Cedar Park/O=Company Name/OU=IT - SRE Team Central US/CN=two.cptx86.com
    
    Verify that user public key in your certificate matches the public portion of your private key.
    (stdin)= b2fb009b395f688263a23691495c2988
    If only one line of output is returned then the public key matches the public portion of your private key.
    
    Verify that user certificate was issued by the CA.
    /home/bob/.docker/cert.pem: OK

## Usage

    ./check-host-tls.sh

## Output

    $ sudo ./check-host-tls.sh
    ./check-host-tls.sh 54 [INFO]:	Checking six-rpi3b.cptx86.com TLS
	certifications and directory permissions.
	
    View dockerd daemon certificate expiration date of ca.pem file.
    notAfter=Dec  5 22:34:44 2020 GMT
    
    View dockerd daemon certificate expiration date of cert.pem file
    notAfter=Jan 21 18:52:28 2019 GMT
    
    View dockerd daemon certificate issuer data of the ca.pem file
    issuer= /C=US/ST=Texas/L=Cedar Park/O=Company Name/OU=IT/CN=two.cptx86.com
    
    View dockerd daemon certificate issuer data of the cert.pem file
    issuer= /C=US/ST=Texas/L=Cedar Park/O=Company Name/OU=IT/CN=two.cptx86.com
    
    Verify that dockerd daemon certificate was issued by the CA.
    /etc/docker/certs.d/daemon/cert.pem: OK

#### Install Scripts
To install the scripts, change to the directory you have write permission (examples: ~/bin, /usr/local/bin) 

    curl -L https://api.github.com/repos/BradleyA/docker-security-infrastructure/tarball | tar -xzf - --wildcards */c* && mv BradleyA-docker-security-infrastructure*/docker-TLS/c* . && rm -rf BradleyA-docker-security-infrastructure*/

#### To watch future updates in this repository select in the upper-right corner, the "Watch" list, and select Watching.

#### Author
[<img id="twitter" src="../images/twitter.png" width="50" a="twitter.com/bradleyaustintx/">
](https://twitter.com/bradleyaustintx/)   [<img id="github" src="../images/github.png" width="50" a="https://github.com/BradleyA/">
](https://github.com/BradleyA/)    [<img src="../images/linkedin.png" style="max-width:100%;" >](https://www.linkedin.com/in/bradleyhallen)

#### System OS script tested
 * Ubuntu 14.04.4 LTS
 * Ubuntu 16.04.3 LTS (armv7l)

#### Design Principles
 * Have a simple setup process and a minimal learning curve
 * Be usable as non-root when able
 * Be easy to install and configure

## License
MIT License

Copyright (c) 2019  [Bradley Allen](https://www.linkedin.com/in/bradleyhallen)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
