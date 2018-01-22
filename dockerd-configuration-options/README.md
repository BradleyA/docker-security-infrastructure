# dockerd-configuration-options

#### WARNING: These instructions are incomplete. Consider them as notes quickly drafted on a napkin rather than proper documentation!

#### Need to clean this up once I get everything workingt!

Goal is to use one dockerd configuration file with dockerd flags for both Ubuntu 16.04 (systemd) and Ubuntu 14.04 (Upstart) other than /etc/docker/daemon.json.  

Running setup-dockerd.sh will move files into /etc/docker and create or update the /etc/systemd/system/docker.service.d/10-override.conf file (Ubuntu 16.04, systemd) and the /etc/default/docker (Ubuntu 14.04, Upstart).  To change the docker daemon flags, sudo edit /etc/docker/dockerd-configuration-file and run sudo /etc/docker/setup-dockerd.sh.  Docker daemon flag changes can be distributed to any Ubuntu cluster that use systemd or upstart by copying /etc/docker/dockerd-configuration-file to each system and running sudo /etc/docker/setup-dockerd.sh on each system.

I chose not to use [/etc/docker/daemon.json](https://docs.docker.com/engine/reference/commandline/dockerd/) for docker daemon configuration because json does not support [comments](https://plus.google.com/+DouglasCrockfordEsq/posts/RK8qyGVaGSr).

This has not been tested for other Linux OS's.  Let me know if you use it on other Linus OS's.

## Install
To install, change directory to the location you want to download the scripts. Use git to pull or clone these scripts into the directory. If you do not have git then enter; "sudo apt-get install git". On the github page of this script use the "HTTPS clone URL" with the 'git clone' command.

    git clone https://github.com/BradleyA/docker-scripts
    cd docker-scripts/dockerd-configuration-options
    
Edit dockerd-configuration-file, change the [dockerd flags](https://docs.docker.com/engine/reference/commandline/dockerd/) to the flags your dockerd environment requires.  This file, dockerd-configuration-file, is an example.  It is what I am currently using.  You will want to remove --data-root=/usr/local/docker flag if you are using the default location (/var/lib/docker) or change it to your root of the Docker.  You will want to change the address of the local dns server (--dns 192.168.1.202) to your dns server address.  If you do not have [TLS CA certificates](https://docs.docker.com/engine/security/https/) setup or in a different location or using different names then you will want to remove or change those flag.  If you have not used --userns-remap=default before you WILL want to remove this flag until you read more about this security feature.

    edit dockerd-configuration-file

After editing the dockerd-configuration-file with your dockerd flags, run sudo ./setup-dockerd.sh.  It will move all the required files including setup-dockerd.sh into the /etc/docker and /etc/systemd/system/ directories.  The next time you want to make a change to your dockerd flags use sudo edit /etc/docker/dockerd-configuration-file and then sudo /etc/docker/setup-dockerd.sh.  
    
    sudo ./setup-dockerd.sh

#### Note:
	Comment: May need to add code in setup-dockerd.sh for :  if statements for checking which OS of the system is by using the follow command lsb_release -r -s  Not sure this is need other than to the echo statement so it is not so missleading if you do not know what OS you are using, also this would prevent other OS's from using these scripts, so maybe not do this ... need to think through this  ... but near the end of the setup-dockerd.sh file it calls systemctl daemon-reload and that may error on Ubuntu 14.04
	
1) Download files:
    
644	10-override.begin - beginning default lines for /etc/systemd/system/docker.service.d/10-override.conf file used by systemd docker.service.  Other lines for /etc/systemd/system/docker.service.d/10-override.conf file will be created by running /etc/docker/start-dockerd-with-systemd.sh.

644	dockerd-configuration-file - dockerd option file for setting DOCKER_OPTS= environment variable to be added to Ubuntu 14.04 (upstart) in /etc/default/docker file and Ubuntu 16.04 (systemd) in /etc/systemd/system/docker.service.d/10-override.conf

644	dockerd-configuration-file.service

744	setup-dockerd.sh

644	start-dockerd-with-systemd.begin

644	start-dockerd-with-systemd.end

2) Append dockerd-configuration-file to /etc/default/docker for ubuntu 14.04 upstart docker daemon
3) Run dockerd-configuration-file.service as a service to create $OVERRIDE_FILE before sudo systemctl start docker so this service is a pre-req of docker.service will need to add that to dockerd-configuration-file.service

#### System OS script tested
 * Ubuntu 14.04.3 LTS
 * Ubuntu 16.04.3 LTS

#### Design Principles
 * Have a simple setup process and a minimal learning curve
 * Be usable as non-root - [failed- must us sudo ]
 * Be easy to install and configure

## License::

Permission is hereby granted, free of charge, to any person obtaining a copy of this software, associated documentation, and files (the "Software") without restriction, including without limitation of rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
