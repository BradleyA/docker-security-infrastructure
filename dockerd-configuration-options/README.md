# dockerd-configuration-options/

#### WARNING: These instructions are incomplete. Consider them as notes quickly drafted on a napkin rather than proper documentation!
#### Need to clean this up once I get everything working for Ubuntu 14.04 and Ubuntu 16.04

The docker daemon flags will be written to /etc/systemd/system/docker.service.d/override.conf by default for Ubuntu 16.04 (systemd) and /etc/default/docker for Ubuntu 14.04 (Upstart).

Goal is to use one dockerd configuration file with dockerd flags for Ubuntu 16.04 (systemd) and /etc/default/docker for Ubuntu 14.04 (Upstart).

1) Download files:
    
440	10-override.begin - beginning default lines for /etc/systemd/system/docker.service.d/10-override.conf file used by docker.service.  Other lines for /etc/systemd/system/docker.service.d/10-override.conf file created by /etc/docker/start-dockerd-with-systemd.sh which runs dockerd-configuration-file.service 

640	dockerd-configuration-file - dockerd option file for setting DOCKER_OPTS= environment variable to be added to Ubuntu 14.04 (upstart) in /etc/default/docker file and Ubuntu 16.04 (systemd) in /etc/docker/start-dockerd-with-systemd.sh script

644 dockerd-configuration-file.service

dockerd-configuration-file.upstart

setup-dockerd-configuration-file

70-debug.conf

2) Append dockerd-configuration-file to /etc/default/docker for ubuntu 14.04 upstart docker daemon
3) Run dockerd-configuration-file.service as a service to create $OVERRIDE_FILE before sudo systemctl start docker so this service is a pre-req of docker.service will need to add that to dockerd-configuration-file.service

## System OS script tested

    Ubuntu 14.04.3 LTS
    Ubuntu 16.04.3 LTS

## Install

To install, change directory to the location you want to download the scripts. Use git to pull or clone these scripts into the directory. If you do not have git then enter; "sudo apt-get install git". On the github page of this script use the "HTTPS clone URL" with the 'git clone' command.

    git clone https://github.com/BradleyA/docker-scripts
    cd docker-scripts

#### Note:
	echo "DOCKER_OPTS="\"$DOCKER_OPTS\" >> $OVERRIDE_FILE

#### Design Principles
 * Have a simple setup process and a minimal learning curve
 * Be usable as non-root - [failed- must us sudo ]
 * Be easy to install and configure

## License::

Permission is hereby granted, free of charge, to any person obtaining a copy of this software, associated documentation, and files (the "Software") without restriction, including without limitation of rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
