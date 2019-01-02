## docker-scripts
This repository contains shell scripts that check user ssh permissions, setup and manage both TLS and dockerd on Ubuntu 14.04 (upstart) and Ubuntu 16.04 (systemd).

 * [docker-TLS](https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS)
 * [dockerd-configuration-options](https://github.com/BradleyA/docker-scripts/tree/master/dockerd-configuration-options)
 * [ssh](https://github.com/BradleyA/docker-scripts/tree/master/ssh)

### Clone

To install, change to the location you want to download the scripts. Use git to pull or clone these scripts into the directory. If you do not have git then enter; "sudo apt-get install git". On the github repository page of this script use the "Clone with HTTPS" URL with the 'git clone' command.

    git clone https://github.com/BradleyA/docker-scripts
    cd docker-scripts
 
### System OS script tested
 * Ubuntu 14.04.3 LTS
 * Ubuntu 16.04.3 LTS (armv7l)

### Design Principles
 * Have a simple setup process and a minimal learning curve
 * Be usable as non-root - [some of these scripts require root]
 * Be easy to install and configure

## License
MIT License

Copyright  2019  Bradley Allen

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
