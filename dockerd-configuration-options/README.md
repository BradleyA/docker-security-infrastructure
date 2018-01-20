# dockerd-configuration-options/

#### WARNING: These instructions are incomplete. Consider them as notes quickly drafted on a napkin rather than proper documentation!

#### Need to clean this up once I get everything working for Ubuntu 16.04.  During booting of a system, service dockerd-configuration-file.service changes service docker.service systemd 10-override.conf file.  Need service dockerd-configuration-file.service to force service docker.service to use the systemd 10-override.conf file changes when service docker.service starts during booting of the system.  It works for both Ubuntu 14.04 (Upstart) and Ubuntu 16.04 (systemd) when system boots but the lates chnages made during boot  by the service dockerd-configuration-file.service on Ubuntu 16.04 do not take effect until the next reboot.  

Goal is to use one dockerd configuration file with dockerd flags for both Ubuntu 16.04 (systemd) and Ubuntu 14.04 (Upstart).  

Running setup-dockerd.sh will create or change the /etc/systemd/system/docker.service.d/override.conf file (Ubuntu 16.04, systemd) and (or, see comment below) the /etc/default/docker (Ubuntu 14.04, Upstart).  To change the docker daemon flags, edit the /etc/docker/dockerd-configuration-file and run sudo /etc/docker/setup-dockerd.sh.  Docker daemon flag changes can be distributed to any Ubuntu cluster by copying /etc/docker/dockerd-configuration-file to each system and running setup-dockerd.sh on each system.  This has not been tested for other Linux OS's. 

Comment: May need to add code in setup-dockerd.sh for :
 if statements for checking which OS of the system is by using the follow command lsb_release -r -s
 Not sure this is need other than to the echo statement are missleading , also this would prevent other OS's from using these scripts, so maybe not do this ... need to think through this  ... but near the end of the setup-dockerd.sh file it calls systemctl daemon-reload and that may error on Ubuntu 14.04

1) Download files:
    
440	10-override.begin - beginning default lines for /etc/systemd/system/docker.service.d/10-override.conf file used by systemd docker.service.  Other lines for /etc/systemd/system/docker.service.d/10-override.conf file are created by running /etc/docker/start-dockerd-with-systemd.sh.

640	dockerd-configuration-file - dockerd option file for setting DOCKER_OPTS= environment variable to be added to Ubuntu 14.04 (upstart) in /etc/default/docker file and Ubuntu 16.04 (systemd) in /etc/systemd/system/docker.service.d/10-override.conf

644 dockerd-configuration-file.service

dockerd-configuration-file.upstart

setup-dockerd-configuration-file

-rw-rw-r-- 1 uadmin uadmin  275 Jan 15 20:21 10-override.begin
-rw-rw-r-- 1 uadmin uadmin 4084 Jan 15 20:21 dockerd-configuration-file
-rw-rw-r-- 1 uadmin uadmin  604 Jan 15 20:21 dockerd-configuration-file.service
-rw-rw-r-- 1 uadmin uadmin 3122 Jan 15 20:21 README.md
-rwxrwxr-x 1 uadmin uadmin 5599 Jan 15 20:21 setup-dockerd.sh
-rw-rw-r-- 1 uadmin uadmin  146 Jan 15 20:21 start-dockerd-with-systemd.begin
-rw-rw-r-- 1 uadmin uadmin 2057 Jan 15 20:21 start-dockerd-with-systemd.end

2) Append dockerd-configuration-file to /etc/default/docker for ubuntu 14.04 upstart docker daemon
3) Run dockerd-configuration-file.service as a service to create $OVERRIDE_FILE before sudo systemctl start docker so this service is a pre-req of docker.service will need to add that to dockerd-configuration-file.service

## System OS script tested

    Ubuntu 14.04.3 LTS
    Ubuntu 16.04.3 LTS

## Install

To install, change directory to the location you want to download the scripts. Use git to pull or clone these scripts into the directory. If you do not have git then enter; "sudo apt-get install git". On the github page of this script use the "HTTPS clone URL" with the 'git clone' command.

    git clone https://github.com/BradleyA/docker-scripts
    cd docker-scripts/dockerd-configuration-options
    sudo ./setup-dockerd.sh

#### Note:
	echo "DOCKER_OPTS="\"$DOCKER_OPTS\" >> $OVERRIDE_FILE

#### Design Principles
 * Have a simple setup process and a minimal learning curve
 * Be usable as non-root - [failed- must us sudo ]
 * Be easy to install and configure

## License::

Permission is hereby granted, free of charge, to any person obtaining a copy of this software, associated documentation, and files (the "Software") without restriction, including without limitation of rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
