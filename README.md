# docker-security-infrastructure
[![GitHub Stable Release](https://img.shields.io/badge/Release-4.1-blue.svg)](https://github.com/BradleyA/docker-security-infrastructure/releases/tag/4.1)
![GitHub Release Date](https://img.shields.io/github/release-date/BradleyA/docker-security-infrastructure?color=blue)
[![GitHub Commits Since](https://img.shields.io/github/commits-since/BradleyA/docker-security-infrastructure/4.1?color=orange)](https://github.com/BradleyA/docker-security-infrastructure/commits/)
[![GitHub Last Commits](https://img.shields.io/github/last-commit/BradleyA/docker-security-infrastructure.svg)](https://github.com/BradleyA/docker-security-infrastructure/commits/)

[![Open GitHub Issue](https://img.shields.io/badge/Open-Incident-brightgreen.svg)](https://github.com/BradleyA/docker-security-infrastructure/issues/new/choose)
[![GitHub Open Issues](https://img.shields.io/github/issues/BradleyA/docker-security-infrastructure?color=purple)](https://github.com/BradleyA/docker-security-infrastructure/issues?q=is%3Aopen+is%3Aissue)
[![GitHub Closed Issues](https://img.shields.io/github/issues-closed/BradleyA/docker-security-infrastructure?color=purple)](https://github.com/BradleyA/docker-security-infrastructure/issues?q=is%3Aclosed+is%3Aissue)

[<img alt="GitHub Clones" src="https://img.shields.io/static/v1?label=Clones&message=421&color=blueviolet">](https://github.com/BradleyA/docker-security-infrastructure/blob/master/images/clone.table.md)
[<img alt="GitHub Views" src="https://img.shields.io/static/v1?label=Views&message=2452&color=blueviolet">](https://github.com/BradleyA/docker-security-infrastructure/blob/master/images/view.table.md)
[![GitHub Size](https://img.shields.io/github/repo-size/BradleyA/docker-security-infrastructure.svg)](https://github.com/BradleyA/docker-security-infrastructure/)
![Language Bash](https://img.shields.io/badge/%20Language-bash-blue.svg)
[![MIT License](http://img.shields.io/badge/License-MIT-blue.png)](LICENSE)

----

This repository contains shell scripts that check user ssh permissions, setup and manage both TLS and dockerd on Ubuntu 14.04 (upstart) and Ubuntu 16.04 (systemd).  Most scripts in this repository support --help and --usage options.
  
#### If you like this repository, select in the upper-right corner, [![GitHub stars](https://img.shields.io/github/stars/BradleyA/docker-security-infrastructure.svg?style=social&label=Star&maxAge=2592000)](https://GitHub.com/BradleyA/docker-security-infrastructure/stargazers/), thank you.

----

These bash scripts will create, copy, and check TLS public keys, private keys, and self-signed certificates for the docker user, daemon, and docker swarm. 
 * [docker-TLS](https://github.com/BradleyA/docker-security-infrastructure/tree/master/docker-TLS)
 
Setup a dockerd configuration file with dockerd flags for both systemd and Upstart.
 
 * [dockerd-configuration-options](https://github.com/BradleyA/docker-security-infrastructure/tree/master/dockerd-configuration-options)

These bash scripts allows users and administrators to make sure that the ssh files and directory permissions are correct.

 * [ssh](https://github.com/BradleyA/docker-security-infrastructure/tree/master/ssh)
 
[Return to top](https://github.com/BradleyA/docker-security-infrastructure/blob/master/README.md#docker-security-infrastructure)

## Clone

To Install, change into a directory that you want to download the scripts. Use git to pull or clone these scripts into the directory. If you do not have Git installed then enter; "sudo apt-get install git" if using Debian/Ubuntu. Other Linux distribution install methods can be found here: https://git-scm.com/download/linux. On the GitHub page of this script use the "HTTPS clone URL" with the 'git clone' command.

     git clone https://github.com/BradleyA/docker-security-infrastructure
     cd docker-security-infrastructure

[Return to top](https://github.com/BradleyA/docker-security-infrastructure/blob/master/README.md#docker-security-infrastructure)

#### Docker security links
 * [Docker Bench for Security](https://github.com/docker/docker-bench-security)
 * [Kubernetes Benchmark](https://github.com/aquasecurity/kube-bench)
 * [Center for Internet Security](https://www.cisecurity.org/)
 * [Notary](https://github.com/theupdateframework/notary)
 * [Clair](https://github.com/coreos/clair)
 * [Falco](https://sysdig.com/opensource/falco/)
 * [Cilium](https://github.com/cilium/cilium)
 * [Docker Security Tutorials](https://github.com/docker/labs/blob/master/security/README.md)
 * [Dagda](https://github.com/eliasgranderubio/dagda)
 * [Dockscan](https://github.com/kost/dockscan)
 * [Docker Enterprise Edition Compliance Controls](https://github.com/docker/compliance)
 * [Calico](https://www.projectcalico.org/)
 * [AppArmor](https://gitlab.com/apparmor/apparmor/wikis/home/)
 * [Hashicorp’s Vault](https://www.vaultproject.io/)
 * [OpenSCAP](https://www.open-scap.org/)
 * [Open Policy Agent](https://www.openpolicyagent.org/)
 * [REMnux](https://remnux.org/)
 * [SELinux](https://selinuxproject.org/page/Main_Page)
 * [Seccomp](https://www.kernel.org/doc/Documentation/prctl/seccomp_filter.txt)
 * [Anchore Engine](https://github.com/anchore/anchore-engine)
 * [AquaSec](https://www.aquasec.com/)
 * [Capsule8](https://capsule8.com/)
 * [Cavirin](https://cavirin.com/)
 * [Aporeto](https://www.aporeto.com/)
 * [Google Cloud Security Command Center](https://cloud.google.com/security-command-center/)
 * [Layered Insight](https://layeredinsight.com/)
 * [NeuVector](https://neuvector.com/)
 * [StackRox](https://www.stackrox.com/)
 * [Sysdig Secure](https://sysdig.com/products/secure/)
 * [Sysdig](https://sysdig.com/)
 * [Tenable - FlawCheck](https://www.tenable.com/products/tenable-io/container-security)

[Return to top](https://github.com/BradleyA/docker-security-infrastructure/blob/master/README.md#docker-security-infrastructure)

#### To watch future updates in this repository select in the upper-right corner, the "Watch" list, and select Watching.

----

#### Contribute
Please do contribute!  Issues and pull requests are welcome.  Thank you for your help improving software.

[Return to top](https://github.com/BradleyA/docker-security-infrastructure/blob/master/README.md#docker-security-infrastructure)

#### Author
[<img id="github" src="images/github.png" width="50" a="https://github.com/BradleyA/">](https://github.com/BradleyA/)    [<img src="images/linkedin.png" style="max-width:100%;" >](https://www.linkedin.com/in/bradleyhallen) [<img id="twitter" src="images/twitter.png" width="50" a="twitter.com/bradleyaustintx/">](https://twitter.com/bradleyaustintx/)       <a href="https://twitter.com/intent/follow?screen_name=bradleyaustintx"> <img src="https://img.shields.io/twitter/follow/bradleyaustintx.svg?label=Follow%20@bradleyaustintx" alt="Follow @bradleyaustintx" />    </a>         [![GitHub followers](https://img.shields.io/github/followers/BradleyA.svg?style=social&label=Follow&maxAge=2592000)](https://github.com/BradleyA?tab=followers)

[Return to top](https://github.com/BradleyA/docker-security-infrastructure/blob/master/README.md#docker-security-infrastructure)

#### System OS script tested
 * Ubuntu 14.04.6 LTS (amd64,armv7l)
 * Ubuntu 16.04.7 LTS (amd64,armv7l)
 * Ubuntu 18.04.5 LTS (amd64,armv7l)
 * Raspbian GNU/Linux 10 (buster)

[Return to top](https://github.com/BradleyA/docker-security-infrastructure/blob/master/README.md#docker-security-infrastructure)

#### Design Principles
 * Have a simple setup process and a minimal learning curve
 * Be usable as non-root - [some of these scripts require root]
 * Be easy to install and configure
 
[Return to top](https://github.com/BradleyA/docker-security-infrastructure/blob/master/README.md#docker-security-infrastructure)

#### License
MIT License

Copyright (c) 2020  [Bradley Allen](https://www.linkedin.com/in/bradleyhallen)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[Return to top](https://github.com/BradleyA/docker-security-infrastructure/blob/master/README.md#docker-security-infrastructure)
