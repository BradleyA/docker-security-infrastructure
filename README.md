# docker-security-infrastructure   [![Stable Release](https://img.shields.io/badge/Release-3.234-blue.svg)](https://github.com/BradleyA/docker-security-infrastructure/releases/tag/3.234)    [![GitHub commits](https://img.shields.io/github/commits-since/BradleyA/docker-security-infrastructure/3.234.svg)](https://github.com/BradleyA/docker-security-infrastructure/commits/)
This repository contains shell scripts that check user ssh permissions, setup and manage both TLS and dockerd on Ubuntu 14.04 (upstart) and Ubuntu 16.04 (systemd).

 * [docker-TLS](https://github.com/BradleyA/docker-security-infrastructure/tree/master/docker-TLS)
 * [dockerd-configuration-options](https://github.com/BradleyA/docker-security-infrastructure/tree/master/dockerd-configuration-options)
 * [ssh](https://github.com/BradleyA/docker-security-infrastructure/tree/master/ssh)
  ##### Docker security links
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
  
#### If you like this repository, select in the upper-right corner,  STAR,  thank you.

## Install

To install, change to the location you want to download the scripts. Use git to pull or clone these scripts into the directory. If you do not have git then enter; "sudo apt-get install git". On the github repository page of this script use the "Clone with HTTPS" URL with the 'git clone' command.

    git clone https://github.com/BradleyA/docker-security-infrastructure.git
    cd docker-security-infrastructure

#### To watch future updates in this repository select in the upper-right corner, the "Watch" list, and select Watching.

#### Author
[<img id="twitter" src="images/twitter.png" width="50" a="twitter.com/bradleyaustintx/">
](https://twitter.com/bradleyaustintx/)   [<img id="github" src="images/github.png" width="50" a="https://github.com/BradleyA/">
](https://github.com/BradleyA/)    [<img src="images/linkedin.png" style="max-width:100%;" >](https://www.linkedin.com/in/bradleyhallen)

#### System OS script tested
 * Ubuntu 14.04.3 LTS
 * Ubuntu 16.04.3 LTS (armv7l)

#### Design Principles
 * Have a simple setup process and a minimal learning curve
 * Be usable as non-root - [some of these scripts require root]
 * Be easy to install and configure

## License
MIT License

Copyright (c) 2019  [Bradley Allen](https://www.linkedin.com/in/bradleyhallen)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
