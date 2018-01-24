# create-docker-TLS-scripts
create-site-private-public-tls.sh, create-new-openssl.cnf-tls.sh, create-client-tls.sh, and create-host-tls.sh are bash scripts that create TLS public keys, private keys, and self-signed certificates for the docker user, daemon, and swarm.  After many reinstalls of OS's and Docker, I got tried of entering the cryptic command line text required to setup Docker to use TLS.  Each example I found on-line was different than the last example.

create-site-private-public-tls.sh - Run this script first on your host that will be creating all your TLS keys.  It creates the site private and public keys that all other TLS keys at your site will be using.  It creates the working directories  $HOME/.docker/docker-ca and $HOME/.docker/docker-ca/.private for your site public and private keys.  These site cerificates are set for four years until new certificates are needed.  You may change the default four year (1460) by including a parameter with the number of days you prefer.  At that time this script will need to be run to create another set of four year public and private site certificates.  If you choose to use a different host to continue creating your client and host TLS keys, cp the $HOME/.docker/docker-ca and $HOME/.docker/docker-ca/.private to the new host.

create-new-openssl.cnf-tls.sh - Run this script second, it is required to make changes to the openssl.cnf file on your host which are required for the create-client-tls and create-host-tls scripts.  It is only required to run once on your host that will be creating all your TLS keys.  If you choose to use a different host to continue creating your client and host TLS keys, run this script on the new host before running the follow two scripts.

create-client-tls.sh - The order of the last two scripts does not matter as long as they are run on your host that is creating all the TLS keys.  See notes about using a different host in the first two scripts.  Run this script any time a user requires a new Docker public and private TLS key.

create-host-tls.sh - The order of the last two scripts does not matter as long as they are run on your host that is creating all the TLS keys.  See notes about using a different host in the first two scripts.  Run this script any time a host requires a new Docker public and private TLS key.

## Install
To install, change directory to the location you want to download the scripts.  Use git to pull or clone these scripts into your directory.  If you do not have git then enter; "sudo apt-get install git".  On the github page of this script use the "HTTPS clone URL" with the 'git clone' command. 
    
    git clone https://github.com/BradleyA/Create-docker-TLS-scripts.1.0.git
    cd Create-docker-TLS-scripts.1.0
    
Move the scripts or create a symbolic link to a location in your working path; example /usr/local/bin. To find directories in your working path use; "echo $PATH".
    
    sudo mkdir -p /usr/local/bin
    sudo mv create-*-tls /usr/local/bin
    cd ..
    rm -r Create-docker-TLS-scripts.1.0
    chmod 0750 /usr/local/bin/create-*-tls

## Usage
Run this script first on your host to create your site private and public TLS keys.  To change the default number of days (1460 days = 4 years) enter a number of days as the parameter (example: create-site-private-public-tls 365 ).

    create-site-private-public-tls.sh

## Output
    $ ./create-site-private-public-tls.sh
    mkdir: created directory '/home/uadmin/.docker/docker-ca'
    mkdir: created directory '/home/uadmin/.docker/docker-ca/.private'
    
    ./create-site-private-public-tls.sh 17 [INFO]:	Creating private key with passphrase in /home/uadmin/.docker/docker-ca/.private
    Generating RSA private key, 4096 bit long modulus
    .............................++
    .......................................++
    e is 65537 (0x10001)
    Enter pass phrase for ca-priv-key.pem:
    Verifying - Enter pass phrase for ca-priv-key.pem:
    
    Once all the certificates and keys have been generated with this private key,
    it would be prudent to move the private key to a Universal Serial Bus (USB) memory stick.
    Remove the private key from all systems and store the USB memory stick in a locked
    fireproof location.
    
    ./create-site-private-public-tls.sh 24 [INFO]:	Creating public key good for 1460 days in /home/uadmin/.docker/docker-ca
    
    The public key is copied to all systems in an environment so that those systems
    trust signed certificates.
    The following is a list of prompts from the following command and example answers are
    in parentheses.
    Country Name (US)
    State or Province Name (Texas)
    Locality Name (Cedar Park)
    Organization Name (Company Name)
    Organizational Unit Name (IT)
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
    Organizational Unit Name (eg, section) []:IT
    Common Name (e.g. server FQDN or YOUR name) []:two.cptx86.com
    Email Address []:
    
    ./create-site-private-public-tls.sh 39 [INFO]:	These certificate are valid for 1460 days.
    
    It would be prudent to document the date when to renew these certificates and set
    an operations or project management calendar entry about 15 days before renewal as
    a reminder to schedule new site certificates.

## Usage
Run this script second on your host that be used to create all your certificates.  It makes a change to the openssl.cnf file.

    sudo ./create-new-openssl.cnf-tls.sh

## Output
    $ sudo ./create-new-openssl.cnf-tls
    This script will make changes to the openssl.cnf file.  These changes are required
    before creating user and host TLS files for Docker.  Run this script before running
    the user and host TLS scripts.  It is not required to be run on hosts not creating TLS files.
    
    Creating backup file of /etc/ssl/openssl.cnf and naming it /etc/ssl/openssl.cnf-160718
    
    Adding the extended KeyUsage at the beginning of the [ v3_ca ] section.

## Usage
Run this script for each user that requires a new Docker public and private TLS key.

    ./create-client-tls.sh <user> <#days> 

## Output
    $ ./create-client-tls.sh sally 30
    ./create-client-tls.sh 25 [INFO]:	The /home/uadmin/.docker/docker-ca/.private/ directory does exist.

    ./create-client-tls.sh 32 [INFO]:	Creating client private key for user sally.

    Generating RSA private key, 2048 bit long modulus
    ............................................+++
    ......................+++
    e is 65537 (0x10001)

    ./create-client-tls.sh 35 [INFO]:	Generate a Certificate Signing Request (CSR) for user sally.

    ./create-client-tls.sh 38 [INFO]:	Create and sign a 30 day certificate for user sally.

    Signature ok
    subject=/subjectAltName=client
    Getting CA Private Key
    Enter pass phrase for .private/ca-priv-key.pem:

    ./create-client-tls.sh 41 [INFO]:	Removing certificate signing requests (CSR) and set file permissions for sally key pairs.

    ./create-client-tls.sh 49 [INFO]:	The following are instructions for setting up the public, private, and certificate files for sally.

    Copy the CA's public key (also called certificate) from the working directory to ~sally/.docker.
	sudo mkdir -pv ~sally/.docker
	sudo chmod 700 ~sally/.docker
	sudo cp -pv ca.pem ~sally/.docker
		or if copying to remove host, five, and to user sally
		ssh sally@five.cptx86.com mkdir -pv ~sally/.docker
		ssh sally@five.cptx86.com chmod 700 ~sally/.docker
		scp -p ca.pem sally@five.cptx86.com:~sally/.docker

    Copy the key pair files signed by the CA from the working directory to ~sally/.docker.
	sudo cp -pv sally-client-cert.pem ~sally/.docker
	sudo cp -pv sally-client-priv-key.pem ~sally/.docker
		or if copying to remove host, five, and for user sally
		scp -p sally-client-cert.pem sally@five.cptx86.com:~sally/.docker
		scp -p sally-client-priv-key.pem sally@five.cptx86.com:~sally/.docker

    Create symbolic links to point to the default Docker TLS file names.
	sudo ln -s ~sally/.docker/sally-client-cert.pem ~sally/.docker/cert.pem
	sudo ln -s ~sally/.docker/sally-client-priv-key.pem ~sally/.docker/key.pem
	sudo chown -R sally:sally ~sally/.docker
		or if remove host, five, and for user sally
		ssh sally@five.cptx86.com ln -s ~sally/.docker/sally-client-cert.pem ~sally/.docker/cert.pem
		ssh sally@five.cptx86.com ln -s ~sally/.docker/sally-client-priv-key.pem ~sally/.docker/key.pem

    In bash you can set environment variables permanently by adding them to the user's .bashrc.  These
    environment variables will be set each time the user logs into the test computer system.  Edit your .bashrc
    file (or the correct shell if different) and append the following two lines.
	vi  sally/.bashrc

    export DOCKER_HOST=tcp://rpi3b-four.cptx86.com:2376
	export DOCKER_TLS_VERIFY=1

    
 
    
    Create symbolic links to point to the default Docker TLS file names.
    cd ~sally/.docker
    ln -s sally-client-cert.pem cert.pem
    ln -s sally-client-priv-key.pem key.pem
        or if remote host, five.cptx86.com, and for user sally.
        ssh sally@five.cptx86.com ln -s ~sally/.docker/sally-client-cert.pem ~sally/.docker/cert.pem
        ssh sally@five.cptx86.com ln -s ~sally/.docker/sally-client-priv-key.pem ~sally/.docker/key.pem
    
    In bash you can set environment variables permanently by adding them to the user's .bashrc.  These
    environment variables will be set each time the user logs into the test computer system.  Edit your .bashrc
    file (or the correct file if using a different shell) and append the following two export lines.
        vi /home/uthree/.bashrc
	
    export DOCKER_HOST=tcp://three.cptx86.com:2376
    export DOCKER_TLS_VERIFY=1

## Usage
Run this script for each host that requires a new Docker public and private TLS key.

    ./create-host-tls.sh <FQDN> <#days>

## Output
    $ ./create-host-tls.sh two.cptx86.com 365
    ./create-host-tls.sh 26 [INFO]:	The /home/uadmin/.docker/docker-ca/.private/ directory does exist.

    ./create-host-tls.sh 37 [INFO]:	Creating private key for host two.cptx86.com

    Generating RSA private key, 2048 bit long modulus
    .......................+++
    ..............................+++
    e is 65537 (0x10001)

    ./create-host-tls.sh 39 [INFO]:	Generate a Certificate Signing Request (CSR) for host two.cptx86.com.

    ./create-host-tls.sh 42 [INFO]:	Create and sign a 365 day certificate for host two.cptx86.com

    Signature ok
    subject=/CN=two.cptx86.com/subjectAltName=two.cptx86.com
    Getting CA Private Key
    Enter pass phrase for .private/ca-priv-key.pem:
    writing RSA key

    ./create-host-tls.sh 45 [INFO]:	Removing certificate signing requests (CSR) and set file permissions for host two.cptx86.com key pairs.

    ./create-host-tls.sh 53 [INFO]:	Instructions for setting up the public, private, and certificate files.

    Login to host two.cptx86.com and create a Docker daemon TLS directory.  
		ssh <user>@two.cptx86.com
		sudo mkdir -p /etc/docker/certs.d/daemon
    Change the directory permission for the Docker daemon TLS directory on host two.cptx86.com and logout.
		sudo chmod 0700 /etc/docker/certs.d/daemon
		logout
    Copy the keys from the working directory on host two to /tmp directory on host two.cptx86.com.
		scp ./ca.pem <user>@two.cptx86.com:'/tmp/ca.pem'
		scp ./two.cptx86.com-cert.pem <user>@two.cptx86.com:'/tmp/two.cptx86.com-cert.pem'
		scp ./two.cptx86.com-priv-key.pem <user>@two.cptx86.com:'/tmp/two.cptx86.com-priv-key.pem'
    Login to host two.cptx86.com and move the key pair files signed by the CA from the /tmp directory to the Docker daemon TLS directory.
		ssh <user>@two.cptx86.com
		cd /tmp
		sudo mv *.pem /etc/docker/certs.d/daemon
		sudo chown -R root.root /etc/docker/certs.d/daemon
		sudo -i
		cd /etc/docker/certs.d/daemon
		ln -s two.cptx86.com-cert.pem cert.pem
		ln -s two.cptx86.com-priv-key.pem key.pem
		exit
	    	
    Add the TLS flags to dockerd so dockerd will know you are using TLS. (--tlsverify, --tlscacert, --tlscert, --tlskey)
    

    The scripts in https://github.com/BradleyA/docker-scripts/tree/master/dockerd-configuration-options
    will help configure dockerd on systems running Ubuntu 16.04 (systemd) and Ubuntu 14.04 (Upstart).


    For systems running Ubuntu 14.04 (Upstart) you can just follow these steps and not use dockerd-configuration-options scripts.
		
    Modify the Docker daemon startup configuration file on host two.cptx86.com and restart Docker.
		sudo vi /etc/default/docker
    DOCKER_OPTS="\ 
      --graph=/usr/local/docker \ 
      --dns 192.168.1.202 \ 
      --dns 8.8.8.8 \ 
      --dns 8.8.4.4 \ 
      --log-level warn \ 
      --tlsverify \ 
      --tlscacert=/etc/docker/certs.d/daemon/ca.pem \ 
      --tlscert=/etc/docker/certs.d/daemon/two.cptx86.com-cert.pem \ 
      --tlskey=/etc/docker/certs.d/daemon/two.cptx86.com-priv-key.pem \ 
      -H=two.cptx86.com:2376 \ 
      "

	sudo service docker restart
	logout

#### System OS script tested
 * Ubuntu 14.04.4 LTS

#### Design Principles
 * Have a simple setup process and a minimal learning curve
 * Be usable as non-root when able
 * Be easy to install and configure

## License ::
create-site-private-public-tls, create-new-openssl.cnf-tls, create-client-tls, and create-host-tls are free software/open source.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software, associated documentation, and files (the "Software") without restriction, including without limitation of rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
